////////////////////////////////////////////////////////////////
//
//               Routines & Clocks - Solutions
//
////////////////////////////////////////////////////////////////


( // Synth used in examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	Out.ar(0, sig * env ! 2);
}).add

)


/* Exercise 1: Basic Routine Sequence
Create a Routine that plays 5 notes in sequence with 0.3 second waits between them.
*/

(

Routine({
	Synth(\sine, [\note, 60]);
	0.3.wait;
	Synth(\sine, [\note, 61]);
	0.3.wait;
	Synth(\sine, [\note, 62]);
	0.3.wait;
	Synth(\sine, [\note, 64]);
	0.3.wait;
	Synth(\sine, [\note, 66]);
}).play;

)

( // Alternative using an array

var pitches = [60, 61, 62, 64, 66];

Routine({
	pitches.do {|note|
		Synth(\sine, [\note, note]);
		0.3.wait;
	}
}).play;

)


/* Exercise 2: Loop with Counter
Create a Routine that plays 8 notes using a loop. Each note should be 2 semitones
higher than the previous one. Use 0.2 second waits. */

(

Routine({
	8.do {|i|
		var note = 60 + (i * 2);  // 60, 62, 64, 66, 68, 70, 72, 74
		Synth(\sine, [\note, note]);
		0.2.wait;
	}
}).play;

)


/* Exercise 3: Conditional Rhythm
Create a Routine that loops 16 times. On every 4th iteration, play a low note (40)
and wait 0.4 seconds. On other iterations, play a high note (80) and wait 0.1 seconds. */

(

Routine({
	16.do {|i|
		if(i % 4 == 0, {
			Synth(\sine, [\note, 40]);
			0.4.wait;
		}, {
			Synth(\sine, [\note, 80]);
			0.1.wait;
		});
	}
}).play;

)


/* Exercise 4: External Control
Create a Routine that loops infinitely, using global variables ~pitch and ~tempo
to control the note and timing. Start it, then change the variables while it runs. */

(

~pitch = 60;
~tempo = 0.3;

r = Routine({
	{
		Synth(\sine, [\note, ~pitch]);
		~tempo.wait;
	}.loop
});

r.play;

)

// While it's running, try these:
~pitch = 72;
~tempo = 0.1;
~pitch = 50;
~tempo = 0.5;

r.stop;


/* Exercise 5: SystemClock vs TempoClock
Create the same Routine twice: once using SystemClock and once using TempoClock
at 120 BPM. The routine should wait 0.5 (seconds or beats) between notes.
Compare the speeds. */

// With SystemClock - always 0.5 seconds
(

Routine({
	8.do {|i|
		Synth(\sine, [\note, 60 + (i * 2)]);
		0.5.wait;  // 0.5 seconds
	}
}).play(SystemClock);

)

// With TempoClock at 120 BPM (2 beats per second) - 0.5 beats = 0.25 seconds
(

Routine({
	8.do {|i|
		Synth(\sine, [\note, 60 + (i * 2)]);
		0.5.wait;  // 0.5 beats
	}
}).play(TempoClock(2));  // 2 beats/second = 120 BPM

)

// Side-by-side comparison - left channel SystemClock, right channel TempoClock
(

var routineA = Routine({
	{
		Synth(\sine, [\note, 60]);
		0.5.wait;
	}.loop
});

var routineB = Routine({
	{
		Synth(\sine, [\note, 67]);
		0.5.wait;
	}.loop
});

routineA.play(SystemClock);
routineB.play(TempoClock(2));  // This one is twice as fast

)


/* Exercise 6: Task Control
Create a Task that counts from 1 to 20 with 0.2 second waits. Start it, pause it
after a few counts, then resume it. Observe that it continues from where it paused. */

(

t = Task({
	20.do {|i|
		(i + 1).postln;
		0.2.wait;
	};
	"Done!".postln;
});

)

t.start;
t.pause;   // pause it
t.resume;  // continues from where it paused
t.stop;    // stop and reset


/* Exercise 7: Multiple Routines
Create 3 different Routines that each play notes at different intervals:
- Routine A: plays note 60 every 0.5 seconds
- Routine B: plays note 67 every 0.75 seconds
- Routine C: plays note 72 every 1.0 seconds
Start them all at the same time and listen to the polyrhythm. */

