////////////////////////////////////////////////////////////////
//
//                 	     Tasks & Clocks
//
////////////////////////////////////////////////////////////////


// Streams and Routines.

( // Synth used in some of the examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	OffsetOut.ar(0, sig * env ! 2);
}).add

)


////////////////////////// Clocks ///////////////////////////

// The message yield or wait (interchangeable) to wait some number of seconds
// (using SystemClock) or number of beats (using TempoClock)

(
	r = Routine({
		var counter = 0;
		{
		  counter = counter + 1;
	      0.2.yield;
		  counter.postln;
		}.loop;
	})
)



r.play // uses TempoClock by default
r.stop
r.reset.play(SystemClock)  // resets routine and plays using SystemClock


// Making choiches

(

~dur= 0.2;

t = Task({
	100.do{|i|
		if(i%8==0, {	//every 8th time
			"sonology".postln;
			1.wait;
		}, {
			i.postln;
			~dur.wait;
		});
	};
});

)

t.play(SystemClock)
t.stop





// Random choice

(
t = Task({
	var i= 0;
	while({0.9.coin}, {
		i.postln;
		i= i+1;
		0.1.wait;
	});
	"completed".postln;
	0.6.wait;
	"final message".postln;
});
)

t.play(SystemClock)
t.reset
t.play(TempoClock(2))




// More and more likely to stop over time

(
t = Task({
	var i= 0;
	while({(1-(i/40)).coin}, {
		i.postln;
		i= i+1;
		0.1.wait;
	});
});
)

t.play(SystemClock)
t.reset





// Nested loops
(
t = Task({
	10.do{|i|
		"bang".postln;
		10.do{|j|
			(i*10+j).postln;
			0.1.wait;
		};
	};
});
)

t.play(SystemClock)
t.stop





( // Create many Routines with a loop

10.do ({Routine({
	{  Synth(\sine,[\note, rrand(40,80), \amp,rrand (0.05,0.1)]);
	   rrand(0.001,0.1).wait;
	}.loop
   }).play
  })
)



// making an array of routines, starting and stopping them with do

(
a = { Routine({
	 { Synth(\sine,[\note, rrand(10,100), \amp,rrand (0.05,0.1)]);
	   rrand(0.001,0.1).wait }.loop
      })
    } ! 5;
)

// play the array of routines
   a.do({|i| i.play})

// stop the array of routines:
   a.do({|i| i.stop})

// reset and play the array of routines
   a.do({|i| i.reset.play})





( // Schedule a routine to start using clocks

var ra, rb, clock;

ra = Routine({{ "A".postln; 1.wait }.loop; });
rb = Routine({{ "B".postln; 2.wait }.loop; });
clock = TempoClock(90/60);
clock.sched(1, ra);
clock.sched(4, rb);

)



( // Change the clock

var clock, base;

base = 60;
clock = TempoClock(1);

12.do {|i|
	i = i + 1;

	Routine ({
		{
			i.wait;
			Synth(\sine, [\note, base + i, \amp, 0.1])
		}.loop
	}).play(clock);
};

Routine({
	{
		clock.tempo = rrand(1,10);
		4.wait
	}.loop
}).play;

)




( // Several clocks and a nested task

var clocka, clockb, taska, taskb;

~routine = Routine({
	clocka = TempoClock.new(2);
	clockb = TempoClock.new(4);

	taska = Task({
		loop({
			Synth(\sine, [note: 60]);
			1.5.wait;
			Synth(\sine, [note: 80]);
			[0.75, 0.25].choose.wait;
		});
	}, clocka);

	taskb = Task({
		loop({
			Synth(\sine, [note: 50]);
			0.5.wait;
		});
	}, clockb);

	'1'.postln;
	taska.start;
	1.yield;
	taskb.start;
	1.yield;
	clocka.tempo = 4;
	1.yield;
	clockb.tempo = 8;
	1.yield;
	taska.stop;
	1.yield;
	taskb.stop;
	'2'.postln;
});

~routine.play

)




( // Routines in an array

~array = 10.collect {|i|
	i = i + 1;
	Routine({{ Synth(\sine, [note: 60 + (4 * i)]); (i/10).wait }.loop})
}

)

~array.do({|i| i.play})
~array.do({|i| i.stop})
~array.do({|i| i.reset.play(TempoClock(0.5))})





( // Use the counter for control

var times=10, from=40, to=80, clock = TempoClock(10), player;

player = {|clock, times, from, to| Routine({
			times.do {|i|
				Synth(\sine, [\note, i.linlin(0,times,from,to)]);
				1.wait;
			}
}).play(clock)};

Routine({
	{
		player.value(clock, times, from, to);
		times.wait;
		player.value(clock, times, to, from);
		times.wait;
	}.loop
}).play(clock)

)


( // Use envelopes for creating shapes

Routine({
	var pitch, amp;

	pitch = Env([20, 80, 10, 50, 120], 25 ! 4);
	amp = Env([0, 1, 0.1, 0.8, 0.5], 25 ! 4);

	100.do{|i|
		Synth(\sine, [\note, pitch[i], \amp, amp[i]]);
		1.wait;
	};

}).play(TempoClock(10))

)


e = Env([20, 80, 10], [10, 5])
e[10]
e.plot

f = Env([20, 80, 10, 50, 120], 25 ! 4)
f.plot



( // Patterns are useful for generating values

var brown = Pbrown(60, 80, 1, inf).asStream;

Routine({
	{
		Synth(\sine, [\note, brown.next]);
		1.wait;
	}.loop
}).play(TempoClock(10))

)










