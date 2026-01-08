////////////////////////////////////////////////////////////////
//
//                      Envelopes
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


/////////////////////// Envelopes ////////////////////////

// Linen for a simple fade in and out
(
    {
	    PinkNoise.ar(0.5) * Linen.kr(Impulse.kr(10), 0.01, 1, 0.1)
    }.play
)


// An amplitude envelope
(
    {
        var env = Env([0, 1, 0.5, 1, 0], [2.01, 1.5, 0.2, 0.5], \sine);
	    SinOsc.ar([200, 201]) * EnvGen.kr(env, doneAction: 2)
    }.play
)


// An envelope that loops (.circle)
(
    {
	    Impulse.ar(80!2) * EnvGen.kr(Env([0, 0.85, 0], [1, 1]).circle);
    }.play
)




// Envelopes can be generated using methods from Env
Env.linen(1,2,1).plot

Env.linen(1,2,1).test

Env.triangle(1,1).test.plot

Env.sine(1,1).test.plot

Env.cutoff(1,1,'sine').test.plot

Env.perc(0.05,1,1).test.plot

Env.adsr(0.01, 0.5, 0.5, 0.1, 1.0, 0).plot

Env([0.01,1,0.3,0.01],[1,0.5,2], 'sine').plot

Env([0.01,1,0.3,0.01],[1,0.5,2], 'exponential').test.plot

Env([0.01,1,0.3,0.01],[1,0.5,2], 'welch').test.plot




// Custom array manipulations
~values = [0, 1, 0.2, 0.3, 0.4, 0.1]
~times = [0.4, 0.8, 0.6, 0.3, 0.5]
Env(~values, ~times).test.plot

~values = ~values.scramble
~times = ~times .scramble
Env(~values, ~times).test.plot




// Envelopes for each partial
(
	200.do {
	{
		SinOsc.ar(rrand(50.0, 12000.0), rrand(-1,1), 0.01)
	* EnvGen.kr(Env([0, 1, 0], [rrand(2, 20), rrand(2, 8)]))
     }.play }
)


{ SinOsc.ar(EnvGen.kr(Env([100, 200, 80], [2, 4]).circle)) * 0.1 }.play




/////////////////////// Gate and Release ////////////////////////


// ASR envelope waits at sustain until gate = 0
(
x = {|gate=1|
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.9), gate, doneAction: 2);
	SinOsc.ar(330) * env * 0.2;
}.play
)

x.set(\gate, 0);  // Release the envelope



// Using .release method (sets release time)
(
x = {|gate=1|
	var env = EnvGen.kr(Env.asr(0.1, 1, 1.0), gate, doneAction: 2);
	SinOsc.ar(440) * env * 0.2;
}.play
)

x.release(3.0);  // 3 second fade out




/////////////////////// Envelope for Frequency ////////////////////////


// EnvGen can control any parameter, not just amplitude
(
{
	var freqEnv = EnvGen.kr(Env([1000, 50, 2000], [2, 3], 'sine'), doneAction: 2);
	SinOsc.ar(freqEnv, mul: 0.2);
}.play
)



// Separate envelopes for amp and frequency
(
{
	var ampEnv = EnvGen.kr(Env.perc(0.01, 2), doneAction: 2);
	var freqEnv = EnvGen.kr(Env([2000, 200], [0.5], \exp));
	SinOsc.ar(freqEnv) * ampEnv * 0.3;
}.play
)




/////////////////////// Release Node ////////////////////////


// releaseNode: envelope pauses at this node until gate = 0
(
var e = Env([0, 1, 0.5, 0], [0.1, 0.5, 1.0], 0, releaseNode: 2);
e.plot;
)


(
x = {|gate=1|
	var e = Env([0, 1, 0.5, 0], [0.1, 0.5, 1.0], 0, releaseNode: 1);
	var env = EnvGen.kr(e, gate, doneAction: 2);
	SinOsc.ar(440) * env * 0.2;
}.play
)

x.set(\gate, 0);  // Triggers release segment




/////////////////////// doneActions Reference ////////////////////////


/*

doneAction values:
------------------
0   do nothing
1   pause synth (still resident)
2   free synth (most common)
3   free this and preceding node
4   free this and following node

*/