(

var ra, rb, rc;

ra = Routine({
	{
		Synth(\sine, [\note, 60, \amp, 0.15]);
		0.5.wait;
	}.loop
});

rb = Routine({
	{
		Synth(\sine, [\note, 67, \amp, 0.15]);
		0.75.wait;
	}.loop
});

rc = Routine({
	{
		Synth(\sine, [\note, 72, \amp, 0.15]);
		1.0.wait;
	}.loop
});

ra.play(SystemClock);
rb.play(SystemClock);
rc.play(SystemClock);

)

// Alternative: store in array for easy control
(

~routines = [
	Routine({{ Synth(\sine, [\note, 60, \amp, 0.15]); 0.5.wait }.loop}),
	Routine({{ Synth(\sine, [\note, 67, \amp, 0.15]); 0.75.wait }.loop}),
	Routine({{ Synth(\sine, [\note, 72, \amp, 0.15]); 1.0.wait }.loop})
];

)

~routines.do {|r| r.play(SystemClock)};  // start all
~routines.do {|r| r.stop};               // stop all


/* Exercise 8: Probabilistic Stopping
Create a Routine that uses a while loop with .coin to continue. Each iteration should
have a 70% chance to continue (0.7.coin). Post the iteration number each time.
Run it several times to see different lengths. */

(

Routine({
	var i = 0;
	while({0.7.coin}, {  // 70% chance to continue, 30% chance to stop
		i = i + 1;
		i.postln;
		Synth(\sine, [\note, rrand(60, 80)]);
		0.1.wait;
	});
	("Stopped after " ++ i ++ " iterations").postln;
}).play;

)

( // Alternative with decreasing probability

Routine({
	var i = 0;
	while({(1 - (i/20)).coin}, {  // starts at 100%, decreases to 0% over 20 iterations
		i = i + 1;
		("Iteration " ++ i ++ ", probability: " ++ (1 - (i/20)).round(0.01)).postln;
		Synth(\sine, [\note, 60 + (i * 2)]);
		0.15.wait;
	});
	("Stopped after " ++ i ++ " iterations").postln;
}).play;

)


/* Exercise 9: Scheduled Start Times
Create two Routines and schedule them to start at different times using clock.sched().
The first should start after 2 beats, the second after 5 beats. Use a TempoClock. */

(

var ra, rb, clock;

clock = TempoClock(100/60);  // 100 BPM

ra = Routine({
	{
		"A".postln;
		Synth(\sine, [\note, 60]);
		1.wait;
	}.loop
});

rb = Routine({
	{
		"B".postln;
		Synth(\sine, [\note, 72]);
		1.wait;
	}.loop
});

"Starting scheduler...".postln;
clock.sched(2, ra);  // start routine A after 2 beats
clock.sched(5, rb);  // start routine B after 5 beats

)


/* Exercise 10: Tempo Changes
Create a TempoClock and a Routine that plays notes on that clock. While it's running,
change the tempo of the clock to make the routine speed up or slow down. */

(

~clock = TempoClock(1);  // start at 60 BPM

Routine({
	{
		Synth(\sine, [\note, rrand(60, 72)]);
		1.wait;  // 1 beat
	}.loop
}).play(~clock);

)

// While it's running, change the tempo:
~clock.tempo = 2;    // 120 BPM (twice as fast)
~clock.tempo = 4;    // 240 BPM (four times as fast)
~clock.tempo = 0.5;  // 30 BPM (half speed)
~clock.tempo = 3;    // 180 BPM

// Check current tempo in BPM
(~clock.tempo * 60).postln;

// Alternative: multiple routines on same clock, all affected by tempo change
(

~clock = TempoClock(1);

// Three routines with different rhythms
Routine({{ Synth(\sine, [\note, 60, \amp, 0.15]); 1.wait }.loop}).play(~clock);
Routine({{ Synth(\sine, [\note, 67, \amp, 0.15]); 1.5.wait }.loop}).play(~clock);
Routine({{ Synth(\sine, [\note, 72, \amp, 0.15]); 2.wait }.loop}).play(~clock);

)

// Change tempo - all routines speed up/slow down together
~clock.tempo = 3;
~clock.tempo = 0.5;
