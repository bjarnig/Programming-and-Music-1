////////////////////////////////////////////////////////////////
//
//                      Synthesis 2
//
////////////////////////////////////////////////////////////////

This document contains examples covering additive synthesis,
fm synthesis, subtractive synthesis, noises, filters and physical
modelling synthesis.

( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

////////////////////// Modulation Synthesis //////////////////////

( // Ring Modulation

{
	a = SinOsc.ar(200);
	b = SinOsc.ar(XLine.kr(20,2000,4));
	(a * b) * 0.1
}.play

)

// Blip (buzz), all harmonics have equal amplitude but number of harmonics is configurable.
(
	{
		Blip.ar(100, LFNoise1.kr(10.1).range(10, 200), 0.4) ! 2
	}.freqscope;
)


// LFO for amplitude (tremolo)
(
	{
		var sig, lfo;
		lfo = SinOsc.kr(MouseX.kr(1,20));
		sig = Saw.ar(83, lfo) * 0.5;
		sig!2
	}.play
)




// LFO for pitch variation (vibrato)
(
	{
		var sig, mod;
		mod = SinOsc.ar(MouseY.kr(40, 0.5), 0, MouseX.kr(5, 20));
		sig = Blip.ar(369 + mod, 100, 0.8);
		sig!2
	}.play
)





////////////////////// FM Synthesis //////////////////////


// Modulate frequency with LFO (Low Frequency Oscillator)
{ SinOsc.ar(LFSaw.kr(100, 0, 400, 400), 0, 0.5) }.play



// LFTri
{ SinOsc.ar(LFTri.kr(2, 0, 400, 400), 0, 0.5) }.play



// LFPulse
{ SinOsc.ar(LFPulse.kr(3, 1, 0.3, 200, 200),0, 0.7) }.play



// LFPar
{ SinOsc.ar(LFPar.kr(2, 0, 400, 400),0, 0.5) }.play



// LFCub
{ SinOsc.ar(LFCub.kr(2, 0, 400, 400),0, 0.5) }.play



// Other waveforms
{ LFSaw.ar(LFTri.kr(4, 0, 200, 400), 0, 0.7) }.play
{ LFTri.ar(LFSaw.kr(4, 0, 200, 800), 0, 0.7) }.play



// Modulation in audio rate produces new frequencies called sidebands.
{ SinOsc.ar(LFPar.kr(105, 0, 400, 400),0, 0.5) }.play



// FM with two sine waves
(
    var carrierFreq = 400, modFreq = 50, deviation = 100;
    {
	    SinOsc.ar(carrierFreq + SinOsc.ar(modFreq, mul: deviation),mul: 0.3);
    }.scope
)



// FM with index
(
    var carrfreq=440, modfreq=55, modindex=10.5;
    {
        SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)), mul: 0.5)
    }.scope;
)



// Phase Modulation, modulate carfreq
{ PMOsc.ar(Line.kr(600, 10, 3), Line.kr(600, 10, 3), 3, 0, 0.1) }.play;



// Modulate modfreq
{ PMOsc.ar(300, Line.kr(600, 900, 5), 3, 0, 0.1) }.play;



 // Modulate index
{ PMOsc.ar(300, 550, Line.ar(0,20,8), 0, 0.1) }.play;

(
	{
		var carrierFreq = 400, modFreq = 50, index = 3, decayTime = 5;
		EnvGen.kr(Env.perc(0.001,decayTime,0.2),1,doneAction: 2) *
	  	PMOsc.ar(carrierFreq, modFreq, index,0);
	}.scope
)



// FM Synthdef
(
	SynthDef(\fm, {
		|carrierFreq = 400,  cmRatio = 1.5, index = 3, decayTime = 0.01, amp = 1|
		var signal,modFreq;
		modFreq = (carrierFreq * cmRatio.reciprocal);
		signal = EnvGen.kr(Env.perc(0.001,decayTime,0.2),1, amp,doneAction: 2) *
	    PMOsc.ar(carrierFreq, modFreq, index,0);
	    Out.ar(0,signal)
	}).add
)



// Play an instance
Synth(\fm, [\decayTime, 5])


Synth(\fm, [\decayTime, 1, \carrierFreq, 200])




// With routines,random carrierFreqs and random offset between events
(
	Routine({
		{ Synth(\fm, [\carrierFreq, rrand(100.0,1000)]);
	    	rrand(0.001,0.1).wait;
	   	}.loop
 	}).play
)




////////////////////// Physical Modeling ////////////////////////


(
SynthDef("pluck", {arg beat=1.0, dec=1.0, pitch=60, amp=0.5;
	var sig, delay, trig, source;
	// calculate the delay time from MIDI pitch:
	delay = pitch.midicps.reciprocal;
	// a clock:
	trig = Impulse.ar(beat);
	// a sound source to process:
	source = GrayNoise.ar(amp);
	// a triggered percussive envelope on the source:
	sig = Decay2.ar(trig, 0.003, 0.05, source);
	// comb filter (delay with feedback) on the percussive signal:
	sig = CombL.ar(sig, 0.2, [delay, delay*1.01], dec);
	// remove the DC offset that comes from the comb:
	sig = LeakDC.ar(sig);
	// send the signal to the output:
	Out.ar(0, sig)
	}).add;
)



// Test it with a single synth:
y = Synth("pluck", [\beat, 1, \pitch, 80, \dec, 1.5, \amp, 0.4 ])
y.free



// Use whitenoise for excitation
(
	{
		var burstEnv, att = 0, dec = 0.001;
		var burst, delayTime, delayDecay = 0.5;
		var midiPitch = 60;
		delayTime = midiPitch.midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec),
		gate: Impulse.kr(1/delayDecay));
		burst = WhiteNoise.ar(burstEnv);
		CombL.ar(burst, delayTime, delayTime, delayDecay, add:burst);
	}.play
)



// Use pinknoise for excitation
(
	{
		var burstEnv, att = 0, dec = 0.001;
		var burst, delayTime, delayDecay = 0.5;
		var midiPitch = 70;
		delayTime = midiPitch.midicps.reciprocal;
		burstEnv = EnvGen.kr(Env.perc(att, dec),
		gate: Impulse.kr(1/delayDecay));
		burst = PinkNoise.ar(burstEnv);
		CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
	}.play
)
