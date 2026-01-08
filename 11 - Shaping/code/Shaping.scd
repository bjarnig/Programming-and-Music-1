////////////////////////////////////////////////////////////////
//
//                       Shaping
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Lag /////////////////////////


/*
   Lag imposes interpolation on a signal
*/


// Visualize Lag smoothing LFNoise0
(
{
	var sig = LFNoise0.ar(50);
	[sig, Lag.ar(sig, 0.01)]
}.plot(0.2);
)



// Lag as lowpass on noise
{ WhiteNoise.ar(0.05 ! 2) }.play;

{ Lag.ar(WhiteNoise.ar(0.05 ! 2), 0.003) }.play;



// Smoothing discrete pitch changes
(
{
	var freq = LFNoise0.kr(8).range(200, 800);
	freq = Lag.kr(freq, 0.05);  // Slide between pitches
	SinOsc.ar(freq, 0, 0.3) ! 2;
}.play
)



// Lag prevents filter artifacts from sudden frequency changes
(
{
	var freq = Lag.kr(LFNoise0.kr(8).range(200, 2000), 0.03);
	var sig = BrownNoise.ar(0.5);
	Resonz.ar(sig, freq, 0.05, 5) ! 2;
}.play
)




///////////////////////// Lag Variants /////////////////////////


/*
   Lag   - single pole lowpass
   Lag2  - equivalent to Lag.ar(Lag.ar(sig, time), time)
   Lag3  - three chained Lag operations
   LagUD - separate up and down lag times
   VarLag - variable lag time with curve control
*/


// Compare Lag variants
(
{
	var trig = Impulse.kr(2);
	var sig = ToggleFF.kr(trig);  // Square wave
	[
		sig,
		Lag.kr(sig, 0.1),
		Lag2.kr(sig, 0.1),
		Lag3.kr(sig, 0.1)
	]
}.plot(2);
)



// LagUD: different attack and release
(
{
	var sig = LFPulse.kr(2);
	var lagged = LagUD.kr(sig, 0.01, 0.3);  // Fast up, slow down
	SinOsc.ar(440) * lagged * 0.3 ! 2;
}.play
)



// VarLag with curve control
(
{
	var time = 0.1, curve = 0, warp = 5;
	PinkNoise.ar(VarLag.kr(WhiteNoise.kr, time, curve, warp) ! 2) * 0.3
}.play
)



// VarLag for smooth frequency transitions
(
{
	var freq = LFNoise0.kr(4).range(100, 800);
	freq = VarLag.kr(freq, 0.2, warp: \sine);
	Saw.ar(freq, 0.2) ! 2;
}.play
)




///////////////////////// Sample and Hold /////////////////////////


/*
   Latch: captures input value when triggered
   Creates stepped control signals from continuous sources
*/


// Basic sample and hold
(
{
	var trigger = Impulse.kr(4);
	var noise = WhiteNoise.kr;
	var held = Latch.kr(noise, trigger);
	SinOsc.ar(held.range(300, 600), 0, 0.3) ! 2;
}.play
)



// Latch with noise source at audio rate
(
{
	var trig = Impulse.ar(20);
	var noise = WhiteNoise.ar;
	var held = Latch.ar(noise, trig);
	held * 0.3 ! 2;
}.play
)



// TRand: triggered random value
(
{
	var trig = Dust.kr(4);
	var freq = TRand.kr(200, 800, trig);
	SinOsc.ar(freq, 0, 0.3) ! 2;
}.play
)



// TExpRand: exponential random on trigger
(
{
	var trig = Impulse.kr(8);
	var freq = TExpRand.kr(100, 2000, trig);
	var sig = SinOsc.ar(freq, 0, 0.2);
	sig = Lag.ar(sig, 0.01);  // Smooth amplitude
	sig ! 2;
}.play
)



// TChoose: select from array on trigger
(
{
	var trig = Impulse.kr(6);
	var freqs = Array.rand(10,100,1000);
	var freq = TChoose.kr(trig, freqs);
	freq = Lag.kr(freq, 0.02);
	SinOsc.ar(freq, 0, 0.3) ! 2;
}.play
)



