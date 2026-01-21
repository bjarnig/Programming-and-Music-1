////////////////////////////////////////////////////////////////
//
//               Synths and Patterns
//
////////////////////////////////////////////////////////////////

/*
   Combining synthesis concepts (classes 09-11) with
   pattern-based composition (classes 13-14).
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


////////////////////////// Basic Pbind ////////////////////////////


( // Simple Pbind with Pseq

Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, 0.25,
	\amp, 0.3
).play;

)


( // Filtered saw with random notes

Pbind(
	\instrument, \filtSaw,
	\midinote, Pwhite(48, 72),
	\cutoff, 1500,
	\dur, 0.2,
	\amp, 0.3
).play;

)


( // FM bell with controlled ratios

Pbind(
	\instrument, \fmBell,
	\midinote, Pseq([60, 62, 64, 65, 67], inf),
	\ratio, Pseq([1.0, 1.4, 2.0], inf),
	\index, 5,
	\rel, 1.5,
	\dur, 0.5
).play;

)


////////////////////////// Pseq and Prand ////////////////////////////


( // Pseq for melodic sequence

Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 62, 64, 65, 67, 69, 71, 72], 2),
	\dur, 0.15,
	\rel, 0.2
).play;

)


( // Prand for random note selection

Pbind(
	\instrument, \filtSaw,
	\midinote, Prand([48, 52, 55, 60, 64, 67], inf),
	\cutoff, Prand([500, 1000, 2000, 4000], inf),
	\dur, 0.2,
	\amp, 0.25
).play;

)


( // Pwrand for weighted random

Pbind(
	\instrument, \filtNoise,
	\freq, Pwrand([400, 800, 1600], [0.5, 0.3, 0.2], inf),
	\rel, 0.1,
	\dur, 0.125,
	\amp, 0.3
).play;

)


////////////////////////// Pwhite and Pbrown ////////////////////////////


( // Pwhite for uniform random

Pbind(
	\instrument, \percSine,
	\midinote, Pwhite(60, 84),
	\dur, Pwhite(0.05, 0.2),
	\rel, 0.15,
	\amp, Pwhite(0.1, 0.4)
).play;

)


( // Pbrown for brownian motion - smooth wandering

Pbind(
	\instrument, \filtSaw,
	\midinote, Pbrown(48, 72, 2),
	\cutoff, Pbrown(300, 3000, 200),
	\dur, 0.15,
	\amp, 0.3
).play;

)


( // Pbrown for FM parameters

Pbind(
	\instrument, \fmBell,
	\midinote, Pbrown(55, 75, 3),
	\index, Pbrown(1, 10, 1),
	\ratio, Pseq([1.0, 1.4, 2.0, 2.5], inf),
	\dur, 0.3,
	\rel, 1
).play;

)


////////////////////////// Pseries and Pgeom ////////////////////////////


( // Pseries for ascending pitches

Pbind(
	\instrument, \percSine,
	\midinote, Pseries(48, 1, 24),
	\dur, 0.1,
	\rel, 0.15
).play;

)


( // Pseries up and down

Pbind(
	\instrument, \filtSaw,
	\midinote, Pseq([Pseries(48, 2, 12), Pseries(72, -2, 12)], inf),
	\cutoff, Pseq([Pseries(400, 200, 12), Pseries(2800, -200, 12)], inf),
	\dur, 0.1,
	\amp, 0.3
).play;

)


( // Pgeom for exponential growth in duration

Pbind(
	\instrument, \fmBell,
	\midinote, Pwhite(55, 75),
	\dur, Pgeom(0.05, 1.1, 24),
	\rel, 1,
	\amp, 0.25
).play;

)


////////////////////////// Nested Patterns ////////////////////////////


( // Nested Pseq for phrase structure

Pbind(
	\instrument, \percSine,
	\midinote, Pseq([
		Pseq([60, 64, 67], 2),  // phrase A
		Pseq([72, 71, 69, 67], 1),  // phrase B
		Prand([60, 62, 64, 65, 67], 4)  // phrase C
	], inf),
	\dur, 0.2,
	\rel, 0.15
).play;

)


( // Nested patterns for different registers

Pbind(
	\instrument, \filtSaw,
	\midinote, Pseq([
		Pwhite(36, 48, 4),  // bass
		Pwhite(60, 72, 8),  // mid
		Pwhite(72, 84, 4)   // high
	], inf),
	\cutoff, Pseq([
		Pwhite(200, 600, 4),
		Pwhite(800, 2000, 8),
		Pwhite(2000, 5000, 4)
	], inf),
	\dur, 0.15,
	\amp, 0.25
).play;

)


////////////////////////// Pstutter ////////////////////////////


( // Pstutter for repetition

Pbind(
	\instrument, \percSine,
	\midinote, Pstutter(3, Pseq([60, 64, 67, 72], inf)),
	\dur, 0.15,
	\rel, 0.1
).play;

)


( // Pstutter with varying repetitions

Pbind(
	\instrument, \filtSaw,
	\midinote, Pstutter(Pwhite(1, 4), Prand([48, 52, 55, 60, 64], inf)),
	\cutoff, 1500,
	\dur, 0.1,
	\amp, 0.3
).play;

)


////////////////////////// Ppar - Parallel Patterns ////////////////////////////


( // Two patterns playing together

Ppar([
	// Bass line
	Pbind(
		\instrument, \filtSaw,
		\midinote, Pseq([36, 38, 40, 38], inf),
		\cutoff, 600,
		\dur, 1,
		\rel, 0.8,
		\amp, 0.3
	),
	// Melody
	Pbind(
		\instrument, \percSine,
		\midinote, Prand([60, 64, 67, 72, 76], inf),
		\dur, 0.25,
		\rel, 0.2,
		\amp, 0.2
	)
]).play;

)


( // Three layers with different synths

Ppar([
	// Low FM drones
	Pbind(
		\instrument, \fmBell,
		\midinote, Prand([36, 40, 43], inf),
		\ratio, 1.0,
		\index, 2,
		\dur, 2,
		\rel, 1.8,
		\amp, 0.2
	),
	// Mid filtered saw
	Pbind(
		\instrument, \filtSaw,
		\midinote, Pbrown(48, 60, 3),
		\cutoff, Pbrown(500, 2000, 200),
		\dur, 0.3,
		\rel, 0.25,
		\amp, 0.2
	),
	// High percussive noise
	Pbind(
		\instrument, \filtNoise,
		\freq, Pwhite(2000, 6000),
		\dur, Pwhite(0.1, 0.3),
		\rel, 0.05,
		\amp, 0.15
	)
]).play;

)


////////////////////////// Ptpar - Timed Parallel ////////////////////////////


( // Patterns starting at different times

Ptpar([
	0.0, Pbind(
		\instrument, \percSine,
		\midinote, 60,
		\dur, 0.5,
		\rel, 0.4,
		\amp, 0.3
	),
	1.0, Pbind(
		\instrument, \filtSaw,
		\midinote, 64,
		\cutoff, 1200,
		\dur, 0.5,
		\rel, 0.4,
		\amp, 0.25
	),
	2.0, Pbind(
		\instrument, \fmBell,
		\midinote, 67,
		\ratio, 1.4,
		\dur, 0.5,
		\rel, 0.8,
		\amp, 0.2
	)
]).play;

)


////////////////////////// Penv - Envelope Shapes ////////////////////////////


( // Penv for duration evolution

Pbind(
	\instrument, \percSine,
	\midinote, Pwhite(60, 84),
	\dur, Penv([0.05, 0.5, 0.05], [16, 16]),
	\rel, 0.15,
	\amp, 0.25
).play;

)


( // Penv for filter and pitch

Pbind(
	\instrument, \filtSaw,
	\midinote, Penv([48, 72, 36, 60], [12, 12, 12]).round,
	\cutoff, Penv([200, 4000, 500, 2000], [12, 12, 12]),
	\dur, 0.15,
	\rel, 0.2,
	\amp, 0.3
).play;

)


////////////////////////// Pattern Variables ////////////////////////////


( // Using variables for pattern organization

var bass = Pbind(
	\instrument, \filtSaw,
	\midinote, Pseq([36, 36, 40, 43], inf),
	\cutoff, 500,
	\dur, 0.5,
	\rel, 0.4,
	\amp, 0.3
);

var melody = Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 64, 67, 72, 67, 64], inf),
	\dur, Pseq([0.25, 0.25, 0.25, 0.5, 0.25, 0.25], inf),
	\rel, 0.2,
	\amp, 0.2
);

var rhythm = Pbind(
	\instrument, \filtNoise,
	\freq, 800,
	\dur, 0.25,
	\rel, 0.05,
	\amp, Pseq([0.3, 0.1, 0.2, 0.1], inf)
);

Ppar([bass, melody, rhythm]).play;

)


////////////////////////// Pfindur - Finite Duration ////////////////////////////


( // Play pattern for 10 seconds

Pfindur(10,
	Pbind(
		\instrument, \percSine,
		\midinote, Pwhite(60, 84),
		\dur, 0.1,
		\rel, 0.1
	)
).play;

)


( // Layers with different durations

Ppar([
	Pfindur(8, Pbind(
		\instrument, \filtSaw,
		\midinote, Pbrown(36, 48, 2),
		\cutoff, 600,
		\dur, 0.5,
		\amp, 0.3
	)),
	Pfindur(12, Pbind(
		\instrument, \percSine,
		\midinote, Pwhite(60, 84),
		\dur, 0.15,
		\amp, 0.2
	))
]).play;

)


////////////////////////// Combining Synthesis Techniques ////////////////////////////


( // Ring modulation with pattern control

Pbind(
	\instrument, \ringMod,
	\midinote, Pbrown(48, 72, 3),
	\modFreq, Pwhite(50, 200),
	\dur, 0.2,
	\rel, 0.3,
	\amp, 0.25
).play;

)


( // Waveshaping with dynamic fold amount

Pbind(
	\instrument, \foldSine,
	\midinote, Pseq([36, 40, 43, 48, 43, 40], inf),
	\foldAmt, Pbrown(1.2, 3, 0.2),
	\dur, 0.3,
	\rel, 0.25,
	\amp, 0.3
).play;

)


( // PWM with width modulation

Pbind(
	\instrument, \pwm,
	\midinote, Pseq([48, 55, 60, 55], inf),
	\width, Pbrown(0.1, 0.9, 0.1),
	\dur, 0.2,
	\rel, 0.15,
	\amp, 0.25
).play;

)


( // Additive synthesis with varying release

Pbind(
	\instrument, \additive,
	\midinote, Prand([48, 52, 55, 60, 64, 67], inf),
	\rel, Pbrown(0.3, 2, 0.2),
	\dur, Pwhite(0.2, 0.5),
	\amp, 0.2
).play;

)


////////////////////////// Complex Composition ////////////////////////////


( // Multi-section composition

var sectionA = Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 64, 67, 72, 67, 64], 4),
	\dur, 0.2,
	\rel, 0.15
);

var sectionB = Pbind(
	\instrument, \filtSaw,
	\midinote, Pbrown(48, 60, 2, 24),
	\cutoff, Pbrown(500, 3000, 300),
	\dur, 0.15,
	\rel, 0.2
);

var sectionC = Ppar([
	Pbind(
		\instrument, \fmBell,
		\midinote, Pseq([48, 55, 60, 55], 4),
		\ratio, 1.4,
		\dur, 0.5,
		\rel, 1
	),
	Pbind(
		\instrument, \filtNoise,
		\freq, 800,
		\dur, 0.25,
		\rel, 0.05,
		\amp, 0.2
	)
]);

Pseq([sectionA, sectionB, sectionC, sectionA]).play;

)
