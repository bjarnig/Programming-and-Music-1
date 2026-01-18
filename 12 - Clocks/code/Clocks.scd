////////////////////////////////////////////////////////////////
//
//                 	     Clocks & Tasks
//
////////////////////////////////////////////////////////////////


( // Synth used in examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	OffsetOut.ar(0, sig * env ! 2);
}).add

)


//////////////////////////  Clocks ///////////////////////////

// SuperCollider has three main clocks:

// - SystemClock: uses absolute time (seconds)
// - TempoClock: uses musical time (beats) with adjustable tempo
// - AppClock: for GUI updates (not covered here)

// Routines use .yield or .wait to pause:
// - With SystemClock: waits in seconds
// - With TempoClock: waits in beats

(

r = Routine({
	var counter = 0;
	{
		counter = counter + 1;
		counter.postln;
		0.2.yield;   // 0.2 seconds or 0.2 beats, depending on clock
	}.loop;
})

)

// Play with TempoClock (default) - 0.2 beats at 60 BPM = 0.2 seconds
r.play;
r.stop;

// Play with SystemClock - always 0.2 seconds regardless of tempo
r.reset.play(SystemClock);
r.stop;

// Play with TempoClock at 120 BPM - 0.2 beats = 0.1 seconds
r.reset.play(TempoClock(2));  // 2 beats per second = 120 BPM
r.stop;


////////////////////////// Tasks vs Routines ///////////////////////////

// Task is like a Routine, but with more control:
// - Can be paused and resumed (Routines must be stopped or played)
// - Can be started/stopped multiple times without reset

( // Routine

r = Routine({
	10.do {|i|
		i.postln;
		1.wait;
	}
});

)

r.play;
r.stop;
r.play;  // This won't work!


( // Task does the same but can be paused/resumed:

t = Task({
	10.do {|i|
		i.postln;
		1.wait;
	}
});

)

t.start;   // or .play
t.pause;   // pause it
t.resume;  // continues from where it paused
t.stop;    // stop and reset



////////////////////////// Tasks with Conditional Logic ///////////////////////////


( // Making choices in Tasks

~dur = 0.2;

t = Task({
	100.do {|i|
		if(i % 8 == 0, {     // every 8th time
			"sonology".postln;
			1.wait;
		}, {
			i.postln;
			~dur.wait;
		});
	};
});

)

t.play(SystemClock);
~dur = 0.05;  // change timing while running
t.stop;



////////////////////////// Probabilistic Timing ///////////////////////////

( // Random choice - 90% chance to continue each iteration

t = Task({
	var i = 0;
	while({0.9.coin}, { // 90% chance to continue, 10% chance to stop
		i.postln;
		i = i + 1;
		0.1.wait;
	});
	"completed".postln;
	0.6.wait;
	"final message".postln;
});

)

t.play(SystemClock);
t.reset;
t.play(TempoClock(2));  // try with different tempo



( // Decreasing probability - becomes more likely to stop over time

t = Task({
	var i = 0;
	while({(1 - (i/40)).coin}, {  // starts at 100%, decreases to 0%
		i.postln;
		i = i + 1;
		0.1.wait;
	});
	"Task completed!".postln;
});

)

t.play(SystemClock);
t.reset;




////////////////////////// Nested Loops ///////////////////////////


( // Tasks can have nested loops for complex patterns

t = Task({
	10.do {|i|
		"bang".postln;           // outer loop marker
		10.do {|j|
			(i * 10 + j).postln; // counts 0-99 in groups of 10
			0.1.wait;
		};
	};
});

)

t.play(TempoClock(90/60)); // 90 bpm
t.stop;





////////////////////////// Creating Multiple Routines ///////////////////////////

// Create many Routines at once, each runs independently

(

10.do {
	Routine({
		{
			Synth(\sine, [\note, rrand(20, 120), \amp, rrand(0.05, 0.1)]);
			rrand(0.001, 0.1).wait;
		}.loop
	}).play
}

)



////////////////////////// Scheduling Routines on Clocks ///////////////////////////

