////////////////////////////////////////////////////////////////
//
//                        Routing
//
////////////////////////////////////////////////////////////////


s.boot; s.plotTree;

// SynthDefs

(
SynthDef(\src, { |out = 0, freq = 220, amp = 0.2|
	Out.ar(out, Saw.ar(freq * [1, 1.003], amp));
}).add;

SynthDef(\listener, { |in = 16, out = 0|
	Out.ar(out, In.ar(in, 2));
}).add;

SynthDef(\insertLPF, { |bus = 0, freq = 1000, rq = 0.3|
	ReplaceOut.ar(bus, RLPF.ar(In.ar(bus, 2), freq, rq));
}).add;

SynthDef(\insertCrush, { |bus = 0, bits = 4, rate = 8000|
	var sig = In.ar(bus, 2);
	sig = Latch.ar(sig.round(0.5 ** bits), Impulse.ar(rate));
	ReplaceOut.ar(bus, sig);
}).add;

SynthDef(\xfadeSat, { |bus = 0, rate = 0.2|
	var sig = In.ar(bus, 2);
	XOut.ar(bus, SinOsc.kr(rate).range(0, 1), (sig * 6).tanh);
}).add;

SynthDef(\click, { |out = 0, freq = 1000, amp = 0.5|
	var env = EnvGen.kr(Env.perc(0.001, 0.05), doneAction: 2);
	Out.ar(out, SinOsc.ar(freq, 0, amp * env) ! 2);
}).add;

SynthDef(\clickOffset, { |out = 0, freq = 1000, amp = 0.5|
	var env = EnvGen.kr(Env.perc(0.001, 0.05), doneAction: 2);
	OffsetOut.ar(out, SinOsc.ar(freq, 0, amp * env) ! 2);
}).add;

SynthDef(\monitor, { |in = 0, out = 0, amp = 0.5|
	Out.ar(out, SoundIn.ar(in, amp) ! 2);
}).add;

SynthDef(\micFilter, { |in = 0, out = 0, freq = 800, rq = 0.2, amp = 0.5|
	Out.ar(out, BPF.ar(SoundIn.ar(in), freq, rq, 3) * amp ! 2);
}).add;

SynthDef(\bass, { |out, freq = 55, amp = 0.3|
	Out.ar(out, RLPF.ar(LFSaw.ar(freq * [1, 1.004]) * amp, freq * 8, 0.4));
}).add;

SynthDef(\lead, { |out, freq = 440, amp = 0.15|
	Out.ar(out, Saw.ar(freq * [1, 1.007], amp));
}).add;

SynthDef(\reverb, { |in, out = 0, mix = 0.3, room = 0.7|
	var dry = In.ar(in, 2);
	Out.ar(out, (dry * (1 - mix)) + (FreeVerb.ar(dry, 1.0, room, 0.5) * mix));
}).add;

SynthDef(\masterComp, { |bus = 0, thresh = 0.6, amp = 0.9|
	ReplaceOut.ar(bus, Compander.ar(In.ar(bus, 2), In.ar(bus, 2),
		thresh, 1, 0.3, 0.005, 0.05) * amp);
}).add;
)


// 1. Out.ar + In.ar
// Out.ar ADDS to a bus. In.ar reads it. Route through a private bus.

~bus = 16;
(
~src = Synth(\src, [\out, ~bus, \freq, 300]);
~lst = Synth.after(~src, \listener, [\in, ~bus]);
)
~src.set(\freq, 440);
s.freeAll;

// Out.ar sums — multiple writers mix together on the same bus.
(
~a = Synth(\src, [\out, ~bus, \freq, 300, \amp, 0.15]);
~b = Synth(\src, [\out, ~bus, \freq, 451, \amp, 0.15]);
~c = Synth(\src, [\out, ~bus, \freq, 602, \amp, 0.15]);
~lst = Synth.tail(s, \listener, [\in, ~bus]);
)
s.freeAll;


// 2. SoundIn.ar
// Reads hardware input. SoundIn.ar(0) = first mic/interface channel.
// Use headphones to avoid feedback!

~mon = Synth(\monitor, [\in, 0, \amp, 0.5]);
~mon.free;

