////////////////////////////////////////////////////////////////
//
//                     Shaping - Solutions
//
////////////////////////////////////////////////////////////////


// Exercise 1: Lag for Smooth Transitions

// Without Lag
(
{
	var freq = LFNoise0.kr(5).range(200, 800);
	Saw.ar(freq, 0.3) ! 2;
}.play
)

// With Lag
(
{
	var freq = LFNoise0.kr(5).range(200, 800);
	freq = Lag.kr(freq, 0.1); // Smooth the jumps
	Saw.ar(freq, 0.3) ! 2;
}.play
)

// Side-by-side comparison
(
{
	var rawFreq = LFNoise0.kr(5).range(200, 800);
	var lagFreq = Lag.kr(rawFreq, 0.08);
	[Saw.ar(rawFreq, 0.2), Saw.ar(lagFreq, 0.2)];
}.play
)



// Exercise 2: Sample and Hold Melody

(
{
	var trig = Impulse.kr(6); // 6 Hz trigger rate
	var scale = [60, 62, 65, 67, 69].midicps; // Pentatonic scale
	var freq = TChoose.kr(trig, scale);
	freq = Lag.kr(freq, 0.02); // Slight smoothing
	var sig = Pulse.ar(freq, 0.3, 0.3);
	sig ! 2;
}.play
)

// Alternative with TRand
(
{
	var trig = Impulse.kr(8);
	var freq = TExpRand.kr(200, 800, trig);
	freq = Lag.kr(freq, 0.01);
	SinOsc.ar(freq, 0, 0.3) ! 2;
}.play
)



// Exercise 3: Waveshaping Comparison

// Using clip2
(
{
	var sig = SinOsc.ar(200) * 3;
	sig.clip2(1) * 0.3 ! 2;
}.freqscope
)

// Using fold2
(
{
	var sig = SinOsc.ar(200) * 3;
	sig.fold2(1) * 0.3 ! 2;
}.freqscope
)

// Using wrap2
(
{
	var sig = SinOsc.ar(200) * 3;
	sig.wrap2(1) * 0.3 ! 2;
}.freqscope
)

// All three at once (different channels)
(
{
	var sig = SinOsc.ar(200) * 3;
	[
		sig.clip2(1) * 0.3,
		sig.fold2(1) * 0.3,
		sig.wrap2(1) * 0.3
	];
}.play
)



// Exercise 4: Lo-Fi Effect

(
{
	var sig = Saw.ar([110, 111], 0.5);
	
	// Sample rate reduction controlled by MouseX
	var sampleRate = MouseX.kr(500, 20000);
	sig = Latch.ar(sig, Impulse.ar(sampleRate));
	
	// Bit depth reduction controlled by MouseY
	var bitDepth = MouseY.kr(0.5, 0.005);
	sig = sig.round(bitDepth);
	
	sig * 0.3;
}.play
)

// Alternative with visualization
(
{
	var sig = Mix(Pulse.ar([100, 150, 200], 0.5, 0.2));
	var sr = MouseX.kr(1000, 15000);
	var bits = MouseY.kr(0.3, 0.01);
	
	sig = Latch.ar(sig, Impulse.ar(sr));
	sig = sig.round(bits);
	
	LPF.ar(sig, 5000) ! 2;
}.freqscope
)



// Exercise 5: Complex Shaping Chain

(
{
	// Complex source: filtered noise with multiple oscillators
	var source1 = BPF.ar(WhiteNoise.ar, LFNoise2.kr(0.5).range(300, 2000), 0.3, 3);
	var source2 = Saw.ar([80, 81], 0.3);
	var complex = source1 + source2;
	
	// Apply VarLag for smoothing
	var lagged = VarLag.ar(complex, 0.003);
	
	// Sample and hold on amplitude
	var trig = Impulse.kr(8);
	var amp = Latch.kr(LFNoise2.kr(3), trig).range(0.5, 1);
	
	// Waveshaping with fold
	var shaped = (lagged * amp * 1.5).fold2(0.7);
	
	// Quantization
	var quantized = shaped.round(0.05);
	
	// Final smoothing
	var output = Lag.ar(quantized, 0.001);
	
	output * 0.4;
}.play
)

// Alternative complex chain
(
{
	// Start with ring modulated signal
	var carrier = Saw.ar(150);
	var modulator = SinOsc.ar(LFNoise2.kr(0.3).range(80, 200));
	var source = carrier * modulator;
	
	// Smooth with Lag2
	var smoothed = Lag2.ar(source, 0.002);
	
	// Wrap the signal
	var wrapped = (smoothed * 2).wrap2(0.8);
	
	// Sample rate reduction at audio rate
	var crushed = Latch.ar(wrapped, Impulse.ar(LFNoise2.kr(0.5).range(3000, 10000)));
	
	// Final clipping
	var output = crushed.softclip;
	
	output * 0.3 ! 2;
}.play
)

