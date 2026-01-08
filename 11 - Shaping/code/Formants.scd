////////////////////////////////////////////////////////////////
//
//                    Formant Synthesis
//
////////////////////////////////////////////////////////////////

This document covers formant synthesis techniques for 
creating vocal-like and resonant timbres.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// What Are Formants? /////////////////////////


/*
   Formants are resonant peaks in a spectrum that give
   vowels and instruments their characteristic sounds.
   
   The human voice has several formants:
   F1 and F2 determine the vowel sound
   F3 and above add character
*/




///////////////////////// Formant Oscillator /////////////////////////


/*
   Formant.ar(fundfreq, formfreq, bwfreq, mul, add)
   
   fundfreq:  Fundamental (pitch)
   formfreq:  Formant frequency (resonant peak)
   bwfreq:    Bandwidth frequency (width of resonance)
*/


// Basic formant
{ Formant.ar(200, 800, 200, 0.3) }.freqscope;



// Explore formant: mouse controls formant frequency
(
{
	var fund = 100;
	var form = MouseX.kr(200, 3000);
	Formant.ar(fund, form, 100, 0.3);
}.freqscope
)



// Lower bandwidth = sharper resonance
(
{
	var bw = MouseY.kr(50, 500);
	Formant.ar(100, 800, bw, 0.3);
}.freqscope
)




///////////////////////// Vowel Formants /////////////////////////


/*
   Approximate formant frequencies for vowels (Hz):
   
   Vowel   F1     F2     F3
   -------------------------
   /a/     800    1200   2500
   /e/     400    2200   2600
   /i/     300    2300   3000
   /o/     500    800    2500
   /u/     350    600    2400
*/


// Vowel "a"
{ Formant.ar(100, 800, 100, 0.3) }.play;



// Vowel "i"
{ Formant.ar(100, 300, 100, 0.3) }.play;



// Vowel "o"
{ Formant.ar(100, 500, 100, 0.3) }.play;




///////////////////////// Multiple Formants /////////////////////////


// Combine formants for more realistic vowel
(
{
	var fund = 100;
	// Vowel "a" approximation
	var f1 = Formant.ar(fund, 800, 80);
	var f2 = Formant.ar(fund, 1200, 100);
	var f3 = Formant.ar(fund, 2500, 120);
	Mix([f1, f2 * 0.7, f3 * 0.3]) * 0.2;
}.freqscope
)



// Vowel "e" with formants
(
{
	var fund = 100;
	var f1 = Formant.ar(fund, 400, 80);
	var f2 = Formant.ar(fund, 2200, 100);
	var f3 = Formant.ar(fund, 2600, 120);
	Mix([f1, f2 * 0.5, f3 * 0.3]) * 0.2;
}.freqscope
)




///////////////////////// Animated Formants /////////////////////////


// Morphing between vowels
(
{
	var fund = 100;
	var morph = SinOsc.kr(0.3).range(0, 1);
	
	// Interpolate F1 and F2 between "a" and "i"
	var f1 = morph.linlin(0, 1, 800, 300);
	var f2 = morph.linlin(0, 1, 1200, 2300);
	
	var form1 = Formant.ar(fund, f1, 80);
	var form2 = Formant.ar(fund, f2, 100);
	
	Mix([form1, form2 * 0.7]) * 0.3;
}.play
)



// Mouse-controlled vowel space
(
{
	var fund = 100;
	var f1 = MouseX.kr(200, 900);
	var f2 = MouseY.kr(500, 2500);
	
	var form1 = Formant.ar(fund, f1, 80);
	var form2 = Formant.ar(fund, f2, 100);
	
	Mix([form1, form2 * 0.6]) * 0.3;
}.play
)




///////////////////////// Formlet /////////////////////////


/*
   Formlet - FOF (Fonction d'Onde Formantique) style synthesis
   
   Formlet.ar(input, freq, attackTime, decayTime)
   
   Creates a resonating impulse response at the formant frequency
*/


// Formlet driven by impulses
(
{
	var trig = Impulse.ar(100);  // Fundamental frequency
	Formlet.ar(trig, 800, 0.01, 0.1, 0.3);
}.freqscope
)



