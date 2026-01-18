////////////////////////////////////////////////////////////////
//
//                    Patterns - Solutions
//
////////////////////////////////////////////////////////////////


( // SynthDefs used in examples

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

)


/* Exercise 1: Basic Sequence
Create a Pbind that plays the MIDI notes 60, 64, 67, 72 in sequence with a duration
of 0.2 seconds between each note. Use \instrument \sine. */

( // Solution 1

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 61, 66, 73], inf),  // Minor 2nd, tritone, minor 7th
	\dur, 0.2
).play

)


/* Exercise 2: Random Pitches
Create a Pbind that plays random MIDI notes between 48 and 72 using Pwhite.
Set the duration to 0.15. */

( // Solution 2

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(52, 79),  // Wider, more dissonant range
	\dur, 0.15
).play

)


/* Exercise 3: Amplitude Pattern
Create a Pbind that plays MIDI note 60 repeatedly, but with an amplitude pattern
that alternates between 0.5 and 0.2. Use Pseq for the amplitude. */

( // Solution 3

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pseq([0.5, 0.2], inf),
	\dur, 0.2
).play

)


/* Exercise 4: Duration Pattern
Create a Pbind with a fixed pitch (60) but varying durations using Pseq.
Use the durations: [0.25, 0.25, 0.5, 0.25]. */

( // Solution 4

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\dur, Pseq([0.25, 0.25, 0.5, 0.25], inf)
).play

)


/* Exercise 5: Scale Degrees
Create a Pbind that plays scale degrees 0, 2, 4, 5, 7 using \degree.
Set the scale to Scale.minor and duration to 0.3. */

( // Solution 5

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 3, 6, 9], inf),  // More dissonant intervals
	\scale, Scale.chromatic,  // All 12 tones
	\dur, 0.3
).play

)


/* Exercise 6: Ascending Series
Create a Pbind that uses Pseries to create an ascending chromatic scale.
Start at MIDI note 48, increment by 1, and play 13 notes (one octave).
Use Pn() to make it repeat infinitely. */

( // Solution 6

Pbind(
	\instrument, \sine,
	\midinote, Pn(Pseries(53, 1, 17)),  // Start on F, 17 chromatic steps
	\dur, 0.2
).play

)


/* Exercise 7: Brownian Motion
Create a Pbind that uses Pbrown to wander randomly in pitch space.
Set the range from MIDI note 55 to 75, with a step size of 2. */

( // Solution 7

Pbind(
	\instrument, \sine,
	\midinote, Pbrown(54, 78, 1, inf),  // Chromatic steps (1 semitone)
	\dur, 0.15
).play

)


/* Exercise 8: Crescendo
Create a Pbind with a fixed pitch (60) that gets gradually louder.
Use Pseries for amplitude, starting at 0.1 and adding 0.03 each time, for 20 notes.
Use Pn() to make it repeat. */

( // Solution 8

Pbind(
	\instrument, \sine,
	\midinote, 60,
	\amp, Pn(Pseries(0.1, 0.03, 20)),
	\dur, 0.2
).play

)


/* Exercise 9: Random Rhythm
Create a Pbind with a fixed pitch (64) but random durations.
Use Pwhite to vary durations between 0.05 and 0.3. */

( // Solution 9

Pbind(
	\instrument, \sine,
	\midinote, 64,
	\dur, Pwhite(0.05, 0.3)
).play

)


/* Exercise 10: Combining Patterns
Create a Pbind that combines:
- Random pitches (Pwhite 60-84)
- Random durations (Pwhite 0.1-0.3)
- Random amplitudes (Pwhite 0.2-0.5) */

( // Solution 10

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(60, 84),
	\dur, Pwhite(0.1, 0.3),
	\amp, Pwhite(0.2, 0.5)
).play

)


/* Exercise 11: Rest Pattern
Create a Pbind that plays the sequence [60, 64, 67, Rest(), 72] with a duration of 0.2.
The Rest() should create silence. */

( // Solution 11

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 61, 67, Rest(), 74], inf),
	\dur, 0.2
).play

)


/* Exercise 12: Legato Control
Create a Pbind that plays MIDI notes 60, 64, 67, 72 in sequence with:
- \instrument \gatedSine (needs to be defined first)
- Duration of 0.3
- Legato of 0.1 (staccato) */

( // Solution 12

Pbind(
	\instrument, \gatedSine,
	\midinote, Pseq([60, 61, 66, 73], inf),  // Dissonant intervals
	\dur, 0.3,
	\legato, 0.1
).play

)


/* Exercise 13: Chords
Create a Pbind that plays chords (multiple notes at once).
Use arrays for midinote: [60, 64, 67], [62, 65, 69], [64, 67, 71].
Set duration to 0.5. */

( // Solution 13

Pbind(
	\instrument, \sine,
	\midinote, Pseq([[60, 61, 66], [63, 64, 70], [57, 58, 67]], inf),  // Cluster chords with m2 and tritones
	\dur, 0.5
).play

)


/* Exercise 14: Tempo Control
Create a TempoClock at 120 BPM and play a Pbind on that clock.
The pattern should play MIDI notes 60-67 in sequence with a duration of 0.25. */

( // Solution 14

t = TempoClock(120/60);  // 120 BPM

Pbind(
	\instrument, \sine,
	\midinote, Pseq((53..70), inf),  // Chromatic from F to Bb
	\dur, 0.25
).play(t);

)

// Change tempo while playing
t.tempo = 180/60;  // 180 BPM
t.tempo = 90/60;   // 90 BPM


/* Exercise 15: Multiple Parameters
Create a Pbind that uses:
- \degree with values [0, 2, 4, 5, 7]
- \scale Scale.dorian
- \octave alternating between 4 and 5 using Pseq
- \dur 0.2
- \amp 0.3 */

( // Solution 15

Pbind(
	\instrument, \sine,
	\degree, Pseq([0, 1, 3, 6, 10], inf),  // Dissonant intervals
	\scale, Scale.chromatic,  // All 12 tones
	\octave, Pseq([4, 5], inf),
	\dur, 0.2,
	\amp, 0.3
).play

)
