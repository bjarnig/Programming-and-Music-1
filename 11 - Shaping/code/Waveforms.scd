////////////////////////////////////////////////////////////////
//
//                       Waveforms
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Basic Waveforms /////////////////////////


// Sine - pure tone, single frequency
{ SinOsc.ar(200, 0, 0.3) }.freqscope;
{ SinOsc.ar(200) }.plot(0.01);



// Saw - all harmonics, falling 1/n
{ Saw.ar(200, 0.3) }.freqscope;
{ Saw.ar(200) }.plot(0.01);



// Pulse/Square - odd harmonics only
{ Pulse.ar(200, 0.5, 0.3) }.freqscope;
{ Pulse.ar(200, 0.5) }.plot(0.01);



// Triangle - odd harmonics, falling 1/n²
{ LFTri.ar(200, 0, 0.3) }.freqscope;
{ LFTri.ar(200) }.plot(0.01);




///////////////////////// Band-Limited vs LF /////////////////////////


/*
   Band-limited oscillators (Saw, Pulse) are anti-aliased
   They sound cleaner at high frequencies

   LF oscillators (LFSaw, LFPulse, LFTri) can alias
   But they can go to 0 Hz (DC) and are efficient for LFO use
*/


// Compare at high frequency - Saw is cleaner
{ Saw.ar(MouseX.kr(100, 5000)) * 0.2 }.freqscope;
{ LFSaw.ar(MouseX.kr(100, 5000)) * 0.2 }.freqscope;



// LF oscillators work at very low frequencies
{ LFSaw.ar(0.5) }.plot(4);  // 0.5 Hz, 4 second plot




///////////////////////// Pulse Width Modulation /////////////////////////


/*
   Pulse.ar(freq, width, mul, add)
   width: 0 to 1 (0.5 = square wave)
*/


// Square wave (50% duty cycle)
{ Pulse.ar(200, 0.5, 0.3) }.freqscope;



// Narrow pulse (more harmonics)
{ Pulse.ar(200, 0.1, 0.3) }.freqscope;



// Wide pulse (hollow sound)
{ Pulse.ar(200, 0.9, 0.3) }.freqscope;



// PWM - modulating pulse width
(
{
	var width = SinOsc.kr(0.5).range(0.1, 0.9);
	Pulse.ar(200, width, 0.3);
}.play
)




///////////////////////// Blip /////////////////////////


/*
   Blip - band-limited impulse oscillator
   Controllable number of harmonics
*/


// Few harmonics
{ Blip.ar(200, 5, 0.3) }.freqscope;



// Many harmonics
{ Blip.ar(200, 50, 0.3) }.freqscope;



// Animate harmonics
{ Blip.ar(200, MouseX.kr(1, 100), 0.3) }.freqscope;




///////////////////////// VarSaw /////////////////////////


/*
   VarSaw - variable duty cycle sawtooth
   Similar to Pulse but ramps instead of steps
*/


// Default VarSaw
{ VarSaw.ar(200, 0, 0.5, 0.3) }.freqscope;
{ VarSaw.ar(200, 0, 0.5) }.plot(0.01);



// Vary width with mouse
(
{
	var width = MouseX.kr(0, 1);
	VarSaw.ar(200, 0, width, 0.3);
}.play
)




///////////////////////// SyncSaw /////////////////////////


/*
   SyncSaw - hard sync sawtooth
   Second frequency resets at first frequency
*/


// Basic sync saw
{ SyncSaw.ar(100, 300, 0.3) }.freqscope;



// Animated sync
(
{
	var syncFreq = MouseX.kr(100, 1000);
	SyncSaw.ar(100, syncFreq, 0.3);
}.play
)




///////////////////////// Phase and Detuning /////////////////////////


// Phase offset
(
{
	var osc1 = SinOsc.ar(400, 0);
	var osc2 = SinOsc.ar(400, pi);  // 180 degrees out of phase
	[osc1, osc2] * 0.3;
}.scope
)



// Detuning for thickness
(
{
	var freq = 200;
	var osc1 = Saw.ar(freq * 0.99);
	var osc2 = Saw.ar(freq);
	var osc3 = Saw.ar(freq * 1.01);
	Mix([osc1, osc2, osc3]) * 0.15;
}.play
)