// Process mic through a filter
~fx = Synth(\micFilter, [\in, 0, \freq, 1200, \rq, 0.1]);
~fx.set(\freq, 400);
~fx.free;


// 3. Bus.audio
// Dynamic allocation — no hard-coded bus numbers.

~fxBus = Bus.audio(s, 2);
(
~src = Synth(\src, [\out, ~fxBus, \freq, 110]);
~proc = Synth.after(~src, \insertLPF, [\bus, ~fxBus, \freq, 800]);
~lst = Synth.tail(s, \listener, [\in, ~fxBus]);
)
~proc.set(\freq, 2500);
s.freeAll;
~fxBus.free;


// 4. Order of Execution
// Server processes HEAD → TAIL. Reader must be AFTER the writer.
// Default addAction is \addToHead (BEFORE existing synths).

~bus = Bus.audio(s, 2);

// WRONG — fx created second = new head = runs BEFORE src → silence
(
~src = Synth(\src, [\out, ~bus]);
~fx  = Synth(\insertLPF, [\bus, ~bus, \freq, 600]);
~lst = Synth(\listener, [\in, ~bus]);
)
s.queryAllNodes;
s.freeAll;

// RIGHT — explicit positioning
(
~src = Synth(\src, [\out, ~bus]);
~fx  = Synth.after(~src, \insertLPF, [\bus, ~bus, \freq, 600]);
~lst = Synth.tail(s, \listener, [\in, ~bus]);
)
s.queryAllNodes;
s.freeAll;
~bus.free;


// 5. ReplaceOut.ar
// Out.ar ADDS to the bus. ReplaceOut.ar OVERWRITES it.
// Use ReplaceOut for insert effects that read and write the same bus.

(
~src = Synth(\src, [\out, 0, \freq, 110, \amp, 0.3]);
~lpf = Synth.after(~src, \insertLPF, [\bus, 0, \freq, 600]);
~cr  = Synth.after(~lpf, \insertCrush, [\bus, 0, \bits, 3]);
)
~lpf.set(\freq, 2000);
~cr.set(\bits, 8);
~cr.run(false);  // bypass
~cr.run(true);
s.freeAll;


// 6. XOut.ar
// XOut.ar(bus, xfade, sig) — crossfade between bus contents and sig.
// 0 = fully dry, 1 = fully wet.

(
~src = Synth(\src, [\out, 0, \freq, 110, \amp, 0.3]);
~x   = Synth.after(~src, \xfadeSat, [\bus, 0, \rate, 0.3]);
)
~x.set(\rate, 2);
s.freeAll;


// 7. OffsetOut.ar
// Sample-accurate start time. Out.ar snaps to block boundaries (64 samples).
// Compare at fast tempos — OffsetOut is tighter.

// Jittery
Pbind(\instrument, \click, \dur, 1/32, \freq, Pseq([1000, 2000], inf), \amp, 0.3).play;
s.freeAll;
// Tight
Pbind(\instrument, \clickOffset, \dur, 1/32, \freq, Pseq([1000, 2000], inf), \amp, 0.3).play;
s.freeAll;


// 8. Groups
// Groups enforce execution order. Source group runs before FX group
// regardless of synth creation order.

(
~fxBus   = Bus.audio(s, 2);
~srcG    = Group.new;
~fxG     = Group.after(~srcG);
~masterG = Group.after(~fxG);

~verb = Synth(\reverb, [\in, ~fxBus, \out, 0, \mix, 0.4], ~fxG);
~mc   = Synth(\masterComp, [\bus, 0, \thresh, 0.5], ~masterG);
~b    = Synth(\bass, [\out, ~fxBus, \freq, 55],  ~srcG);
~l    = Synth(\lead, [\out, ~fxBus, \freq, 330], ~srcG);
)
s.queryAllNodes;

// Add sources any time — they land in ~srcG, always before FX.
~extra = Synth(\lead, [\out, ~fxBus, \freq, 660, \amp, 0.08], ~srcG);
~extra.free;

~srcG.set(\amp, 0.1);

(
[~srcG, ~fxG, ~masterG].do(_.free);
~fxBus.free;
)
