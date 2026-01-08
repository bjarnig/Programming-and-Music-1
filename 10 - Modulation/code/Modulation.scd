////////////////////////////////////////////////////////////////
//
//                       Modulation
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Tremolo (Slow AM) /////////////////////////


// Tremolo is slow amplitude modulation, typically 1-20 Hz
(
{
	var carrier = SinOsc.ar(440);
	var modulator = SinOsc.kr(6);  // 6 Hz tremolo rate
	carrier * modulator * 0.3;
}.play
)



// Vary the tremolo rate with mouse
(
{
	var carrier = SinOsc.ar(440);
	var rate = MouseX.kr(1, 20);
	var modulator = SinOsc.kr(rate);
	carrier * modulator * 0.3;
}.play
)




/////////////////// Amplitude Modulation (AM) ////////////////////


/*
   AM uses a UNIPOLAR modulator (0 to 1)
   The modulator shifts from -1..1 to 0..1
   This creates sidebands at carrier ± modulator frequencies
*/


// AM with unipolar modulator
(
{
	var carrier = SinOsc.ar(440);
	var modulator = SinOsc.ar(100, mul: 0.5, add: 0.5);  // 0 to 1
	carrier * modulator * 0.3;
}.freqscope
)



// Explore AM: move mouse to change modulator frequency
(
{
	var carrFreq = 440;
	var modFreq = MouseX.kr(1, 500);
	var modulator = SinOsc.ar(modFreq, mul: 0.5, add: 0.5);
	var carrier = SinOsc.ar(carrFreq);
	carrier * modulator * 0.3;
}.freqscope
)




//////////////////////// Ring Modulation ////////////////////////


/*
   Ring Modulation uses a BIPOLAR modulator (-1 to 1)
   Creates sum and difference frequencies: carrier+mod, carrier-mod
   The original carrier frequency is removed!
*/


// Basic ring modulation
(
{
	var carrier = SinOsc.ar(440);
	var modulator = SinOsc.ar(100);  // Bipolar: -1 to 1
	carrier * modulator * 0.3;
}.freqscope
)



// Ring mod: see how frequencies shift
(
{
	var carrFreq = 440;
	var modFreq = MouseX.kr(10, 500).poll;
	var carrier = SinOsc.ar(carrFreq);
	var modulator = SinOsc.ar(modFreq);
	carrier * modulator * 0.3;
}.freqscope
)



// Ring mod with complex waveforms
(
{
	var carrier = Saw.ar(200);
	var modulator = Saw.ar(150);
	carrier * modulator * 0.2;
}.freqscope
)




///////////////////// Frequency Modulation /////////////////////


/*
   FM: modulate the FREQUENCY of the carrier
   Much more efficient than additive for complex spectra

   Key parameters:
   - Carrier frequency
   - Modulator frequency
   - Modulation index (deviation / modulator freq)
*/


// Simple FM: modulator affects carrier frequency
(
{
	var carrFreq = 440;
	var modFreq = 100;
	var deviation = 200;  // How much the frequency moves
	var modulator = SinOsc.ar(modFreq, mul: deviation);
	SinOsc.ar(carrFreq + modulator, 0, 0.3);
}.freqscope
)



// Explore FM with mouse
(
{
	var carrFreq = 440;
	var modFreq = MouseX.kr(1, 400);
	var deviation = MouseY.kr(0, 1000);
	var modulator = SinOsc.ar(modFreq, mul: deviation);
	SinOsc.ar(carrFreq + modulator, 0, 0.3);
}.freqscope
)




///////////////////// FM Modulation Index /////////////////////


/*
   Modulation Index (I) = Deviation / Modulator Frequency

   Higher index = brighter sound (more sidebands)
   Lower index = duller sound (fewer sidebands)
*/


// FM with modulation index control
(
{
	var carrFreq = 440;
	var modFreq = 220;
	var modIndex = MouseX.kr(0, 10).poll;  // Try 0-10
	var deviation = modFreq * modIndex;
	var modulator = SinOsc.ar(modFreq, mul: deviation);
	SinOsc.ar(carrFreq + modulator, 0, 0.3);
}.freqscope
)




///////////////////// FM Ratios /////////////////////


/*
   When carrier:modulator is a simple ratio, sound is harmonic
   Integer ratios: 1:1, 2:1, 3:2, etc. = harmonic
   Non-integer ratios = inharmonic (bell-like)
*/


// Harmonic FM (2:1 ratio)
(
{
	var carrFreq = 440;
	var modFreq = 220;  // 2:1 ratio
	var modIndex = 5;
	var deviation = modFreq * modIndex;
	SinOsc.ar(carrFreq + SinOsc.ar(modFreq, mul: deviation), 0, 0.3);
}.freqscope
)



// Bell-like FM (non-integer ratio)
(
{
	var carrFreq = 440;
	var modFreq = 550;  // Non-integer ratio
	var modIndex = 5;
	var deviation = modFreq * modIndex;
	SinOsc.ar(carrFreq + SinOsc.ar(modFreq, mul: deviation), 0, 0.3);
}.freqscope
)




///////////////////// FM SynthDef /////////////////////


// A reusable FM synth
(

SynthDef(\fmSimple, {|freq=440, ratio=1, index=3, amp=0.2, gate=1|
	var modFreq = freq * ratio;
	var deviation = modFreq * index;
	var modulator = SinOsc.ar(modFreq, mul: deviation);
	var carrier = SinOsc.ar(freq + modulator, 0, amp);
	var env = EnvGen.ar(Env.asr(0.01, 1, 0.5), gate, doneAction: 2);
	Out.ar(0, carrier * env ! 2);
}).add;

)


// Play FM synth
x = Synth(\fmSimple, [\freq, 220, \ratio, 2, \index, 3]);

x.set(\index, 8);  // Brighter

x.set(\ratio, 1.5);  // Inharmonic

x.set(\gate, 0);  // Release




///////////////////// PMOsc - Phase Modulation /////////////////////


// PMOsc is a convenient FM/PM oscillator
{ PMOsc.ar(440, 220, 3, 0, 0.3) }.freqscope;



// Animate the modulation index
{ PMOsc.ar(440, 220, Line.kr(0, 10, 5), 0, 0.3) }.freqscope;



// FM bell using PMOsc
(
{
	var freq = 440;
	var env = EnvGen.kr(Env.perc(0.01, 3), doneAction: 2);
	var indexEnv = EnvGen.kr(Env.perc(0.01, 1)) * 8;
	PMOsc.ar(freq, freq * 1.4, indexEnv, 0, 0.3) * env;
}.play
)




///////////////////// Comparison /////////////////////


/*

Tremolo   : Slow amplitude modulation (< 20 Hz)
AM        : Fast amplitude modulation with unipolar modulator
Ring Mod  : Multiplication with bipolar modulator
FM        : Frequency modulation - very efficient for complex timbres

*/

