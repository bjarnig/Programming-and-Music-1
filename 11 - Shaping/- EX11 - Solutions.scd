////////////////////////////////////////////////////////////////
//
//                     Shaping - Solutions
//
////////////////////////////////////////////////////////////////


// Exercise 1: Simple Filtered Noise

(
{
	var noise = WhiteNoise.ar(0.5);
	var cutoff = LFNoise2.kr(0.5).range(300, 2000);
	RLPF.ar(noise, cutoff, 0.3) ! 2;
}.play
)



// Exercise 2: Saw Wave with Filter Sweep

(
{
	var saw = Saw.ar(100, 0.3);
	var cutoff = SinOsc.kr(0.5).range(200, 1500);
	RLPF.ar(saw, cutoff, 0.3) ! 2;
}.play
)



// Exercise 3: Pulse Width Modulation

(
{
	var width = LFTri.kr(0.5).range(0.1, 0.9);
	Pulse.ar(110, width, 0.3) ! 2;
}.play
)



// Exercise 4: Tremolo Effect

(
{
	var sig = Mix(Saw.ar([80, 81, 82], 0.15));
	var tremolo = SinOsc.kr(6).range(0.2, 1);
	sig * tremolo ! 2;
}.play
)



// Exercise 5: Percussive Filter Envelope

(
{
	var ampEnv = EnvGen.kr(Env.perc(0.01, 0.8), doneAction: 2);
	var filtEnv = EnvGen.kr(Env.perc(0.01, 0.3));
	var sig = Saw.ar(100);
	sig = RLPF.ar(sig, filtEnv.range(200, 3000), 0.3);
	sig * ampEnv * 0.4 ! 2;
}.play
)



// Exercise 6: Simple Ring Modulation

(
{
	var env = EnvGen.kr(Env.perc(0.01, 1.5), doneAction: 2);
	var carrier = SinOsc.ar(300);
	var modulator = SinOsc.ar(150);
	var ring = carrier * modulator;
	ring * env * 0.3 ! 2;
}.play
)



// Exercise 7: Dust Triggered Tones

(
{
	var trig = Dust.ar(8);
	var freq = TRand.ar(400, 1600, trig);
	var env = EnvGen.ar(Env.perc(0.01, 0.2), trig);
	SinOsc.ar(freq) * env * 0.3 ! 2;
}.play
)



// Exercise 8: Additive Synthesis with Envelopes

(
{
	var freqs = [100, 200, 300, 400, 500];
	var sig = Mix.fill(5, {|i|
		var env = EnvGen.kr(Env.perc(rrand(0.01, 0.2), rrand(0.5, 2.0)));
		SinOsc.ar(freqs[i]) * env / (i + 1);
	});
	sig * 0.3 ! 2;
}.play
)



// Exercise 9: Layered Noise Bands

(
{
	var freqs = [500, 1500, 3000];
	var bws = [0.1, 0.05, 0.02];
	var pans = [-1, 0, 1];
	var sig = Mix.fill(3, {|i|
		var noise = WhiteNoise.ar;
		var filtered = BPF.ar(noise, freqs[i], bws[i], 3);
		Pan2.ar(filtered, pans[i]);
	});
	sig * 0.2;
}.play
)



// Exercise 10: LFO Pitch Modulation

(
{
	var freq = LFNoise2.kr(0.5).range(50, 400);
	Blip.ar(freq, 8, 0.3) ! 2;
}.play
)



// Exercise 11: Detuned Oscillator Stack

(
{
	var sig = Mix(Saw.ar([198, 199, 200, 201, 202], 0.1));
	var lfo = SinOsc.kr(0.3).range(0.5, 1);
	sig * lfo ! 2;
}.play
)



// Exercise 12: Filtered Dust with Resonance

(
{
	var dust = Dust.ar(150, 0.1);
	var filtered = Resonz.ar(dust, 800, 0.05, 3);
	filtered ! 2;
}.play
)



// Exercise 13: Sample and Hold Melody

(
{
	var trig = Impulse.kr(6);
	var freqs = [220, 247, 277, 330, 370];
	var freq = TChoose.kr(trig, freqs);
	freq = Lag.kr(freq, 0.03);
	var sig = SinOsc.ar(freq, 0, 0.3);
	sig ! 2;
}.play
)



// Exercise 14: Waveshaping with Fold

(
{
	var sig = SinOsc.ar(120);
	var amount = LFNoise2.kr(0.3).range(1, 3);
	(sig * amount).fold2(1) * 0.3 ! 2;
}.play
)
