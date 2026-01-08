////////////////////////////////////////////////////////////////
//
//                          LFOs
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// LFO Basics /////////////////////////


/*
   LFOs are oscillators running at LOW frequencies (typically < 20 Hz)
   Used to modulate parameters like frequency, amplitude, filter cutoff
*/


// Basic LFO modulating amplitude (tremolo)
(

{
	var lfo = SinOsc.kr(4);  // 4 Hz control rate
	var carrier = SinOsc.ar(440);
	carrier * lfo * 0.3;
}.play

)



// LFO modulating frequency (vibrato)
(
{
	var lfo = SinOsc.kr(5, mul: 20);  // 5 Hz, ±20 Hz deviation
	SinOsc.ar(440 + lfo, 0, 0.3);
}.play
)




///////////////////////// LFO Shapes /////////////////////////


// Sine LFO - smooth, natural
{ SinOsc.kr(1) }.plot(2);



// Triangle LFO - linear, symmetrical
{ LFTri.kr(1) }.plot(2);



// Saw LFO - linear ramp up
{ LFSaw.kr(1) }.plot(2);



// Pulse LFO - on/off switching
{ LFPulse.kr(1) }.plot(2);




///////////////////////// Comparing LFO Shapes /////////////////////////


// Sine modulation - smooth vibrato
(
{
	var lfo = SinOsc.kr(5, mul: 30);
	SinOsc.ar(440 + lfo, 0, 0.3);
}.play
)


// Saw modulation - repeating pitch fall
(
{
	var lfo = LFSaw.kr(5, mul: 30);
	SinOsc.ar(440 + lfo, 0, 0.3);
}.play
)



// Pulse modulation - alternating between two pitches
(
{
	var lfo = LFPulse.kr(5);
	SinOsc.ar(lfo.range(400, 500), 0, 0.3);
}.play
)




///////////////////////// Range Scaling /////////////////////////


/*
   LFOs output -1 to 1 (bipolar) or 0 to 1 (unipolar)
   Use .range or mul/add to scale to useful values
*/


// .range method - most intuitive
{ SinOsc.kr(1).range(200, 800) }.plot(2);



// mul and add parameters
{ SinOsc.kr(1, mul: 300, add: 500) }.plot(2);  // Same as .range(200, 800)



// Unipolar: LFPulse is 0 to 1 by default
{ LFPulse.kr(1) }.plot(2);



// Make it bipolar with mul/add
{ LFPulse.kr(1, mul: 2, add: -1) }.plot(2);


// Scaling values examples

( { SinOsc.ar(100, add:1000, mul:500) }.plot )


( { SinOsc.ar(100, add:1000, mul:500).range(4000,4500) }.plot )


( { SinOsc.ar(100).range(1, 10).linexp(1, 10, 10, 100) }.plot )


( { SinOsc.ar(100).range(1, 10).explin(1, 10, 10, 100) }.plot )



///////////////////////// Noise-Based LFOs /////////////////////////


// LFNoise0 - stepped random values
{ LFNoise0.kr(4) }.plot(2);



// LFNoise1 - linear interpolated random
{ LFNoise1.kr(4) }.plot(2);



// LFNoise2 - cubic interpolated (smoothest)
{ LFNoise2.kr(4) }.plot(2);




///////////////////////// Random Modulation /////////////////////////


// Stepped random pitch changes
(
{
	var lfo = LFNoise0.kr(8).range(300, 600);
	SinOsc.ar(lfo, 0, 0.3);
}.play
)



// Smooth random pitch drift
(
{
	var lfo = LFNoise2.kr(0.5).range(400, 600);
	SinOsc.ar(lfo, 0, 0.3);
}.play
)



// Random amplitude modulation
(
{
	var lfo = LFNoise2.kr(3).range(0, 1);
	SinOsc.ar(440, 0, 0.3) * lfo;
}.play
)




///////////////////////// Multiple LFOs /////////////////////////


// LFO on LFO: modulating the modulator
(
{
	var lfoRate = LFNoise2.kr(0.5).range(2, 10);
	var lfo = SinOsc.kr(lfoRate, mul: 50);
	SinOsc.ar(440 + lfo, 0, 0.3);
}.play
)



