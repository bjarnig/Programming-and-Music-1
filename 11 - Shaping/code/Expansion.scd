////////////////////////////////////////////////////////////////
//
//                       Multichannel Expansion
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Array Expansion /////////////////////////


// Arrays in UGen arguments create multiple channels
{ SinOsc.ar([400, 404]) * 0.2 }.play  // Stereo: left=400Hz, right=404Hz



// Detuned oscillators create thickness
{ Saw.ar([99, 100, 101]) * 0.15 }.play  // 3 channels



// ! operator duplicates to array
{ SinOsc.ar(440) * 0.2 ! 2 }.play  // Mono to stereo




///////////////////////// Mix /////////////////////////


// Mix.new sums an array to mono
{ Mix.new(SinOsc.ar([400, 500, 600])) * 0.15 }.play



// Mix with multichannel expansion
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



///////////////////////// Collect /////////////////////////


// .collect iterates and creates an array
(
{
	var freqs = [200, 400, 600, 800];
	var sig = freqs.collect({|f, i|
		SinOsc.ar(f, mul: 0.2 / (i+1))
	});
	sig.sum ! 2;
}.play
)



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




///////////////////////// Iteration with do /////////////////////////


// .do creates multiple synths (not channels)
(
SynthDef(\sine, {|freq=440, amp=0.1|
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: 2);
	Out.ar(0, SinOsc.ar(freq) * env * amp ! 2);
}).add;
)


5.do({ Synth(\sine, [\freq, exprand(200, 2000)]) });



// Nested iteration for chords
(
[60, 64, 67, 72].do({|note|
	3.do({
		Synth(\sine, [\freq, note.midicps * rrand(0.99, 1.01)]);
	});
});
)




///////////////////////// Splay /////////////////////////


// Splay spreads array across stereo field
(
{
	var sig = SinOsc.ar([200, 300, 400, 500, 600]);
	Splay.ar(sig, spread: 1, level: 0.2);
}.play
)



// Splay with detuning
(
{
	var freq = 200;
	var detunes = [0.99, 0.995, 1, 1.005, 1.01];
	var sig = Saw.ar(freq * detunes);
	Splay.ar(sig, spread: 0.8, level: 0.2);
}.play
)



// Splay in a SynthDef - cluster synth
(
SynthDef(\cluster, {|freq=200, amp=0.2, gate=1|
	var detune = [0.99, 1.01, 1, 0.995, 1.005];
	var sig = SinOsc.ar(freq * detune);
	var env = EnvGen.kr(Env.asr(0.5, 1, 1), gate, doneAction: 2);
	sig = Splay.ar(sig) * env * amp;
	Out.ar(0, sig);
}).add;
)

x = Synth(\cluster, [\freq, 220]);

x.set(\gate, 0);




///////////////////////// Practical Examples /////////////////////////


// Additive harmonic series
(
{
	var fund = 100, n = 10;
	var sig = Mix.fill(n, {|i|
		SinOsc.ar(fund * (i+1), 0, 0.1 / (i+1))
	});
	sig ! 2;
}.play
)



// Detuned supersaw
(
{
	var freq = 50;
	var detunes = Array.series(7, -0.03, 0.01);
	var sig = Saw.ar(freq * (1 + detunes));
	Splay.ar(sig, 0.8) * 0.15;
}.play
)



// Pad with individual envelopes per partial
(
{
	var fund = 100, n = 8;
	var sig = Mix.fill(n, {|i|
		var env = EnvGen.kr(Env.perc(rrand(0.5, 2), rrand(2, 5)));
		SinOsc.ar(fund * (i+1) * rrand(0.99, 1.01)) * env * (0.2 / (i+1))
	});
	sig ! 2;
}.play
)



// 8 voices spread across stereo
(
{
	var sig = 8.collect({
		var freq = exprand(100, 800);
		var mod = LFNoise2.kr(0.5).range(0.8, 1.2);
		SinOsc.ar(freq * mod, 0, 0.1);
	});
	Splay.ar(sig);
}.play
)




///////////////////////// Reference /////////////////////////


/*

Array Creation
--------------
[a, b, c]              Literal array
Array.series(n, a, b)  Arithmetic series
Array.rand(n, lo, hi)  Random values
Array.fill(n, func)    Fill with function

Multichannel Operators
----------------------
! n                    Duplicate n times
.sum                   Sum array to mono
Mix.new(array)         Sum array to mono
Mix.fill(n, func)      Create and sum n signals
Splay.ar(array)        Spread across stereo

Iteration
---------
array.do {|item| ...}      Execute for each (no return)
array.collect {|item| ...} Create new array from results
n.do { ... }               Execute n times

*/