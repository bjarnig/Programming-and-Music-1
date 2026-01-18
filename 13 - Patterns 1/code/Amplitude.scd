////////////////////////////////////////////////////////////////
//
//                    (Pbind) Amplitude
//
////////////////////////////////////////////////////////////////


/////////////////////////// Setup //////////////////////////////

( // SynthDefs for examples

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\pluck, {|freq=440, amp=0.2, decay=2, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.linen(0, decay, 0), doneAction:2);
	sig = Pluck.ar(
		WhiteNoise.ar(amp),
		delaytime: freq.reciprocal,
		decaytime: decay);
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


////////////////////////// Dynamic Patterns ////////////////////////


( // Alternate between loud and soft

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pseq([0.6, 0.2], inf),  // accent pattern
	\dur, 0.2
).play

)


( // Create rhythmic accents

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 61, 65, 69], inf),
	\amp, Pseq([0.6, 0.2, 0.3, 0.2], inf),
	\dur, 0.15
).play

)


( // Uniform random

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pwhite(0.2, 0.6),  // random between 0.2 and 0.6
	\dur, 0.2
).play

)


( // Brownian motion

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67], inf),
	\amp, Pbrown(0.1, 0.7, 0.05, inf),  // smooth changes
	\dur, 0.1
).play

)


//////////////////////////  Dynamics ///////////////////////////


( // Crescendo (getting louder)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pn(Pseries(0.1, 0.03, 32)),  // start quiet, get louder
	\dur, 0.2
).play

)


( // Decrescendo (getting quieter)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pn(Pseries(0.7, -0.03, 32)),  // start loud, get quieter
	\dur, 0.2
).play

)


( // Exponential crescendo (more dramatic)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pn(Pgeom(0.05, 1.1, 32)),  // exponential growth
	\dur, 0.2
).play

)


////////////////////////// dB vs Amplitude ///////////////////////////

// Convert dB to amplitude
-20.dbamp  // -20 dB -> amplitude


( // Use db in patterns

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\db, Pseq([-20, -10, -6, -3], inf),  // in db
	\dur, 0.1
).play

)


( // Random in dB space (more natural)

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(60, 72),
	\db, Pwhite(-30, -10),  // random dynamics in dB
	\dur, 0.15
).play

)


////////////////////////// Velocity (Alternative to amp) ///////////////////////////


( // \amp can also be specified as \vel (velocity)

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\vel, Pseq([127, 80, 60, 40], inf),  // MIDI velocity
	\dur, 0.5
).play

)


////////////////////////// Context-Dependent  ///////////////////////////


( // Match amplitude to pitch (higher notes often need less amp)

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(40, 84),
	\amp, Pfunc({|ev| (100 - ev[\midinote]) / 200 }),  // quieter for higher notes
	\dur, 0.2
).play

)


( // Using Pkey to reference other keys

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(40, 84),
	\amp, Pkey(\midinote).linlin(40, 84, 0.5, 0.2),  // scale based on pitch
	\dur, 0.2
).play

)
