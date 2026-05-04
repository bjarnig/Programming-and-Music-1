////////////////////////////////////////////////////////////////
//
//                            MIDI
//
////////////////////////////////////////////////////////////////


External control with MIDI.
Covers basic input, mapping strategies, velocity/direction
extensions, and pattern integration.


///////////////////////// MIDIClient ///////////////////////////


MIDIClient.init;

MIDIIn.connectAll;


////////////////////////// MIDIFunc ////////////////////////////


// Post all incoming note messages

MIDIFunc.noteOn({|...args| args.postln});


// Store reference and free it

a = MIDIFunc.noteOn({|...args| args.postln});
a.free


// Respond only to a specific note

a = MIDIFunc.noteOn({|velocity, note| note.postln}, 57, 0);
a.free;


// Range of notes

a = MIDIFunc.noteOn({|velocity, note| note.postln}, (48..72));
a.free;


// Post CC messages

MIDIFunc.cc({|...args| args.postln})



///////////////////////// CC Control ///////////////////////////


// CC controlling resonant body

(
Routine {
	var synth;

	SynthDef(\resBody, {|freq=400, decay=0.3|
		var sig = DynKlank.ar(
			`[[freq, freq*2.7, freq*4.3], nil, [decay, decay*0.5, decay*0.3]],
			Dust.ar(8) * 0.05
		);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\resBody);

	MIDIFunc.cc({|val|
		synth.set(\freq, val.linexp(1, 127, 60, 4000).postln);
	});

}.play
)


// Two CCs with ControlSpec

(
Routine {
	var synth;

	SynthDef(\crackDust, {|freq=200, rq=1|
		var sig = Ringz.ar(Dust.ar(80), freq, rq * 0.01, 0.5);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\crackDust);

	MIDIFunc.cc({|val, num|
		var spec = ControlSpec(40, 8000, \exponential);

		if(num == 5, {
			synth.set(\freq, spec.map(val / 127.0).postln)
		});

		if(num == 6, {
			synth.set(\rq, val.linexp(0, 127, 0.1, 4.0).postln);
		});
	});

}.play
)



/////////////////// Trigger Synths /////////////////////////////


// Note numbers trigger resonant impulses

(
SynthDef(\reso, {|out=0, note=60, amp=0.5|
	var sig, env, freq;
	freq = note.midicps;
	env = EnvGen.ar(Env.perc(0.001, 2), doneAction: 2);
	sig = Ringz.ar(Impulse.ar(0), [freq, freq * 2.73, freq * 5.1], [0.5, 0.3, 0.15]).sum;
	Out.ar(out, sig * amp * env * 0.2 ! 2);
}).add;

MIDIFunc.noteOn({|val, num|
	Synth(\reso, [\note, num, \amp, val.linlin(0, 127, 0.3, 1.0)])
})
)


// Polyphonic with chaotic overtones

(
var notes = Array.newClear(128);

SynthDef(\chaoKeys, {|note=60, amp=0.3, gate=1|
	var freq = note.midicps;
	var sig = SinOsc.ar(freq) + SinOsc.ar(freq * 1.0013);
	sig = sig + (SinOsc.ar(freq * Crackle.kr(1.5).range(1.99, 2.01)) * 0.3);
	Out.ar(0, sig * amp * 0.15 * Linen.kr(gate, 0.01, 1, 1.5, doneAction: 2) ! 2);
}).add;

MIDIFunc.noteOn({|vel, num|
	if(notes[num].isNil, {
		notes[num] = Synth(\chaoKeys, [
			\note, num,
			\amp, vel.linlin(0, 127, 0.0, 1.0)
		])
	})
});

MIDIFunc.noteOff({|vel, num|
	if(notes[num].notNil, {
		notes[num].set(\gate, 0);
		notes[num] = nil
	})
});
)


// Polyphonic cross-FM with pitch bend

(
~bend = 0;
~group = Group();
~notes = Array.newClear(128);
MIDIdef.freeAll;

SynthDef(\xfmKeys, {|freq=220, gate=1, amp=0.2, bend=0|
	var sig, env, fbIn;
	env = Env.asr(0.01, 1, 0.8).kr(2, gate);
	fbIn = LocalIn.ar(1);
	sig = SinOsc.ar(freq * bend.midiratio + (fbIn * freq * 2));
	LocalOut.ar(SinOsc.ar(freq * 1.37 + (sig * freq * 1.5)) * 0.3);
	Out.ar(0, LeakDC.ar(sig) * env * amp ! 2);
}).add;

MIDIdef.noteOn(\on, {|val, num|
	~notes.put(num,
		Synth(\xfmKeys, [
			\freq, num.midicps,
			\amp, val.linexp(0, 127, 0.01, 0.2),
			\bend, ~bend
		], ~group)
	);
});

MIDIdef.noteOff(\off, {|val, num|
	~notes[num].set(\gate, 0);
	~notes.put(num, nil);
});

MIDIdef.bend(\pitchbend, {|val|
	~bend = val.linlin(0, 16383, -2, 2);
	~group.set(\bend, ~bend);
});
)



////////////////// Transfer Functions //////////////////////////


// linexp: linear input, exponential output

(
Routine {
	var synth;

	SynthDef(\impulseRes, {|freq=100|
		var sig = DynKlank.ar(
			`[[freq, freq * 3.1, freq * 7.3], nil, [0.3, 0.1, 0.05]],
			Impulse.ar(freq * 0.02) * 0.1
		);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\impulseRes);

	MIDIFunc.cc({|val|
		synth.set(\freq, val.linexp(0, 127, 30, 3000).postln);
	});

}.play
)


// Custom envelope as transfer function

(
Routine {
	var synth;

	SynthDef(\filtNoise, {|freq=1000, rq=0.2|
		var sig = BPF.ar(BrownNoise.ar(0.1), freq, rq);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\filtNoise);

	MIDIFunc.cc({|val|
		var env = Env.new([0, 0.1, 0.7, 0.8, 1.0] * 4000, [0.2, 0.4, 0.3, 0.1]);
		synth.set(\freq, env[val / 127.0]);
	});

}.play
)


// One CC to many parameters

(
Routine {
	var synth;

	SynthDef(\filtNoiseB, {|freq=1000, rq=0.2|
		var sig = BPF.ar(BrownNoise.ar(0.1), freq, rq);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\filtNoiseB);

	MIDIFunc.cc({|val|
		var enva = Env.new([0, 0.1, 0.7, 0.8, 1.0] * 3000, [0.2, 0.4, 0.3, 0.1]);
		var envb = Env.new([0, 0.1, 0.7, 0.8, 1.0] * 2, [0.2, 0.4, 0.3, 0.1]);
		synth.set(\freq, enva.at(val / 127.0));
		synth.set(\rq, envb.at(val / 127.0));
	});

}.play
)



/////////////// Post-Processing: Lag and Latch /////////////////


// Lag smooths abrupt CC changes

(
Routine {
	var synth;

	SynthDef(\lagRes, {|freq=200|
		var control = Lag.kr(freq, 3.0);
		var sig = Ringz.ar(Dust.ar(20), control, 0.1, 0.3);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\lagRes);

	MIDIFunc.cc({|val|
		synth.set(\freq, val.linexp(0, 127, 60, 8000).postln);
	});

}.play
)


// Latch for sample-and-hold quantization

(
Routine {
	var synth;

	SynthDef(\latchSaw, {|freq=200|
		var control = Latch.kr(freq, Impulse.kr(2));
		var sig = LFSaw.ar(control) * 0.15;
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\latchSaw);

	MIDIFunc.cc({|val|
		synth.set(\freq, val.linlin(0, 127, 30, 2000).postln);
	});

}.play
)



///////////////// Speed and Direction //////////////////////////


// Direction selects filter mode: up = LPF, down = HPF

(
Routine {
	var synth, lastVal = 0;

	SynthDef(\dirFilt, {|freq=400, amp=0.3, ffreq=2000, mode=0|
		var sig, lo, hi;
		sig = PinkNoise.ar;
		lo = LPF.ar(sig, ffreq);
		hi = HPF.ar(sig, ffreq);
		sig = SelectX.ar(mode, [lo, hi]);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\dirFilt);

	MIDIFunc.cc({|val|
		var direction = (val - lastVal).sign;
		lastVal = val;

		synth.set(\ffreq, val.linexp(0, 127, 200, 8000));

		case
		{ direction > 0 } { synth.set(\mode, 0); "UP -> LPF".postln }
		{ direction < 0 } { synth.set(\mode, 1); "DOWN -> HPF".postln };
	});

}.play
)


// Direction and speed trigger resonant pings

(
Routine {
	var lastVal, lastTime;
	lastVal = 0;
	lastTime = Main.elapsedTime;

	SynthDef(\ping, {|freq=800, amp=0.3, pan=0|
		var sig, env;
		env = EnvGen.ar(Env.perc(0.001, 0.4), doneAction: 2);
		sig = Ringz.ar(Impulse.ar(0), freq, 0.2);
		Out.ar(0, Pan2.ar(sig * env * amp, pan));
	}).add;

	s.sync;

	MIDIFunc.cc({|val|
		var direction, speed, delta, now;
		now = Main.elapsedTime;
		delta = now - lastTime;
		direction = (val - lastVal).sign;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastVal = val;
		lastTime = now;

		if(speed > 100, {
			Synth(\ping, [
				\freq, val.linexp(0, 127, 80, 6000),
				\amp, speed.linlin(100, 500, 0.05, 0.3).clip(0.05, 0.3),
				\pan, direction
			]);
		});
	});

}.play
)


// Drunk walk drifts around the CC target

(
Routine {
	var synth, drunkPos, stepSize, tendency;
	drunkPos = 64.0;
	stepSize = 5;
	tendency = 0.3;

	SynthDef(\drunk, {|freq=400, amp=0.3|
		var sig = LFTri.ar(freq);
		sig = RLPF.ar(sig, freq * 3, 0.4);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\drunk);

	MIDIFunc.cc({|val|
		var pull, step, freq;
		pull = (val - drunkPos) * tendency;
		step = rrand(stepSize.neg.asFloat, stepSize.asFloat);
		drunkPos = (drunkPos + pull + step).clip(0, 127);
		freq = drunkPos.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		("target:" + val + "drunk:" + drunkPos.round(0.1)).postln;
	});

}.play
)



////////////////// MIDI and Patterns ///////////////////////////


// PatternProxy allows live CC control of pattern parameters

(
var pattern, notes;

notes = PatternProxy(Pwhite(20, 80));
pattern = Pbind(\midinote, notes, \dur, 0.2).play;

MIDIFunc.cc({|val|
	notes.source = Pwhite(val / 2, val);
})
)


// CC controls granular density and pitch spread

(
var clock = TempoClock(2), ccFreq = 60, ccDensity = 4;

SynthDef(\grain, {|freq=400, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, 0.08), doneAction: 2);
	sig = Ringz.ar(Impulse.ar(0), freq, 0.05) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(
	\instrument, \grain,
	\midinote, Pfunc { ccFreq + rrand(-7, 7) },
	\dur, Pfunc { 1 / ccDensity },
	\pan, Pwhite(-0.8, 0.8),
	\amp, 0.3
).play(clock);

MIDIFunc.cc({|val, num|
	if(num == 1, { ccFreq = val.linlin(0, 127, 30, 110).postln });
	if(num == 2, { ccDensity = val.linlin(0, 127, 1, 64).postln });
})
)


// CC crossfades between two pattern layers

(
var clock = TempoClock(2.5), mix = 0.5;

SynthDef(\clickTone, {|freq=400, amp=0.2, pan=0, rel=0.3|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
	sig = Ringz.ar(Impulse.ar(0), freq, rel * 0.5) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

// Layer A: sparse resonant pings

Pbind(
	\instrument, \clickTone,
	\freq, Pxrand([137, 311, 523, 89, 173], inf),
	\dur, 0.25,
	\amp, Pfunc { (1 - mix) * 0.4 }
).play(clock);

// Layer B: dense noise grains

Pbind(
	\instrument, \clickTone,
	\freq, Pwhite(800, 8000),
	\dur, Pwhite(0.02, 0.1),
	\rel, Pwhite(0.01, 0.08),
	\amp, Pfunc { mix * 0.15 },
	\pan, Pwhite(-1.0, 1.0)
).play(clock);

MIDIFunc.cc({|val|
	mix = (val / 127.0).postln;
})
)