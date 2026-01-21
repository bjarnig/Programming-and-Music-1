////////////////////////////////////////////////////////////////
//
//               Synths and Routines
//
////////////////////////////////////////////////////////////////

/*
   Combining synthesis concepts (classes 09-11) with
   temporal control using Routines, Tasks and Clocks (classes 08, 12).
*/


////////////////////////// SynthDefs ////////////////////////////


( // Simple sine with percussive envelope

SynthDef(\percSine, {|freq=440, amp=0.2, rel=0.3|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, sig ! 2);
}).add;

)


( // Filtered saw wave - subtractive synthesis

SynthDef(\filtSaw, {|freq=100, cutoff=1000, res=0.3, amp=0.3, rel=0.5|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = Saw.ar(freq);
	sig = RLPF.ar(sig, cutoff, res);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


( // Filtered noise - percussive hit

SynthDef(\filtNoise, {|freq=800, bw=0.1, amp=0.3, rel=0.2|
	var env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
	var sig = WhiteNoise.ar;
	sig = BPF.ar(sig, freq, bw, 3);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


( // FM synthesis - bell-like

SynthDef(\fmBell, {|freq=440, ratio=1.4, index=5, amp=0.2, rel=2|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var indexEnv = EnvGen.ar(Env.perc(0.01, rel * 0.5)) * index;
	var modFreq = freq * ratio;
	var mod = SinOsc.ar(modFreq, mul: modFreq * indexEnv);
	var sig = SinOsc.ar(freq + mod);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


( // Ring modulation

SynthDef(\ringMod, {|freq=300, modFreq=150, amp=0.2, rel=0.5|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var carrier = SinOsc.ar(freq);
	var modulator = SinOsc.ar(modFreq);
	var sig = carrier * modulator;
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


( // Waveshaping with fold

SynthDef(\foldSine, {|freq=100, foldAmt=2, amp=0.2, rel=0.4|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * foldAmt;
	sig = sig.fold2(1);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


( // Pulse with PWM

SynthDef(\pwm, {|freq=100, width=0.5, amp=0.2, rel=0.3|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = Pulse.ar(freq, width, amp);
	Out.ar(0, sig * env ! 2);
}).add;

)


( // Additive synthesis - 5 harmonics

SynthDef(\additive, {|freq=200, amp=0.2, rel=1|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = Mix.fill(5, {|i|
		SinOsc.ar(freq * (i + 1)) / (i + 1)
	});
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


////////////////////////// Simple Routines ////////////////////////////


( // Play a sequence of filtered saw notes

Routine({
	[60, 64, 67, 72, 67, 64].do {|note|
		Synth(\filtSaw, [\freq, note.midicps, \cutoff, 2000, \rel, 0.3]);
		0.25.wait;
	};
}).play;

)


( // Random FM bells

Routine({
	12.do {
		Synth(\fmBell, [
			\freq, rrand(200, 800),
			\ratio, [1.0, 1.4, 2.0, 2.5].choose,
			\index, rrand(2, 8),
			\rel, rrand(1, 3)
		]);
		rrand(0.3, 0.8).wait;
	};
}).play;

)


( // Filtered noise rhythm

Routine({
	16.do {|i|
		var freq = if(i % 4 == 0, 400, 1200);
		var amp = if(i % 4 == 0, 0.4, 0.2);
		Synth(\filtNoise, [\freq, freq, \amp, amp, \rel, 0.1]);
		0.125.wait;
	};
}).play;

)


////////////////////////// Routines with Arrays ////////////////////////////


( // Iterate through pitch array

var pitches = [60, 62, 64, 65, 67, 69, 71, 72];

Routine({
	pitches.do {|note|
		Synth(\percSine, [\freq, note.midicps, \rel, 0.2]);
		0.15.wait;
	};
}).play;

)


( // Two arrays: pitches and durations

var pitches = [48, 55, 60, 62, 64];
var durations = [0.5, 0.25, 0.25, 0.5, 1.0];

Routine({
	pitches.do {|note, i|
		Synth(\filtSaw, [\freq, note.midicps, \cutoff, 1500]);
		durations[i].wait;
	};
}).play;

)


( // Array with filter sweep

var notes = Array.series(16, 40, 2);

Routine({
	notes.do {|note, i|
		var cutoff = i.linexp(0, 15, 200, 4000);
		Synth(\filtSaw, [\freq, note.midicps, \cutoff, cutoff, \rel, 0.2]);
		0.1.wait;
	};
}).play;

)


////////////////////////// Routines with Conditionals ////////////////////////////


( // Every 4th note is different

Routine({
	24.do {|i|
		if(i % 4 == 0, {
			Synth(\fmBell, [\freq, 220, \rel, 1]);
		}, {
			Synth(\percSine, [\freq, rrand(400, 800), \rel, 0.1]);
		});
		0.2.wait;
	};
}).play;

)


( // Alternating synths based on coin flip

Routine({
	20.do {
		if(0.5.coin, {
			Synth(\ringMod, [\freq, rrand(200, 400), \modFreq, rrand(100, 200)]);
		}, {
			Synth(\foldSine, [\freq, rrand(80, 160), \foldAmt, rrand(1.5, 3)]);
		});
		rrand(0.1, 0.3).wait;
	};
}).play;

)


////////////////////////// Tasks ////////////////////////////


( // Task with pause/resume capability

~task = Task({
	inf.do {|i|
		Synth(\percSine, [\freq, (60 + (i % 12)).midicps, \rel, 0.2]);
		0.2.wait;
	};
});

)

~task.play;
~task.pause;
~task.resume;
~task.stop;


( // Task with external control variable

~dur = 0.2;
~note = 60;

~task = Task({
	inf.do {
		Synth(\filtSaw, [\freq, ~note.midicps, \cutoff, 1500, \rel, ~dur]);
		~dur.wait;
	};
});

)

~task.play;
~dur = 0.1;
~note = 72;
~dur = 0.05;
~task.stop;


////////////////////////// TempoClock ////////////////////////////


( // Routine with TempoClock at 120 BPM

var clock = TempoClock(2); // 2 beats per second = 120 BPM

Routine({
	16.do {|i|
		Synth(\filtNoise, [\freq, if(i % 4 == 0, 300, 800), \rel, 0.05]);
		0.25.wait; // quarter note at 120 BPM
	};
}).play(clock);

)


( // Multiple routines on same clock

var clock = TempoClock(100/60); // 100 BPM

// Bass line
Routine({
	inf.do {
		Synth(\filtSaw, [\freq, [40, 43, 45, 47].choose.midicps, \cutoff, 600, \rel, 0.3]);
		1.wait;
	};
}).play(clock);

// High melody
Routine({
	inf.do {
		Synth(\percSine, [\freq, rrand(72, 84).midicps, \rel, 0.1]);
		0.25.wait;
	};
}).play(clock);

)


( // Schedule routines to start at different times

var clock = TempoClock(90/60);

var bass = Routine({
	inf.do {
		Synth(\filtSaw, [\freq, 50.midicps, \cutoff, 800, \rel, 0.5]);
		2.wait;
	};
});

var melody = Routine({
	inf.do {
		Synth(\fmBell, [\freq, rrand(60, 72).midicps, \rel, 0.5]);
		0.5.wait;
	};
});

clock.sched(0, bass);   // bass starts immediately
clock.sched(4, melody); // melody starts after 4 beats

)


////////////////////////// Nested Loops ////////////////////////////


( // Outer loop for sections, inner for notes

Routine({
	4.do {|section|
		var baseNote = 48 + (section * 5);
		("Section" + (section + 1)).postln;

		8.do {|i|
			Synth(\percSine, [\freq, (baseNote + i).midicps, \rel, 0.15]);
			0.1.wait;
		};

		0.5.wait; // pause between sections
	};
}).play;

)


( // Nested loops with different synths per section

Routine({
	[\percSine, \filtSaw, \fmBell, \ringMod].do {|synth, section|
		("Playing:" + synth).postln;

		6.do {|i|
			Synth(synth, [\freq, rrand(200, 600), \rel, 0.3]);
			0.2.wait;
		};

		0.5.wait;
	};
}).play;

)


////////////////////////// Envelopes for Shaping ////////////////////////////


( // Use Env to shape pitch over time

Routine({
	var pitchEnv = Env([60, 72, 48, 84], [10, 10, 10]);
	var durEnv = Env([0.05, 0.3, 0.1, 0.5], [10, 10, 10]);

	30.do {|i|
		var note = pitchEnv[i];
		var dur = durEnv[i];
		Synth(\percSine, [\freq, note.midicps, \rel, dur]);
		dur.wait;
	};
}).play;

)


( // Envelope for filter cutoff

Routine({
	var cutoffEnv = Env([200, 4000, 500, 2000], [8, 8, 8]);

	24.do {|i|
		var cutoff = cutoffEnv[i];
		Synth(\filtSaw, [\freq, 60.midicps, \cutoff, cutoff, \rel, 0.2]);
		0.15.wait;
	};
}).play;

)


////////////////////////// Multiple Independent Routines ////////////////////////////


( // Create many routines at once - textural clouds

10.do {
	Routine({
		inf.do {
			Synth(\percSine, [
				\freq, exprand(200, 2000),
				\amp, rrand(0.02, 0.08),
				\rel, rrand(0.05, 0.3)
			]);
			rrand(0.05, 0.5).wait;
		};
	}).play;
};

)


( // Layered textures with different synths

// High sine layer
5.do {
	Routine({
		inf.do {
			Synth(\percSine, [\freq, exprand(800, 4000), \amp, 0.05, \rel, 0.1]);
			rrand(0.1, 0.4).wait;
		};
	}).play;
};

// Mid FM layer
3.do {
	Routine({
		inf.do {
			Synth(\fmBell, [\freq, exprand(200, 600), \amp, 0.1, \rel, 1]);
			rrand(0.5, 2).wait;
		};
	}).play;
};

// Low filtered saw layer
2.do {
	Routine({
		inf.do {
			Synth(\filtSaw, [\freq, exprand(40, 100), \cutoff, rrand(200, 800), \amp, 0.15, \rel, 0.5]);
			rrand(0.3, 1).wait;
		};
	}).play;
};

)


////////////////////////// Pattern Streams in Routines ////////////////////////////


( // Use pattern as value generator

var pitchStream = Pbrown(48, 72, 3, inf).asStream;
var durStream = Pwhite(0.05, 0.3, inf).asStream;

Routine({
	30.do {
		var note = pitchStream.next;
		var dur = durStream.next;
		Synth(\filtSaw, [\freq, note.midicps, \cutoff, 1200, \rel, dur]);
		dur.wait;
	};
}).play;

)


( // Multiple pattern streams

var noteStream = Pseq([60, 62, 64, 67, 72, 67, 64, 62], inf).asStream;
var cutoffStream = Pseries(500, 100, inf).asStream;
var durStream = Pseq([0.2, 0.1, 0.1, 0.4], inf).asStream;

Routine({
	32.do {
		Synth(\filtSaw, [
			\freq, noteStream.next.midicps,
			\cutoff, cutoffStream.next.min(4000),
			\rel, 0.2
		]);
		durStream.next.wait;
	};
}).play;

)
