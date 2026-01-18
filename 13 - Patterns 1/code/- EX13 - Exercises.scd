////////////////////////////////////////////////////////////////
//
//                    Patterns - Exercises
//
////////////////////////////////////////////////////////////////

/*

Exercise 1: Basic Sequence
Create a Pbind that plays the MIDI notes 60, 64, 67, 72 in sequence with a duration
of 0.2 seconds between each note. Use \instrument \sine.

Exercise 2: Random Pitches
Create a Pbind that plays random MIDI notes between 48 and 72 using Pwhite.
Set the duration to 0.15.

Exercise 3: Amplitude Pattern
Create a Pbind that plays MIDI note 60 repeatedly, but with an amplitude pattern
that alternates between 0.5 and 0.2. Use Pseq for the amplitude.

Exercise 4: Duration Pattern
Create a Pbind with a fixed pitch (60) but varying durations using Pseq.
Use the durations: [0.25, 0.25, 0.5, 0.25].

Exercise 5: Scale Degrees
Create a Pbind that plays scale degrees 0, 2, 4, 5, 7 using \degree.
Set the scale to Scale.minor and duration to 0.3.

Exercise 6: Ascending Series
Create a Pbind that uses Pseries to create an ascending chromatic scale.
Start at MIDI note 48, increment by 1, and play 13 notes (one octave).
Use Pn() to make it repeat infinitely.

Exercise 7: Brownian Motion
Create a Pbind that uses Pbrown to wander randomly in pitch space.
Set the range from MIDI note 55 to 75, with a step size of 2.

Exercise 8: Crescendo
Create a Pbind with a fixed pitch (60) that gets gradually louder.
Use Pseries for amplitude, starting at 0.1 and adding 0.03 each time, for 20 notes.
Use Pn() to make it repeat.

Exercise 9: Random Rhythm
Create a Pbind with a fixed pitch (64) but random durations.
Use Pwhite to vary durations between 0.05 and 0.3.

Exercise 10: Combining Patterns
Create a Pbind that combines:
- Random pitches (Pwhite 60-84)
- Random durations (Pwhite 0.1-0.3)
- Random amplitudes (Pwhite 0.2-0.5)

Exercise 11: Rest Pattern
Create a Pbind that plays the sequence [60, 64, 67, Rest(), 72] with a duration of 0.2.
The Rest() should create silence.

Exercise 12: Legato Control
Create a Pbind that plays MIDI notes 60, 64, 67, 72 in sequence with:
- \instrument \gatedSine (needs to be defined first)
- Duration of 0.3
- Legato of 0.1 (staccato)

Exercise 13: Chords
Create a Pbind that plays chords (multiple notes at once).
Use arrays for midinote: [60, 64, 67], [62, 65, 69], [64, 67, 71].
Set duration to 0.5.

Exercise 14: Tempo Control
Create a TempoClock at 120 BPM and play a Pbind on that clock.
The pattern should play MIDI notes 60-67 in sequence with a duration of 0.25.

Exercise 15: Multiple Parameters
Create a Pbind that uses:
- \degree with values [0, 2, 4, 5, 7]
- \scale Scale.dorian
- \octave alternating between 4 and 5 using Pseq
- \dur 0.2
- \amp 0.3

*/
