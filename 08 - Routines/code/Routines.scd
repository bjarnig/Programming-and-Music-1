////////////////////////////////////////////////////////////////
//
//                 PMA07 - Routines & Streams
//
////////////////////////////////////////////////////////////////


Streams and Routines.

( // Synth used in some of the examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	Out.ar(0, sig * env ! 2);

}).add

)



////////////////////////// Functions ///////////////////////////


// simple function
a = { 'I am a function' }

a.value


// simple function with name
(

~myFunction;

~myFunction = { Pbind().play };

~myFunction.value;

)


// function with arguments, variables and calculation
f = { |a, b|  var c;  c = a * b; c * 2; 666}

f.value(1,2)


// empty funcion
{ }.value


// function that returns a calculated value
c = { 1 + 1 }.value



// function with arguments
f = {arg a,b; a.pow(b)}
f.value(4,2)


// function with arguments using vertical bars (pipe style)
~combineNames = {|first, second| "The composers name is" + first + second}

~combineNames.value("Giacinto", "Scelsi")




////////////////////// Streams and Routines ///////////////////////

1.next

[1,2,3].next


f = FuncStream({ 100.rand });
f.next
f.nextN(10)


g = FuncStream({ 1.postln; 2.postln; 3.postln });
g.next


r = Routine({ 1.yield; 2.yield; 3.yield });
r.next
r.reset


p = Routine({ { "forever".postln; 1.yield }.loop })
p.play


( // Yield returns multiple

a = Routine ({{
		50.yield;
		60.yield;
		70.yield;
		80.yield;
	}.loop });

a.next

)



( // Routines for precise sequencing

Routine {

	Synth(\sine, [\note, 60]);
	0.5.yield;
    Synth(\sine, [\note, 80]);
	0.15.yield;
    Synth(\sine, [\note, 85]);
	0.25.yield;
    Synth(\sine, [\note, 50]);
    Synth(\sine, [\note, 70]);
	0.5.yield;

}.play

)


( // Routines with a loop for playing

    Routine ({
		{
			Synth(\sine, [\note, 60]);
			0.2.yield;
		}.loop
}).play

)


( // Routine that iterates an array of pitches

var pitches = Array.series(12, 60, 0.5);

    Routine ({
	    pitches.do {|pitch|
		    Synth(\sine, [\note, pitch]);
			0.2.yield;
	    }
}).play

)


( // Playing function for abstraction

var player;

player = {|note, amp, duration|
	Routine ({
	{
		Synth(\sine, [\note, note, \amp, amp]);
		duration.wait;
	 }.loop
})};

50.do {|i|
	i = i + 1;
	player.value(40 + (10 * i), 0.1, 1.0).play(TempoClock(i));
}
)


( // Schedule a routine to start

var ra, rb, clock;

ra = Routine({{ "A".postln; 1.wait }.loop; });
rb = Routine({{ "B".postln; 2.wait }.loop; });

clock = TempoClock(90/60);
clock.sched(1, ra);
clock.sched(4, rb);

)


( // External control for wait and every 4th time a different note

~wait = 0.2;

r = Routine({
	64.do{|i|
		if(i % 4==0, {
			Synth(\sine, [\note, 60])
		}, {
			Synth(\sine, [\note, 80])
		});

		~wait.wait;
	};
})

)

r.play
~wait = 1.1
r.reset