// Combine with intervals
(
{
	var trig = Impulse.kr(8);
	var intervals = [-12, -5, 0, 5, 7, 12];
	var dev = TChoose.kr(trig, intervals);
	var freq = 200 * dev.midiratio;
	freq = Lag.kr(freq, 0.03);
	Saw.ar(freq, 0.2) ! 2;
}.play
)




///////////////////////// Clipping /////////////////////////


/*
   clip2: constrain signal to bipolar range
   clip: constrain to arbitrary range
   softclip: soft saturation
   tanh: hyperbolic tangent saturation
*/


// Hard clipping
(
{
	var sig = SinOsc.ar(100);
	var amount = MouseX.kr(1, 5);
	(sig * amount).clip2(1) * 0.3 ! 2;
}.play
)



// Compare clip2, softclip, tanh
(
{
	var sig = SinOsc.ar(100);
	var driven = sig * 3;
	[
		driven.clip2(1),    // Hard clip
		driven.softclip,    // Soft knee
		driven.tanh         // Smooth saturation
	] * 0.3
}.plot(0.02);
)



// tanh for warm overdrive
(
{
	var sig = Saw.ar([100, 101]);
	var drive = MouseX.kr(1, 10);
	(sig * drive).tanh * 0.3;
}.play
)



// softclip on complex signal
(
{
	var sig = Mix(Saw.ar([100, 150, 200], 0.5));
	var amount = LFNoise2.kr(0.5).range(1, 4);
	(sig * amount).softclip * 0.3 ! 2;
}.play
)




///////////////////////// Folding /////////////////////////


/*
   fold2: reflect signal at boundaries
   Creates harmonic distortion through wavefolding
*/


// Basic folding
(
{
	var sig = SinOsc.ar(100);
	var amount = MouseX.kr(1, 4);
	(sig * amount).fold2(1) * 0.3 ! 2;
}.play
)



// Visualize folding vs clipping
(
{
	var sig = SinOsc.ar(100) * 2;
	[sig.clip2(1), sig.fold2(1)]
}.plot(0.02);
)



// Modulated fold amount
(
{
	var sig = SinOsc.ar(80);
	var foldAmt = SinOsc.kr(0.3).range(0.3, 1);
	Fold.ar(sig, foldAmt.neg, foldAmt) * 0.4 ! 2;
}.play
)



// Fold with SinOscFB
(
{
	Fold.ar(
		SinOscFB.ar([40, 42], LFNoise1.ar(3).range(0.1, 1.75)),
		LFNoise2.ar(4.3).range(0.1, 0.5),
		SinOsc.ar([0.03, 0.1]).range(0.5, 0.9)
	) * 0.2
}.play
)



// Fold in feedback loop
(
{
	var input, snd;
	input = Saw.ar([60, 61], 0.1) + LocalIn.ar(2);
	snd = input.fold2(SinOsc.ar([30, 31]));
	snd = DelayC.ar(snd, 0.2, 0.05);
	LocalOut.ar(snd * 0.7);
	Limiter.ar(snd * 0.3)
}.play
)




///////////////////////// Wrapping /////////////////////////


/*
   wrap2: wrap signal at boundaries
   Signal wraps around from one boundary to the other
*/


// Basic wrapping
(
{
	var sig = SinOsc.ar(100);
	var amount = MouseX.kr(1, 4);
	(sig * amount).wrap2(1) * 0.3 ! 2;
}.play
)



// Compare wrap, fold, clip
(
{
	var sig = LFSaw.ar(100) * 2;
	[sig.clip2(1), sig.fold2(1), sig.wrap2(1)]
}.plot(0.02);
)



// Wrap with noise input
(
{
	var sig = LFNoise2.ar(200);
	var amount = LFNoise2.kr(0.3).range(1, 3);
	(sig * amount).wrap2(1) * 0.3 ! 2;
}.play
)




///////////////////////// Quantization /////////////////////////


/*
   round: round to nearest multiple
   trunc: truncate to nearest multiple
   Creates lo-fi / bit-crusher effects
*/