( // Schedule when routines start using clock.sched() (relative to now)

var ra, rb, clock;

ra = Routine({{ "A".postln; 1.wait }.loop; });
rb = Routine({{ "B".postln; 2.wait }.loop; });

clock = TempoClock(110/60);  // 110 bpm

clock.sched(1, ra);  // start routine A in 1 beat
clock.sched(4, rb);  // start routine B in 4 beats

)



//////////////////////////  Tempo Changes ///////////////////////////


( // Multiple routines and change the clock tempo in real-time

var clock, base;

base = 60;
clock = TempoClock(1);  // start at 60 BPM

// Routines with different rhythms (staggered timing)
12.do {|i|
	i = i + 1;

	Routine({
		{
			i.wait;  // each routine waits a different number of beats
			Synth(\sine, [\note, base + i, \amp, 0.1]);
		}.loop
	}).play(clock);
};

// Randomly change the tempo every 2 beats
Routine({
	{
		clock.tempo = rrand(1, 10);  // random tempo between 60-600 BPM
		("New tempo: " ++ (clock.tempo * 60) ++ " BPM").postln;
		2.wait;
	}.loop
}).play;
)




////////////////////////// Multiple Independent Clocks ///////////////////////////

( // Multiple clocks simultaneously, each with its own tempo, polyrhythmic music

var clocka, clockb, taska, taskb;

~routine = Routine({

	inf.do {

	clocka = TempoClock.new(2);  // 120 BPM
	clockb = TempoClock.new(4);  // 240 BPM

	// Task A on clock A
	taska = Task({
		loop({
			Synth(\sine, [note: rrand(50,60)]);
			1.5.wait;
			Synth(\sine, [note: rrand(80,90)]);
			[0.75, 0.25].choose.wait;
		});
	}, clocka);

	// Task B on clock B (twice as fast)
	taskb = Task({
		loop({
			Synth(\sine, [note: 50]);
			0.5.wait;
		});
	}, clockb);

	'Section 1: Task A starts'.postln;
	taska.start;
	1.yield;

	'Section 2: Task B starts'.postln;
	taskb.start;
	1.yield;

	'Section 3: Clock A speeds up'.postln;
	clocka.tempo = 4;  // now same speed as clock B
	1.yield;

	'Section 4: Clock B speeds up even more'.postln;
	clockb.tempo = 8;  // now twice as fast as clock A
	1.yield;

	'Section 5: Task A stops'.postln;
	taska.stop;
	1.yield;

	'Section 6: Task B stops'.postln;
	taskb.stop;
	'Done'.postln;

	}
});

~routine.play;

)


////////////////////////// Envelopes for Shaping ///////////////////////////


( // Envelopes to create control curves, access using array indexing: env[index]

Routine({
	var pitch, amp, dur;

	pitch = Env([20, 80, 10, 50, 120], 25 ! 4);  // pitch curve
	amp = Env([0, 0.8, 0.01, 0.4, 0.5], 25 ! 4); // amplitude curve
	dur = Env([0, 0.8, 0.1, 0.3, 0.2], 25 ! 4);   // dur curve

	100.do {|i|
		// Use the counter to index into the envelope
		Synth(\sine, [\note, pitch[i], \amp, amp[i]]);
		dur[i].wait;
	};

}).play(TempoClock(10));

)

e = Env([20, 80, 10], [10, 5]);
e[10];     // get value at index 10
e.plot;    // visualize the envelope

f = Env([20, 80, 10, 50, 120], 25 ! 4);
f.plot;


////////////////////////// Routine: embedInStream ///////////////////////////

// .embedInStream embeds one routine inside another,

(

var routine = { Routine { 4 .do {arg i; i.postln; 0.1.wait; } } };

Routine({
	"First".postln;
    routine.value.play;  // plays and does not wait
	"Second".postln;
	routine.value.embedInStream;  // plays and waits
	"Third".postln;
	routine.value.embedInStream;  // plays and waits
	"Done!".postln;
}).play();

)



////////////////////////// Patterns as Value Generators ///////////////////////////


( // Patterns can generate values for Routines using .asStream

var brown = Pbrown(60, 80, 1, inf).asStream;

Routine({
	{
		Synth(\sine, [\note, brown.next.postln]);  // get next value from stream
		1.wait;
	}.loop
}).play(TempoClock(10));

)
