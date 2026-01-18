////////////////////////////////////////////////////////////////
//
//                    (Pbind) Duration
//
////////////////////////////////////////////////////////////////


////////////////////////// Setup ///////////////////////////

( // SynthDefs for examples

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\gatedSine, {|freq=440, amp=0.2, pan=0, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01,1,0.1), gate, doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\pluck, {|freq=440, amp=0.2, decay=2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = Pluck.ar(
		WhiteNoise.ar(amp),
		delaytime: freq.reciprocal,
		decaytime: decay
	);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


////////////////////////// \dur ///////////////////////////

// \dur specifies how long to wit before the next event

( // Quarter notes (1 beat each)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, 1          // wait 1 beat between notes
).play

)


( // Rhythms with Pseq

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, Pseq([1, 1/2, 1/4], inf)
).play

)


( // Triplets (divide by 3)

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67], inf),
	\dur, 1/3
).play

)


////////////////////////// Random Durations ///////////////////////////


( // Pwhite - uniform random distribution

Pbind(
	\instrument, \pluck,
	\midinote, 60,
	\dur, Pwhite(0.1, 0.5)
).play

)


( // Combine fixed and random

Pbind(
	\instrument, \pluck,
	\midinote, Pseq([60, 64, 67], inf),
	\dur, Pseq([0.25, Pwhite(0.1, 0.3, 2)], inf)  // one fixed, two random
).play

)


( // Pbrown - brownian motion (wandering)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, Pbrown(0.01, 0.3, 0.05, inf)  // wanders between 0.01 and 0.05
).play

)


////////////////////////// Mathematical Durations ///////////////////////////


( // Pseries - additive series

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, Pn(Pseries(0.1, 0.05, 16))  // start at 0.1, add 0.05 each time, 16 times
).play

)


( // Accelerating

Pbind(
	\instrument, \pluck,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, Pn(Pseries(0.5, -0.02, 20))  // gets faster
).play

)


( // Pgeom - geometric series (multiplication)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, Pn(Pgeom(0.5, 0.9, 20))  // starts at 0.5, multiply by 0.9
).play

)


////////////////////////// Duration vs Legato ///////////////////////////

// \dur controls when the next note starts
// \legato controls how long the note lasts


( // Default legato is 0.8 (80% of duration)

Pbind(
	\instrument, \gatedSine,
	\midinote, 60,
	\dur, 0.2,
	\legato, 0.8     // note lasts 80% of duration (default)
).play

)


( // Staccato - short notes

Pbind(
	\instrument, \gatedSine,
	\midinote, Pseq([60, 61, 63, 66], inf),
	\dur, 0.2,
	\legato, 0.02     // note lasts only 2% of duration
).play

)


( // Legato - overlapping notes

Pbind(
	\instrument, \gatedSine,
	\midinote, Pseq([60, 61, 63, 66], inf),
	\dur, 0.2,
	\legato, 1.5    // note lasts 150% of duration (overlaps)
).play

)


////////////////////////// Rest ///////////////////////////

// Use Rest() to create silence

( // Rest in pitch pattern

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, Rest(), 72], inf),
	\dur, 0.25
).play

)


( // Rest in duration pattern

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, Pseq([0.25, 0.25, 0.25, Rest(0.5)], inf)  // rest for 0.5 beats
).play

)


////////////////////////// Changing Tempo ///////////////////////////

// Control global tempo with TempoClock

( // Set tempo to 90 BPM

t = TempoClock(90/60);  // 90 BPM

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, 0.25
).play(t);

)

// Change tempo while playing
t.tempo = 180/60;  // 180 BPM
t.tempo = 60/60;   // 60 BPM
