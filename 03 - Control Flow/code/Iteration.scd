////////////////////////////////////////////////////////////////
//
//              Iteration, and the first hundred sounds
//
////////////////////////////////////////////////////////////////

/* ControlFlow.scd covers the same material without sound. Run this
   file from the top so that the instrument exists before the loops
   ask for it. */

s.boot


///////////////////////// The instrument ///////////////////////

( // one short sound, so a loop has something to make a hundred of
SynthDef(\ping, {|freq = 440, amp = 0.1, rel = 0.25|
	var env = EnvGen.ar(Env.perc(0.005, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, sig ! 2);
}).add;
)

// one of them, to check
Synth(\ping, [\freq, 330])


//////////////////////////// Counting //////////////////////////

// do something a number of times
7.do({ rrand(10, 100).postln })

// iterate a list, with the item and its index
do([1, 2, 3, 4], { |item, index| (item * 10 + index).postln })

// go from 10 to 50 and print each step
for(10, 50, { arg i; i.postln })

// go from 10 to 100 with a step size of 10
forBy(10, 100, 10, { arg i; i.postln })


/////////////////////////// Looping until //////////////////////

// fill p with random pitches until it has at least 32
(
p = [];
while({ p.size < 32 }, { p = p ++ Array.series(rrand(2, 4), 64.rand, 1) });
p;
)

// repeat a pattern and ask it for its next 32 values
(
x = Prand([10, 12]).loop.asStream;
x.nextN(32);
)


///////////////////////// A hundred sounds /////////////////////

// a hundred grains, none of them typed out
100.do({ Synth(\ping, [\freq, exprand(200, 4000), \amp, 0.03]) })

// the same loop, spread out in time
(
Routine({ 100.do({ |i| Synth(\ping, [\freq, 200 * (i + 1)]); 0.05.wait }) }).play
)

// change one number and the whole hundred changes
100.do({ Synth(\ping, [\freq, exprand(80, 400), \amp, 0.02, \rel, 1.5]) })

CmdPeriod.run


/////////////////////// Iterating a collection /////////////////

// one note per item, straight through the list
[60, 63, 67, 70].do({ |note| Synth(\ping, [\freq, note.midicps]) })

// the index shapes the sound as well as the pitch
(
[60, 63, 67, 70].do({ |note, i|
	Synth(\ping, [\freq, note.midicps, \amp, 0.1 / (i + 1)])
})
)

// collect returns a new list rather than discarding the results
(
~freqs = [60, 63, 67, 70].collect({ |note| note.midicps });
~freqs.round(0.1);
)

CmdPeriod.run
