////////////////////////////////////////////////////////////////
//
//              Four things, one per part of the year
//
////////////////////////////////////////////////////////////////

/* Nothing here is expected to make sense yet. Run each block, listen,
   and notice that every one of them is short. That is the argument of
   the course: a small description, a large result. */

Be careful with volume. Turn it down before the first block.

// Boot the sound server. Wait for it to say "server ready".

s.boot


///////////////////////// A first sound ////////////////////////

// play with defaults and through a function
{ SinOsc.ar(110) }.play


// with arguments
{ SinOsc.ar(200, 0, 0.5) }.play


// Stop everything. Learn this one now.

CmdPeriod.run


//////////////////////// Many at once //////////////////////////

// Mix with multichannel expansion
{ Mix.new(Blip.ar(Array.series(16, 100, 10), 50, 0.04)) ! 2 }.play


// Twenty oscillators, none of them typed out. Change the 20 and hear
// what changes.

// Random frequencies with .collect
(
{
	var freqs = Array.exprand(20, 100, 5000);
	var sig = freqs.collect({|f|
		SinOsc.ar(f, mul: f.expexp(100, 5000, 0.1, 0.005))
	});
	sig.sum * 0.3 ! 2;
}.play
)


CmdPeriod.run


//////////////////////// An instrument /////////////////////////

/* A named instrument, sent to the server once and played by name after
   that. Class 09 onward is built on this. */

( // Simple sine with percussive envelope
SynthDef(\percSine, {|freq=440, amp=0.2, rel=0.3|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, sig ! 2);
}).add;
)

// one note
Synth(\percSine, [\freq, 330])


///////////////////////// A sequence ///////////////////////////

/* The same instrument, played as a stream of events. No scheduling
   written by hand. Classes 14 and 15 are built on this. */

( // Simple Pbind with Pseq
Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, 0.25,
	\amp, 0.3
).play;
)


CmdPeriod.run