// Classic supersaw
(
{
	var freq = 100;
	var detunes = [-0.03, -0.02, -0.01, 0, 0.01, 0.02, 0.03];
	var oscs = Saw.ar(freq * (1 + detunes));
	Splay.ar(oscs, 0.8) * 0.2;
}.play
)




///////////////////////// Waveshaping /////////////////////////


// Basic waveshaping with .clip
(
{
	var sig = SinOsc.ar(200);
	sig = sig.clip(-0.3, 0.3);  // Hard clip
	sig * 0.5;
}.freqscope
)



// Soft clipping with tanh
(
{
	var sig = SinOsc.ar(200) * 5;  // Overdrive
	sig = sig.tanh;  // Soft clip
	sig * 0.3;
}.freqscope
)



// Wrap - foldback distortion
(
{
	var sig = SinOsc.ar(200) * MouseX.kr(0.5, 3);
	sig = sig.wrap(-1, 1);
	sig * 0.3;
}.freqscope
)



// Fold - symmetric foldback
(
{
	var sig = SinOsc.ar(200) * MouseX.kr(0.5, 3);
	sig = sig.fold(-1, 1);
	sig * 0.3;
}.freqscope
)




///////////////////////// Combining Waveforms /////////////////////////


// Mix for layering
(
{
	var saw = Saw.ar(100, 0.3);
	var pulse = Pulse.ar(100, 0.3, 0.2);
	var sine = SinOsc.ar(100, 0, 0.4);
	saw + pulse + sine;
}.freqscope
)



// Ring modulation between oscillators
(
{
	var osc1 = Saw.ar(100);
	var osc2 = SinOsc.ar(300);
	osc1 * osc2 * 0.3;
}.freqscope
)




///////////////////////// Sub-Oscillators /////////////////////////


// Add sub-octave for bass
(
{
	var main = Saw.ar(200, 0.3);
	var sub = SinOsc.ar(100, 0, 0.4);  // One octave down
	main + sub;
}.freqscope
)



// Multiple sub-octaves
(
{
	var freq = 200;
	var main = Saw.ar(freq, 0.3);
	var sub1 = Pulse.ar(freq/2, 0.5, 0.2);
	var sub2 = SinOsc.ar(freq/4, 0, 0.3);
	Mix([main, sub1, sub2]);
}.freqscope
)




///////////////////////// DC Offset /////////////////////////


// Check for DC offset
{ Pulse.ar(100, 0.9) }.scope;  // Asymmetric = DC offset



// Remove DC with LeakDC
(
{
	var sig = Pulse.ar(100, 0.9, 0.3);
	LeakDC.ar(sig);
}.scope
)




///////////////////////// Oscillator SynthDef /////////////////////////


(

SynthDef(\superOsc, {|freq=200, detune=0.01, mix=0.5, amp=0.2, gate=1|
	var saws = Saw.ar(freq * [1-detune, 1, 1+detune]);
	var pulse = Pulse.ar(freq, 0.5);
	var sig = Mix(saws) * mix + (pulse * (1 - mix));
	var env = EnvGen.kr(Env.asr(0.01, 1, 0.3), gate, doneAction: 2);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


x = Synth(\superOsc);

x.set(\detune, 0.03);

x.set(\mix, 0);  // More pulse

x.set(\gate, 0);




///////////////////////// Reference /////////////////////////


/*

Band-Limited Oscillators
------------------------
SinOsc   Sine wave
Saw      Sawtooth (all harmonics)
Pulse    Square/pulse (odd harmonics)
Blip     Variable harmonic impulse
VarSaw   Variable width saw
SyncSaw  Hard sync sawtooth

LF (Non-Band-Limited)
---------------------
LFSaw    Sawtooth
LFPulse  Pulse/square
LFTri    Triangle
LFPar    Parabolic

Waveshaping
-----------
.clip    Hard clipping
.tanh    Soft clipping
.wrap    Wrap around
.fold    Fold back
.distort SC distortion curve

*/

