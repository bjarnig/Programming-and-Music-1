////////////////////////////////////////////////////////////////
//
//                    (Pbind) Frequency
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

SynthDef(\saw, {|freq=440, amp=0.2, pan=0, rel=0.5|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, rel), doneAction:2);
	sig = Saw.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


////////////////////////// \freq (Hertz) ///////////////////////////

// Direct frequency in Hz (cycles per second)

( // Single frequency

Pbind(
	\instrument, \sine,
	\freq, 440,      // A4 = 440 Hz
	\dur, 0.2
).play

)


( // Sequence of frequencies

Pbind(
	\instrument, \sine,
	\freq, Pseq([220, 330, 440, 550], inf),  // A3, E4, A4, C#5
	\dur, 0.2
).play

)


( // Random frequencies

Pbind(
	\instrument, \sine,
	\freq, Pwhite(200, 800),  // random between 200-800 Hz
	\dur, 0.2
).play

)


( // Brownian motion in frequency space

Pbind(
	\instrument, \sine,
	\freq, Pbrown(200, 600, 50, inf),
	\dur, 0.15
).play

)


///////////////// \midinote (MIDI Note Numbers) ////////////////////

// MIDI notes: 60 = middle C, 69 = A440

( // Middle C

Pbind(
	\instrument, \sine,
	\midinote, 60,   // middle C
	\dur, 0.1
).play

)


( // Chromatic scale

Pbind(
	\instrument, \sine,
	\midinote, Pseq((60..72), inf),  // 60 to 72 (one octave)
	\dur, 0.15
).play

)


( // Melody in MIDI notes

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, 72, 67, 64, 60], inf),  // C major arpeggio
	\dur, 0.3
).play

)


( // Random MIDI notes in a range

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(60, 84),  // two octaves starting from middle C
	\dur, 0.08
).play

)


( // Series - ascending

Pbind(
	\instrument, \sine,
	\midinote, Pn(Pseries(48, 1, 25)),  // start at 48, add 1, 25 times
	\dur, 0.15
).play

)


( // Series - descending

Pbind(
	\instrument, \sine,
	\midinote, Pn(Pseries(72, -1, 25)),  // start at 72, subtract 1
	\dur, 0.15
).play

)


///////////////////// \note (Within an Octave) //////////////////////

// \note + \octave gives more control
// \note: 0-11 (chromatic), or use scale degrees
// \octave: which octave (4 = middle C octave)

( // C major scale steps

Pbind(
	\instrument, \sine,
	\note, Pseq([0, 2, 4, 5, 7, 9, 11], inf),  // C major scale steps
	\octave, 5,                                // 5th octave
	\dur, 0.15
).play

)


( // Change octaves

Pbind(
	\instrument, \sine,
	\note, Pseq([0, 4, 7], inf),     // C major triad
	\octave, Pseq([4, 5, 6], inf),   // cycle through octaves
	\dur, 0.3
).play

)


////////////////////// \degree (Scale Degrees) ////////////////////////

// Default scale is major

( // Major scale degrees

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),  // scale degrees
	\dur, 0.2
).play

)


( // Minor scale

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\scale, Scale.minor,
	\dur, 0.2
).play

)

// Explore different scales
Scale.directory  // list available scales


( // Dorian scale

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 2, 3, 4], inf),
	\scale, Scale.dorian,
	\dur, 0.2
).play

)


( // Phrygian scale

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6], inf),
	\scale, Scale.phrygian,
	\dur, 0.2
).play

)


( // Combine degree and octave

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 2, 4, 7], inf),
	\octave, Pseq([5, 5, 6, 5], inf),
	\scale, Scale.major,
	\dur, 0.2
).play

)


////////////////////////// Conversions ///////////////////////////

// MIDI note to frequency
60.midicps        // middle C to Hz

// Frequency to MIDI note
440.cpsmidi       // A440 to MIDI note


( // Convert MIDI to Hz in pattern

Pbind(
	\instrument, \sine,
	\freq, Pseq([60, 64, 67].midicps, inf),  // convert MIDI to Hz
	\dur, 0.2
).play

)



////////////////////////// Chords ///////////////////////////

// Arrays create chords (multiple notes at once)

( // MIDI note chords

Pbind(
	\instrument, \sine,
	\midinote, Pseq([[60, 64, 67], [62, 65, 69], [64, 67, 71]], inf),
	\dur, 0.25
).play

)


( // Scale degree chords

Pbind(
	\instrument, \sine,
	\degree, Pseq([[0, 2, 4], [1, 3, 5], [2, 4, 6]], inf),  // triads
	\scale, Scale.major,
	\dur, 0.5
).play

)


////////////////////////// Detune ///////////////////////////


( // Add slight detuning for richness

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\detune, Pwhite(-10, 10),  // detune in Hz
	\dur, 0.1
).play

)


////////////////////////// Transposition ///////////////////////////

// Use \ctranspose (chromatic) or \root

( // C major

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 2, 4, 5], inf),
	\root, 0,        // C major
	\dur, 0.1
).play

)


( // Change root (transpose)

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 2, 4, 5], inf),
	\root, Pseq([0, 2, -3], inf),  // C, D, A major
	\dur, 0.2
).play

)
