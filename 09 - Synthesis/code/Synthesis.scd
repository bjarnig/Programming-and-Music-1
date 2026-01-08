////////////////////////////////////////////////////////////////
//
//                          Synthesis
//
////////////////////////////////////////////////////////////////

This document contains examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



////////////////////// Additive Synthesis //////////////////////


// play with defaults and through a function
{ SinOsc.ar(110) }.play



// with arguments
{ SinOsc.ar(200, 0, 0.5) }.play



// add two sine waves with plus operator
{ SinOsc.ar(100, 0, 0.2) + SinOsc.ar(1200, 0, 0.2) + SinOsc.ar(200,0,0.2) }.play



// Expand and scope
{ SinOsc.ar([400, 800, 25, 500],0,0.1) }.scope



// Repeat and with randomness
{ SinOsc.ar([100,200,300], 0, LFNoise2.kr(1, 0.8)) }.play



// Use iteration to add multiple sine waves
(

10.do {

	{ SinOsc.ar(exprand(100.0, 2000.0), 0, 0.1) ! 2 }.play
}

)

(

50.do {

	{
		var sine = SinOsc.ar(exprand(100.0, 800.0), 0, 0.5);
		var mod =  LFNoise2.kr(rrand(0.01, 10), 0.02, 0.05);
		(sine * mod) ! 2
}.play

}

)



// Use DynKlang (Dynamic sine oscillator bank) instead of individual sine waves
(
	{
	(DynKlang.ar(`[
			[200, 1000, 2000], // frequencies
			[0.5, 0.4, 0.1] // amplitudes
	]) * 0.1) ! 2
	}.freqscope;
)




//////////////////////////// Noises //////////////////////////////

Search help files for Noise or go to Browse UGens -> Filters


// Equal
{ WhiteNoise.ar(0.5) }.freqscope


// -3 dB per octave
{ PinkNoise.ar(0.5) }.freqscope



// -6 dB per octave
{ BrownNoise.ar(0.5) }.freqscope



// Randomly flipping bits (emphasizes lower frequencies)
{ GrayNoise.ar(0.5) }.freqscope



// Random impulses, first argument specifies density
{ Dust.ar(MouseX.kr(1, 1000).poll, 0.5) }.scope



// Based on a chaotic function.
{ Crackle.ar(1.95, 0.5) }.scope;



// Random walk with Gendyn distributions.
{ LFBrownNoise0.ar(MouseY.kr(100, 10000).poll, 1, MouseX.kr(1, 8), 0.2) }.scope



// Dynamic step noise
{ LFDNoise0.ar(MouseY.kr(100, 10000), 0.1) }.freqscope;



// Randomly generates the values -1 or +1 at a given rate
{ LFClipNoise.ar(MouseY.kr(10, 20000), 0.1) }.freqscope;





/////////////////////////// Noises and Filters ////////////////////////////


/* Resonant lopass filter. The resonance is specified with reciprocal of
q (rq) where rq is bandwidth/cutoffFreq, smaller the rq, the narrower the
bandwidth */

(
	{
	RLPF.ar(WhiteNoise.ar(0.2), SinOsc.kr(10, 0, 450, 550), 0.5)
	}.freqscope
)




// Resonant hipass filter.
(
	{
		RHPF.ar(Dust.ar(1200, 0.75), MouseY.kr(10000, 100), MouseX.kr(0.01, 0.9))
	}.freqscope
)




// Bandpass filter
(
	{
		BPF.ar(WhiteNoise.ar(0.5),MouseX.kr(10000, 100), MouseY.kr(0.01, 0.9))
	}.freqscope
)




// BEQSuite lopass, slightly different flavor
(
	{
		BLowPass4.ar(Dust.ar(MouseY.kr(200, 4000), 0.75), MouseY.kr(10000, 100), MouseX.kr(0.005, 0.9))
	}.play
)




// A digital implementation of the Moog VCF (filter)
(
	{ var maxFreq = 8000, modSpeed=0.2;
		MoogFF.ar(WhiteNoise.ar(0.8), maxFreq * SinOsc.kr(modSpeed, 0, 0.5, 0.5), 3)
	}.play
)




// DFM1 is a digitally modelled analog filter. Will oscillate at high frequencies
(
	{
		DFM1.ar(PinkNoise.ar(mul: 0.5), MouseX.kr(20, 8000), MouseY.kr(0.05, 1.3))
	}.play
)



//////////////////////////////////////// Subtractive Synthesis /////////////////////////////////


{ Saw.ar(40.midicps, 0.3) }.play


{ Saw.ar( LFPulse.kr(2).range(20, 60).midicps, 0.2) }.play


{ Resonz.ar(Saw.ar(100), LFNoise1.kr(10).range(100, 1500), 0.2) }.play


{ RLPF.ar(Saw.ar([20, 50], 0.5), LFNoise1.kr(0.1).range(100, 300), 0.1) }.play


// Saw is band limited
(
	{
		Saw.ar(200 *MouseX.kr(1,100), 0.4) ! 2
	}.freqscope;
)




// LFSaw is not band limited
(
	{
		LFSaw.ar(200 *MouseX.kr(1,100), 0, 0.1) ! 2
	}.freqscope;
)




// With filtering
(
	{
		Resonz.ar(
			Mix(Saw.ar([0.98, 0.99, 1.01]*200,0.3)),
			MouseX.kr(100,20000,\exponential), // Cutoff frequency
			MouseY.kr(0.1, 1.0, \linear), // Resonance
			0.7);
	}.play
)