////////////////////////////////////////////////////////////////
//
//             Advanced Patterns - Solutions
//
////////////////////////////////////////////////////////////////


( // SynthDefs used in examples

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


/* Exercise 1: Exponential Distribution
Create a Pbind using Pexprand for durations (0.05 to 0.4) and Pgauss for pitch 
(mean 60, deviation 8). Use \instrument \sine. */

( // Solution 1

Pbind(
	\instrument, \sine,
	\midinote, Pgauss(60, 8, inf),
	\dur, Pexprand(0.05, 0.4),
	\amp, 0.2
).play

)


/* Exercise 2: Weighted Random
Create a Pbind using Pwrand with three pitches [60, 61, 66] and 
weights [0.6, 0.3, 0.1]. Duration 0.15. */

( // Solution 2

Pbind(
	\instrument, \sine,
	\midinote, Pwrand([60, 61, 66], [0.6, 0.3, 0.1], inf),
	\dur, 0.15,
	\amp, 0.2
).play

)


/* Exercise 3: Simple Tendency Mask
Create a Pbind where Pwhite selects pitches between two envelopes:
- Lower: Penv([50, 70, 50], [3, 3])
- Upper: Penv([60, 90, 60], [3, 3])
Duration 0.1. */

( // Solution 3

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(
		Penv([50, 70, 50], [3, 3]),    // Lower boundary
		Penv([60, 90, 60], [3, 3])     // Upper boundary
	),
	\dur, 0.1,
	\amp, 0.2
).play

)


/* Exercise 4: Envelope as Pitch
Create a Pbind where pitch is controlled by Penv([40, 80, 50], [2, 2]).
Use Pn() to make it loop infinitely. Duration 0.08. */

( // Solution 4

Pbind(
	\instrument, \sine,
	\midinote, Pn(Penv([40, 80, 50], [2, 2])),
	\dur, 0.08,
	\amp, 0.2
).play

)


/* Exercise 5: Simple State Machine
Create a Pbind using Pfsm with three states:
- State 0 (value 60) can go to state 0 or 1
- State 1 (value 73) can go to state 2
- State 2 (value 54) can only go to state 0
Duration 0.2. */

( // Solution 5

Pbind(
	\instrument, \sine,
	\midinote, Pfsm([
		[0],        // Initial state
		60,         // State 0 value
		[0, 1],     // Can go to 0 or 1
		73,         // State 1 value
		[2],        // Can only go to 2
		54,         // State 2 value
		[0]         // Can only go to 0
	], inf),
	\dur, 0.2,
	\amp, 0.2
).play

)


/* Exercise 6: Pattern Nesting
Create a Pbind where pitch alternates between two groups using Pseq:
- First group: Pseq([60, 61], 3) - play 3 times
- Second group: Pseq([66, 67], 2) - play 2 times
Duration 0.15. */

( // Solution 6

Pbind(
	\instrument, \sine,
	\midinote, Pseq([
		Pseq([60, 61], 3),   // Play 3 times
		Pseq([66, 67], 2)    // Play 2 times
	], inf),
	\dur, 0.15,
	\amp, 0.2
).play

)


/* Exercise 7: Time-Limited Pattern
Use Pfindur to limit a Pbind to exactly 3 seconds.
Use Pwhite(54, 78) for pitch and 0.08 for duration. */

( // Solution 7

Pfindur(3, Pbind(
	\instrument, \sine,
	\midinote, Pwhite(54, 78),
	\dur, 0.08,
	\amp, 0.2
)).play

)


/* Exercise 8: Pdup Repetition
Create a Pbind that uses Pdup to repeat each pitch 4 times.
Use Pseq([60, 66, 73], inf) for the base pitches. Duration 0.1. */

( // Solution 8

Pbind(
	\instrument, \sine,
	\midinote, Pdup(4, Pseq([60, 66, 73], inf)),
	\dur, 0.1,
	\amp, 0.2
).play

)


/* Exercise 9: Collection Operation
Create a Pbind using Pwhite(40, 90).select({|x| x > 60}) to filter pitches.
Only values above 60 should play. Duration 0.12. */

( // Solution 9

Pbind(
	\instrument, \sine,
	\midinote, Pwhite(40, 90).select({|x| x > 60}),
	\dur, 0.12,
	\amp, 0.2
).play

)


/* Exercise 10: Lazy Evaluation
Create a Pbind using Plazy to shuffle a list of pitches [60, 61, 66, 73] 
each time. Use Pn(Plazy({...})) to repeat infinitely. Duration 0.2. */

( // Solution 10

Pbind(
	\instrument, \sine,
	\midinote, Pn(Plazy({
		Pseq([60, 61, 66, 73].scramble, 1)
	})),
	\dur, 0.2,
	\amp, 0.2
).play

)


/* Exercise 11: Pdef for Live Coding
Create a Pdef named \mypattern with Pwhite(60, 72) for pitch and 0.1 for duration.
Then show how to change it to Pseq([60, 61, 66], inf) without stopping. */

( // Solution 11a - Initial pattern

Pdef(\mypattern, Pbind(
	\instrument, \sine,
	\midinote, Pwhite(60, 72),
	\dur, 0.1,
	\amp, 0.2
)).play

)

( // Solution 11b - Change it while running

Pdef(\mypattern, Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 61, 66], inf),
	\dur, 0.1,
	\amp, 0.2
))

)

// Stop when done
Pdef(\mypattern).stop


/* Exercise 12: Parallel Patterns
Use Ppar to play two Pbinds simultaneously:
- One with pitch 60 and duration 0.3
- Another with pitch 73 and duration 0.2 */

( // Solution 12

Ppar([
	Pbind(
		\instrument, \sine,
		\midinote, 60,
		\dur, 0.3,
		\amp, 0.15
	),
	Pbind(
		\instrument, \sine,
		\midinote, 73,
		\dur, 0.2,
		\amp, 0.15
	)
], inf).play

)


/* Exercise 13: Tendency Mask and Beta Distribution
Create a Pbind that uses a tendency mask for amplitudes and Pbeta for pitches.
- Amplitude: Pwhite between Penv([0.05, 0.3, 0.05], [2, 2]) and Penv([0.1, 0.4, 0.1], [2, 2])
- Pitch: Pbeta(40, 80, 1, 1) to favor extreme values
Duration 0.1. */

( // Solution 13

Pbind(
	\instrument, \sine,
	\midinote, Pbeta(40, 80, 1, 1),
	\amp, Pwhite(
		Penv([0.05, 0.3, 0.05], [2, 2]),    // Lower amplitude boundary
		Penv([0.1, 0.4, 0.1], [2, 2])       // Upper amplitude boundary
	),
	\dur, 0.1
).play

)