// Round to steps
(
{
	var sig = SinOsc.ar(200);
	var steps = MouseX.kr(0.5, 0.02);
	sig.round(steps) * 0.3 ! 2;
}.play
)



// Compare round and trunc
(
{
	var sig = SinOsc.ar(100);
	[sig.round(0.1), sig.trunc(0.1)]
}.plot(0.02);
)



// Sample rate reduction effect
(
{
	var sig = SinOsc.ar(440);
	var held = Latch.ar(sig, Impulse.ar(MouseX.kr(200, 10000)));
	held * 0.3 ! 2;
}.play
)



// Combined: bit depth and sample rate reduction
(
{
	var sig = Saw.ar([100, 101], 0.5);
	var sr = MouseX.kr(500, 20000);
	var bits = MouseY.kr(0.5, 0.01);
	sig = Latch.ar(sig, Impulse.ar(sr));  // Sample rate
	sig = sig.round(bits);                 // Bit depth
	sig * 0.3;
}.play
)




///////////////////////// Distortion /////////////////////////


/*
   distort: attempt to limit to -1 to 1
   cubed, squared: power functions
   bilinrand, exprand: noise shaping
*/


// distort method
(
{
	var sig = SinOsc.ar([100, 101]);
	var amount = MouseX.kr(1, 20);
	(sig * amount).distort * 0.3;
}.play
)



// Compare saturation types
(
{
	var sig = SinOsc.ar(100) * 3;
	[
		sig.tanh,
		sig.softclip,
		sig.distort
	] * 0.5
}.plot(0.02);
)



// Cubed for odd harmonics
(
{
	var sig = SinOsc.ar(100);
	sig.cubed * 0.5 ! 2;
}.play
)



// Squared for even harmonics (with DC offset)
(
{
	var sig = SinOsc.ar(100);
	var sq = sig.squared;
	HPF.ar(sq, 20) * 0.5 ! 2;  // Remove DC
}.play
)




///////////////////////// Limiting /////////////////////////


/*
   Limiter: look-ahead brickwall limiter
   Compander: compressor/expander/limiter
*/


// Limiter for safety
(
{
	var sig = SinOsc.ar(100) * 10;  // Overdriven
	Limiter.ar(sig * 0.3, 1) ! 2;
}.play
)



// Compander as limiter
(
{
	var sig = Saw.ar([100, 101]);
	var comp = Compander.ar(
		sig, sig,
		thresh: 0.5,
		slopeBelow: 1,
		slopeAbove: 0.1,  // Strong limiting above thresh
		clampTime: 0.01,
		relaxTime: 0.1
	);
	comp * 0.5;
}.play
)




///////////////////////// Combined Examples /////////////////////////


// Lag + Fold
(
{
	var freq = Lag.kr(LFNoise0.kr(4).range(50, 200), 0.1);
	var sig = SinOsc.ar(freq);
	var fold = LFNoise2.kr(0.5).range(0.3, 1);
	sig.fold2(fold) * 0.4 ! 2;
}.play
)



// Sample and hold with waveshaping
(
{
	var trig = Impulse.kr(8);
	var freq = Lag.kr(TExpRand.kr(100, 500, trig), 0.02);
	var sig = SinOsc.ar(freq);
	var drive = TRand.kr(1, 4, trig);
	(sig * drive).tanh * 0.3 ! 2;
}.play
)



// Quantized with filtering
(
{
	var sig = Saw.ar([80, 81]);
	var sr = LFNoise2.kr(0.2).range(2000, 10000);
	sig = Latch.ar(sig, Impulse.ar(sr));
	sig = sig.round(0.1);
	LPF.ar(sig, 4000) * 0.3;
}.play
)



// Complex shaping chain
(
{
	var freq = VarLag.kr(LFNoise0.kr(6).range(80, 200), 0.15, warp: \exp);
	var sig = Saw.ar(freq);
	sig = sig * LFNoise2.kr(2).range(1, 3);
	sig = sig.fold2(0.8);
	sig = Lag.ar(sig, 0.001);  // Smooth edges
	sig * 0.3 ! 2;
}.play
)