// Multiple formlets for vowel
(
{
	var fund = 100;
	var trig = Impulse.ar(fund);
	var f1 = Formlet.ar(trig, 800, 0.01, 0.1);
	var f2 = Formlet.ar(trig, 1200, 0.01, 0.08);
	var f3 = Formlet.ar(trig, 2500, 0.01, 0.05);
	Mix([f1, f2 * 0.5, f3 * 0.2]) * 0.2;
}.freqscope
)



// Animated formlet resonance
(
{
	var fund = 100;
	var trig = Impulse.ar(fund);
	var formFreq = SinOsc.kr(0.2).range(400, 1500);
	Formlet.ar(trig, formFreq, 0.01, 0.1, 0.3);
}.play
)




///////////////////////// Source-Filter Model /////////////////////////


/*
   Voice = Source (glottis) + Filter (vocal tract)
   
   Source: periodic (voiced) or noisy (unvoiced)
   Filter: resonant peaks (formants)
*/


// Voiced source with filtering
(
{
	var fund = 100;
	var source = Impulse.ar(fund);  // Glottal pulses
	var f1 = 800, f2 = 1200;        // Formants
	
	var filtered = BPF.ar(source, f1, 0.1) 
	             + BPF.ar(source, f2, 0.15);
	
	filtered * 10;
}.freqscope
)



// Mix voiced and unvoiced
(
{
	var fund = 100;
	var voiced = Impulse.ar(fund);
	var unvoiced = WhiteNoise.ar(0.1);
	var voiceMix = MouseX.kr(0, 1);  // 0=voiced, 1=unvoiced
	
	var source = (voiced * (1 - voiceMix)) + (unvoiced * voiceMix);
	
	// Simple formant filter
	BPF.ar(source, 800, 0.1) * 5;
}.play
)




///////////////////////// Klank for Formants /////////////////////////


/*
   Klank is a bank of resonators
   Good for creating formant-like spectra
*/


// Klank with vowel-like frequencies
(
{
	var source = Impulse.ar(100);
	Klank.ar(
		`[[800, 1200, 2500], [1, 0.7, 0.3], [0.5, 0.4, 0.2]],
		source
	) * 0.1;
}.freqscope
)



// Animated Klank formants
(
{
	var source = Impulse.ar(100);
	var f1 = SinOsc.kr(0.2).range(400, 900);
	var f2 = SinOsc.kr(0.25).range(800, 2000);
	
	DynKlank.ar(
		`[[f1, f2, 2500], [1, 0.6, 0.2], [0.3, 0.3, 0.2]],
		source
	) * 0.1;
}.play
)




///////////////////////// Vibrato /////////////////////////


// Add vibrato to vocal synthesis
(
{
	var vibRate = 5;
	var vibDepth = 4;  // Hz
	var vibrato = SinOsc.kr(vibRate, mul: vibDepth);
	var fund = 150 + vibrato;
	
	var f1 = Formant.ar(fund, 800, 80);
	var f2 = Formant.ar(fund, 1200, 100);
	
	Mix([f1, f2 * 0.6]) * 0.3;
}.play
)




///////////////////////// Formant SynthDef /////////////////////////


(

SynthDef(\vowel, {|fund=100, f1=800, f2=1200, f3=2500, amp=0.2, gate=1|
	var form1 = Formant.ar(fund, f1, f1 * 0.1);
	var form2 = Formant.ar(fund, f2, f2 * 0.1);
	var form3 = Formant.ar(fund, f3, f3 * 0.1);
	var sig = Mix([form1, form2 * 0.5, form3 * 0.2]);
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.3), gate, doneAction: 2);
	Out.ar(0, sig * env * amp ! 2);
}).add;

)


x = Synth(\vowel);

x.set(\f1, 400, \f2, 2200);  // Vowel "e"

x.set(\f1, 350, \f2, 600);   // Vowel "u"

x.set(\gate, 0);




///////////////////////// Reference /////////////////////////


/*

Formant UGens
-------------
Formant.ar(fund, formfreq, bwfreq)
Formlet.ar(input, freq, attackTime, decayTime)

Vowel Formants (approximate)
----------------------------
/a/ : F1=800,  F2=1200
/e/ : F1=400,  F2=2200
/i/ : F1=300,  F2=2300
/o/ : F1=500,  F2=800
/u/ : F1=350,  F2=600

Related UGens
-------------
Klank/DynKlank  - Bank of resonators
BPF             - Band-pass filter for formant peaks
Resonz          - Resonant band-pass

*/

