////////////////////////////////////////////////////////////////
//
//                   Modulation - Solutions
//
////////////////////////////////////////////////////////////////


// Exercise 1: Tremolo with Variable Rate

(
{
	var carrier = SinOsc.ar(440, 0, 0.3);
	var tremoloRate = LFNoise2.kr(0.5).range(2, 15); // Rate varies between 2-15 Hz
	var tremolo = SinOsc.kr(tremoloRate, mul: 0.5, add: 0.5); // Unipolar
	carrier * tremolo ! 2;
}.play
)



// Exercise 2: Amplitude Modulation Exploration

(
{
	var carrFreq = LFNoise2.kr(0.3).range(300, 600);
	var modFreq = LFNoise2.kr(0.4).range(50, 300);
	
	var carrier = SinOsc.ar(carrFreq);
	var modulator = SinOsc.ar(modFreq, mul: 0.5, add: 0.5); // Unipolar for AM
	
	carrier * modulator * 0.3 ! 2;
}.freqscope
)



// Exercise 3: Ring Modulation with Envelopes

(
{
	var duration = 2;
	var env = EnvGen.kr(Env.perc(0.01, duration), doneAction: 2);
	
	var carrFreq = EnvGen.kr(Env([800, 600, 400], [0.1, 1.9]));
	var modFreq = EnvGen.kr(Env([150, 100, 80], [0.2, 1.8]));
	
	var carrier = SinOsc.ar(carrFreq);
	var modulator = SinOsc.ar(modFreq);
	
	var ring = carrier * modulator * env * 0.3;
	ring ! 2;
}.play
)



// Exercise 4: FM Bell Sound

(
{
	var carrFreq = 440;
	var ratio = 1.4;
	var modFreq = carrFreq * ratio;
	
	var ampEnv = EnvGen.kr(Env.perc(0.01, 3), doneAction: 2);
	var indexEnv = EnvGen.kr(Env.perc(0.001, 2.5)) * 10;
	
	var modulator = SinOsc.ar(modFreq, mul: modFreq * indexEnv);
	var carrier = SinOsc.ar(carrFreq + modulator);
	
	carrier * ampEnv * 0.3 ! 2;
}.play
)



// Exercise 5: Complex FM with Multiple Operators

// Three operators: Op3 modulates Op2, Op2 modulates Op1 (carrier)
(
{
	var baseFreq = 200;
	
	// Operator 3 (deepest modulator)
	var op3Freq = baseFreq * 2.5;
	var op3Index = 1.5;
	var op3 = SinOsc.ar(op3Freq, mul: op3Freq * op3Index);
	
	// Operator 2 (middle modulator, modulated by Op3)
	var op2Freq = baseFreq * 1.5;
	var op2Index = 2;
	var op2 = SinOsc.ar(op2Freq + op3, mul: op2Freq * op2Index);
	
	// Operator 1 (carrier, modulated by Op2)
	var carrier = SinOsc.ar(baseFreq + op2);
	
	carrier * 0.3 ! 2;
}.freqscope
)

// Alternative: Parallel FM structure
(
{
	var baseFreq = 300;
	
	// Two modulators affecting one carrier
	var mod1 = SinOsc.ar(baseFreq * 1.3, mul: baseFreq * 1.3 * 2);
	var mod2 = SinOsc.ar(baseFreq * 2.7, mul: baseFreq * 2.7 * 1.5);
	
	// Carrier modulated by both
	var carrier = SinOsc.ar(baseFreq + mod1 + mod2);
	
	carrier * 0.3 ! 2;
}.freqscope
)