// Two LFOs for complex modulation
(
{
	var freqLfo = SinOsc.kr(0.3, mul: 100);
	var ampLfo = SinOsc.kr(4).range(0.1, 0.4);
	SinOsc.ar(440 + freqLfo) * ampLfo;
}.play
)




///////////////////////// Unipolar vs Bipolar /////////////////////////


/*
   Bipolar: -1 to 1 (centered on 0)
   Unipolar: 0 to 1 (always positive)

   Use unipolar for amplitude, filters (things that shouldn't go negative)
   Use bipolar for frequency deviation
*/


// Unipolar amplitude modulation
(
{
	var lfo = SinOsc.kr(4).range(0, 1);  // 0 to 1
	SinOsc.ar(440) * lfo * 0.3;
}.play
)



// Bipolar frequency modulation (vibrato)
(
{
	var lfo = SinOsc.kr(5, mul: 30);  // -30 to +30
	SinOsc.ar(440 + lfo, 0, 0.3);
}.play
)




///////////////////////// Sample and Hold /////////////////////////


// Latch: sample input when triggered
(
{
	var trigger = Impulse.kr(4);
	var noise = WhiteNoise.kr;
	var lfo = Latch.kr(noise, trigger).range(300, 600);
	SinOsc.ar(lfo, 0, 0.3);
}.play
)




///////////////////////// LFO Phase /////////////////////////


// Two LFOs with different phases
(
{
	var lfo1 = SinOsc.kr(1, 0);       // Phase 0
	var lfo2 = SinOsc.kr(1, pi/2);    // Phase 90 degrees
	var sig1 = SinOsc.ar(440) * lfo1.range(0, 0.3);
	var sig2 = SinOsc.ar(550) * lfo2.range(0, 0.3);
	sig1 + sig2;
}.play
)




///////////////////////// Sync and Reset /////////////////////////


// LFSaw with trigger reset
(
{
	var trig = Impulse.kr(0.5);
	var lfo = LFSaw.kr(2, 0, 0.5, 0.5);
	var reset = Phasor.kr(trig, 2/SampleRate.ir, 0, 1);
	SinOsc.ar(reset.range(200, 800), 0, 0.3);
}.play
)




///////////////////////// Practical Examples /////////////////////////


// Saw
(
{
	var saw = SinOsc.kr(MouseX.kr(1, 20)).range(100, 1000);
	var sig = Saw.ar([55, 55.5]);
	RLPF.ar(sig, saw, 0.3, 0.3);
}.play
)



// Slow evolving drone
(
{
	var freq1 = LFNoise2.kr(0.1).range(100, 200);
	var freq2 = LFNoise2.kr(0.15).range(150, 250);
	var amp1 = LFNoise2.kr(0.2).range(0.1, 0.3);
	var amp2 = LFNoise2.kr(0.25).range(0.1, 0.3);
	SinOsc.ar([freq1, freq2]) * [amp1, amp2];
}.play
)



// Rhythmic gating
(
{
	var gate = LFPulse.kr(4, width: 0.3);
	var sig = Saw.ar([100, 101], 0.3);
	sig * gate;
}.play
)




///////////////////////// LFO SynthDef /////////////////////////


// Synth with built-in LFO controls
(

SynthDef(\lfoSynth, {|freq=440, lfoFreq=5, lfoDepth=0.5, amp=0.2|
	var lfo = SinOsc.kr(lfoFreq, mul: freq * lfoDepth);
	var sig = SinOsc.ar(freq + lfo, 0, amp);
	Out.ar(0, sig ! 2);
}).add;

)


x = Synth(\lfoSynth);

x.set(\lfoFreq, 8);

x.set(\lfoDepth, 0.1);

x.free;




///////////////////////// Reference /////////////////////////


/*

LFO UGens
---------
SinOsc.kr    Sine wave
LFTri.kr     Triangle wave
LFSaw.kr     Sawtooth wave
LFPulse.kr   Pulse/square wave
LFNoise0.kr  Stepped random
LFNoise1.kr  Linear interpolated random
LFNoise2.kr  Smooth random

Scaling
-------
.range(lo, hi)           Scale to range
mul: x, add: y           Manual scaling
.linlin(a,b,c,d)         Linear mapping
.linexp(a,b,c,d)         Linear to exponential

*/

