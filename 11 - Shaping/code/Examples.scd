////////////////////////////////////////////////////////////////
//
//                       Examples
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Filtered Noise /////////////////////////


// White noise through resonant lowpass
(
{
	var noise = WhiteNoise.ar(0.5);
	RLPF.ar(noise, MouseX.kr([100,150], 5000, 1), MouseY.kr(0.01, 0.5));
}.play
)



// Pink noise with bandpass sweep
(
{
	var noise = PinkNoise.ar(0.5);
	var freq = LFNoise2.kr(0.5).range(200, 2000);
	BPF.ar(noise, freq, 0.1, 3);
}.play
)



// Dust through resonant filter
(
{
	var src = Dust.ar(200, 0.5);
	var freq = LFNoise1.kr(2).range(300, 3000);
	Resonz.ar(src, freq, 0.05, 5) ! 2;
}.play
)




///////////////////////// LFOs with Oscillators /////////////////////////


// Saw with LFO filter sweep
(
{
	var sig = Saw.ar([50, 51], 0.3);
	var cutoff = SinOsc.kr(0.2).range(200, 2000);
	RLPF.ar(sig, cutoff, 0.3);
}.play
)



// Pulse with PWM
(
{
	var width = LFTri.kr(0.5).range(0.1, 0.9);
	Pulse.ar([100, 100.5], width, 0.2);
}.play
)



// Detuned saws with tremolo
(
{
	var sig = Mix(Saw.ar([99, 100, 101], 0.15));
	var tremolo = SinOsc.kr(4).range(0.3, 1);
	sig * tremolo ! 2;
}.play
)



// Noise LFO modulating pitch
(
{
	var freq = LFNoise2.kr(3).range(20, 600);
	Blip.ar(freq, 10, 0.3) ! 2;
}.play
)




///////////////////////// Envelopes with Modulation /////////////////////////


// Percussive hit with filter envelope
(
{
	var ampEnv = EnvGen.kr(Env.perc(0.01, 0.5), doneAction: 2);
	var filtEnv = EnvGen.kr(Env.perc(0.01, 0.2));
	var sig = Saw.ar([100, 101]);
	sig = RLPF.ar(sig, filtEnv.range(100, 3000), 0.3);
	sig * ampEnv * 0.3;
}.play
)



// Slow vibrato with linen envelope
(
{
	var env = EnvGen.kr(Env.linen(2, 3, 2), doneAction: 2);
	var vibrato = SinOsc.kr(5, mul: 5);
	var sig = SinOsc.ar([300.rand + vibrato, 221 + vibrato], 0, 0.2);
	sig * env;
}.play
)



// FM with modulation index envelope
(
{
	var env = EnvGen.kr(Env.perc(0.01, 2), doneAction: 2);
	var indexEnv = EnvGen.kr(Env.perc(0.01, 0.5)) * 10;
	var mod = SinOsc.ar(440) * 440 * indexEnv;
	SinOsc.ar(440 + mod) * env * 0.3 ! 2;
}.play
)




///////////////////////// Signal Shaping /////////////////////////


// Soft clipping with overdrive
(
{
	var sig = SinOsc.ar([200, 201]);
	var drive = MouseX.kr(1, 10);
	(sig * drive).tanh * 0.3;
}.play
)



// Waveshaping with fold
(
{
	var sig = SinOsc.ar(100);
	var amount = LFNoise2.kr(0.5).range(1, 3);
	(sig * amount).fold(-1, 1) * 0.3 ! 2;
}.play
)



// Ring mod with envelope
(
{
	var env = EnvGen.kr(Env.perc(0.01, 1), doneAction: 2);
	var carrier = SinOsc.ar(300);
	var modulator = SinOsc.ar(400);
	carrier * modulator * env * 0.3 ! 2;
}.play
)




///////////////////////// Layered /////////////////////////


// Additive with individual envelopes
(
{
	var fund = 100;
	var sig = Mix.fill(8, {|i|
		var freq = fund * (i + 1);
		var env = EnvGen.kr(Env.perc(rrand(0.1, 0.5), rrand(1, 3)));
		SinOsc.ar(freq * rrand(0.99, 1.01)) * env / (i + 1)
	});
	sig * 0.3 ! 2;
}.play
)



