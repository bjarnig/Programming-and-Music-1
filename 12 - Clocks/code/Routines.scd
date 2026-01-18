////////////////////////////////////////////////////////////////
//
//                       Routines Recap
//
////////////////////////////////////////////////////////////////


////////////////////////// What are Routines? ///////////////////////////

// Routines are a way to sequence actions over time in SuperCollider.
// Unlike functions which execute immediately and all at once,
// Routines can pause their execution and resume later.


////////////////////////// Basic Routines ///////////////////////////

( // Simple Synth for examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	Out.ar(0, sig * env ! 2);
}).add

)


( // A basic Routine: uses .yield to pause

Routine {
	"First".postln;
	1.yield;      // wait 1 beat
	"Second".postln;
	0.5.yield;    // wait 0.5 beats
	"Third".postln;
}.play

)


( // A basic Routine: uses .yield to pause

Routine {
	Synth(\sine, [\note, 60]);
	0.5.yield;
	Synth(\sine, [\note, 65]);
	0.5.yield;
	Synth(\sine, [\note, 67]);
	1.0.yield;
	Synth(\sine, [\note, 72]);
}.play

)



////////////////////////// Loops in Routines ///////////////////////////


( // Infinite loop (plays forever until stoppedP

r = Routine({
	{
		Synth(\sine, [\note, rrand(60, 72)]);
		0.1.yield;
	}.loop
})

)

r.play;   // start the routine
r.stop;   // stop it
r.reset;  // reset to beginning



// Loop using .do
(

Routine({
	8.do {|i|
		i.postln;
		Synth(\sine, [\note, 60 + (i * 2)]);
		0.1.yield;
	}
}).play

)



////////////////////////// Arrays and Iteration ///////////////////////////


( // Iterate through an array of pitches

var pitches = [60, 64, 67, 72, 76, 79, 84];

Routine({
	pitches.do {|pitch|
		Synth(\sine, [\note, pitch]);
		0.1.yield;
	}
}).play

)



////////////////////////// Conditional Logic ///////////////////////////


( // Play different notes based on counter

Routine({
	16.do {|i|
		if(i % 4 == 0, {
			Synth(\sine, [\note, 40]);  // every 4th time, low note
		}, {
			Synth(\sine, [\note, 70]);  // otherwise, high note
		});
		0.1.yield;
	}
}).play

)



////////////////////////// External Control ///////////////////////////


( // Use global variables to control running Routines

~tempo = 0.2;
~pitch = 60;

r = Routine({
	{
		Synth(\sine, [\note, ~pitch]);
		~tempo.yield;
	}.loop
})

)

r.play;

// While it's playing, change these values:
~tempo = 0.5;   // slower
~pitch = 72;    // higher
~tempo = 0.1;   // faster

r.stop;



////////////////////////// Multiple Routines ///////////////////////////


( // Store multiple routines in an array

~routines = 5.collect {|i|
	Routine({
		{
			Synth(\sine, [\note, 60 + (i * 4), \amp, 0.1]);
			(i + 1 * 0.2).yield;
		}.loop
	})
};

)

// Play all routines
~routines.do {|r| r.play};

// Stop all routines
~routines.do {|r| r.stop};
