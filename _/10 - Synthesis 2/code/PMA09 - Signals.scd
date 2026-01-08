////////////////////////////////////////////////////////////////
//
//                      PMA11 - Signals
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////////// Plotting ////////////////////////////


// plot a 0.1 seconds of a sinewave
{ SinOsc.ar(100) }.plot(0.1);




// plot a numerical dataset
[5,10,100, 50, 60].plot;




// plot an envelope
Env([0,1,0],[1,1],[-10,2]).plot;




// scope a sine wave
{ SinOsc.ar(75, 0, 1).poll }.play;




// scope in stereo
{ [SinOsc.ar(240, 0, 0.2) + Saw.ar(30, 0.1), SinOsc.ar(142, 0, 0.2)+ Saw.ar(40, 0.1)] }.scope;




// call scope on the server
{ Impulse.ar(15) ! 8 }.play
s.scope




// freqscope
FreqScope.new(800, 800);

{ SinOsc.ar(SinOsc.kr(10).range(100, 2000)) }.play




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
        var env = Env([0, 1, 0.5, 1, 0], [2.01, 1.5, 0.2, 0.5]);
	    SinOsc.ar([200, 201]) * EnvGen.kr(env, doneAction: 2)
    }.play
)


// An envelope that loops
(
    {
	    Impulse.ar(80) * EnvGen.kr(Env([0, 0.5, 0], [1, 1]).circle);
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



/////////////////////// SynthDefs ////////////////////////


// Using { }.play is a shortcutt for actually creating a synthDef an playing it,


{ Resonz.ar(Saw.ar(100), LFNoise1.kr(2).range(200, 2000), 0.2) }.play



// The usual workflow is to add the synthDef and create multiple synths from it.

(

SynthDef("sawFilter", {|frequency = 50, modFrequency=10|
	var mod = LFNoise1.kr(modFrequency).range(200, 4000);
	var sound = Resonz.ar(Saw.ar(frequency), mod, 0.2);
	Out.ar(0, sound ! 2);
}).add;

)


a = Synth("sawFilter", [\frequency, 50]);

a.set(\frequency, 20)




// Within a SynthDef variables and arguments can be used

(

SynthDef("varSawFilter", {|from=100, to=1500|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(100);
	sig = Resonz.ar(sig, resfreq, 0.1);
	Out.ar(0, sig);
	}).add;
)

Synth("varSawFilter", [\to, 500])




// Storing synths in variables enables changing their argument or freeing them

a = Synth("varSawFilter")
a.set(\from, 1000)
a.set(\from, rrand(100,1000), \to, rrand(1001, 2000))
a.free




// A good practice is to use envelopes to free the synths using doneActions

(

SynthDef("envSawFilter", {|from=100, to=1500, freq=100|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(freq);
	sig = Resonz.ar(sig, resfreq, 0.1);
	sig = sig * EnvGen.ar(Env(), doneAction:2);
	Out.ar(0, sig);
	}).add;

)

Synth("envSawFilter", [\to, 500])

(

Routine({
	32.do {
		Synth("envSawFilter", [\from, rrand(100,1000), \to, rrand(1001, 2000), \freq, rrand(50, 500)]);
		rrand(0.2, 2).wait;
	}
}).play

)


// SynthDescLib can be used to organize SynthDefs

(

SynthDef(\sonology, {|freq=200, amp=0.1|
	var sig = SinOsc.ar * Line.ar(1,0,1,doneAction:2);
	Out.ar(0, sig * amp ! 2)
}).store

)

Synth(\sonology)

SynthDescLib.global.synthDescs[\sonology]

SynthDescLib.global.browse;


// SynthDefs have an additional argument for lag times

(
SynthDef(\dust, {|density=100, amp=0.75|
	var env, sig;
	env = EnvGen.ar(Env.new([0,1,0],[10,100]), doneAction:2);
	sig = Dust.ar(density.poll) * amp;
	Out.ar(0, sig * env ! 2)
}, [10, 5]).add
)

a = Synth(\dust, [\density, 20])
a.set(\density, 500)
a.set(\density, 1000)
a.set(\amp, 0.0)



/////////////////// Multichannel Expansion //////////////////////


// Mix can be used with multichannel expansion to combine sound
{ Mix.new(Blip.ar(Array.series(16, 100, 10), 50, 0.04)) ! 2 }.play



// Fill using a function
(
var times = 50, amp = 0.02;
{[ Mix.fill( times, { Impulse.ar(rrand(10, 1000), mul: amp) } ),
Mix.fill( times, { Dust.ar(rrand(10, 1000), mul: amp)})]}.play
)



// Splay works in a similar way but spreads over stereo
(
var times = 20;
{ Splay.ar( Formant.ar(
Array.rand(times, 100, 200),
Array.rand(times, 1000, 200),
Array.rand(times, 400, 800) ), 1, 0.2) }.play
)


// Scaling values is a common task when designing SynthDefs

( { SinOsc.ar(100, add:1000, mul:500) }.plot )


( { SinOsc.ar(100, add:1000, mul:500).range(4000,4500) }.plot )


( { SinOsc.ar(100).range(1, 10).linexp(1, 10, 10, 100) }.plot )


( { SinOsc.ar(100).range(1, 10).explin(1, 10, 10, 100) }.plot )