// Noise bands with LFO panning
(
{
	var bands = 5.collect({|i|
		var freq = exprand(200, 4000);
		var sig = BPF.ar(WhiteNoise.ar, freq, 0.05, 3);
		var pan = LFNoise2.kr(rrand(0.1, 0.5));
		Pan2.ar(sig, pan)
	});
	Mix(bands) * 0.15;
}.play
)



// Detuned oscillators with Splay
(
{
	var freq = 80;
	var sigs = 7.collect({|i|
		var detune = (i - 3) * 0.01;
		Saw.ar(freq * (1 + detune))
	});
	Splay.ar(sigs) * 0.15;
}.play
)




///////////////////////// Crackle and Dust /////////////////////////


// Sine and Crackle
(
{
	var amount = 0.75, duration = 5;
	var lfo = SinOsc.ar(XLine.kr(8, 0.1, duration), 0, 0.1, 0.5);
	var crackle = Crackle.ar(XLine.kr(1, 0.7, duration)) * 0.9;
	var blip = Blip.ar(10, XLine.ar(12, 10, duration), 0.75);
	var signal = crackle + blip;
	(signal * (lfo * amount)) + (signal * (1 - amount)) ! 2
}.play
)



// Dust triggered resonances
(
{
	var trig = Dust.ar(8);
	var freq = TRand.ar(800, 4000, trig);
	var sig = Ringz.ar(trig * 0.1, freq, 0.1);
	sig ! 2
}.play
)



// Crackle through comb
(
{
	var src = Crackle.ar(1.5, 0.1);
	var delay = LFNoise2.kr(0.1).range(0.01, 0.05);
	CombN.ar(src, 0.1, delay, 1) ! 2
}.play
)




///////////////////////// High Frequency Textures /////////////////////////


// High sine with envelope trigger
(
{
	var env = EnvGen.ar(
		Env.new([0, 1, 0.2, 0], [0.02, 0.02, 0.4]),
		Impulse.ar(8 * LFNoise1.ar(freq: 2, add: 1, mul: 0.9))
	);
	Pan2.ar(FSinOsc.ar(4000, mul: 0.1) * env, 0)
}.play
)



// Impulse through bandpass
(
{
	var src = Impulse.ar(LFNoise1.kr(0.5).range(4, 20));
	var freq = LFNoise0.kr(2).range(2000, 8000);
	BBandPass.ar(src * 0.3, freq, 0.1, 10) ! 2
}.play
)



///////////////////////// SynthDef Examples /////////////////////////


// Filtered saw with envelopes
(
SynthDef(\filtSaw, {|freq=100, cutoff=1000, res=0.3, amp=0.3, gate=1|
	var env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.8, 0.3), gate, doneAction: 2);
	var filtEnv = EnvGen.kr(Env.adsr(0.01, 0.3, 0.4, 0.2), gate);
	var sig = Mix(Saw.ar([freq, freq * 1.01]));
	sig = RLPF.ar(sig, cutoff * filtEnv.range(0.5, 1), res);
	Out.ar(0, sig * env * amp ! 2);
}).add;
)

x = Synth(\filtSaw, [\freq, 200]);
x.set(\cutoff, 3000);
x.set(\gate, 0);



// Additive with vibrato
(
SynthDef(\addVib, {|freq=220, amp=0.2, vibRate=5, vibDepth=5, gate=1|
	var env = EnvGen.kr(Env.asr(2, 1, 2), gate, doneAction: 2);
	var vibrato = SinOsc.kr(vibRate, mul: vibDepth);
	var sig = Mix(SinOsc.ar([freq, freq*2, freq*3] + vibrato, 0, [0.5, 0.3, 0.2]));
	Out.ar(0, sig * env * amp ! 2);
}).add;
)

x = Synth(\addVib, [\freq, 330]);
x.set(\vibDepth, 10);
x.set(\gate, 0);
