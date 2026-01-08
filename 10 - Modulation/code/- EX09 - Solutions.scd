////////////////////////////////////////////////////////////////
//
//                    Synthesis - Solutions
//
////////////////////////////////////////////////////////////////

// Exercise 1: Create a sound movement that starts with a sine wave and ends with a noise.

(
{
	var time = 10; // Duration in seconds
	var mix = Line.kr(0, 1, time);
	var sine = SinOsc.ar(220, 0, 0.3);
	var noise = WhiteNoise.ar(0.3);
	var sound = XFade2.ar(sine, noise, mix * 2 - 1); // CrossFade from sine to noise
	sound ! 2;
}.play
)



// Exercise 2: Create a cluster of sine waves (10 or more) going from low frequencies to high ones.

(
{
	var freqs = Array.series(15, 100, 100); // 15 sines from 100 Hz to 1500 Hz
	var sines = Mix(SinOsc.ar(freqs, 0, 0.05)); // Mix all sines, low amp each
	sines ! 2;
}.play
)

// Alternative with random spread
(
{
	var freqs = Array.series(20, 200, 150) + Array.rand(20, -10, 10);
	Mix(SinOsc.ar(freqs, 0, 0.04)) ! 2;
}.play
)



// Exercise 3: Create a slow sound movement lasting 30 seconds or more using at least 20 sine waves.

(
{
	var numSines = 20;
	var duration = 30;
	var sines = Mix.fill(numSines, {|i|
		var baseFreq = 50;
		var freq = baseFreq * (i + 1) * exprand(0.95, 1.05);
		var amp = LFNoise2.kr(rrand(0.05, 0.2)).range(0, 0.02);
		var pan = LFNoise2.kr(rrand(0.1, 0.3)).range(-1, 1);
		Pan2.ar(SinOsc.ar(freq), pan, amp);
	});
	sines;
}.play
)



// Exercise 4: Combine different moments of noise types where they can be perceived
// at the same time during some moments but also separate in others.

(
{
	var white = WhiteNoise.ar(0.2);
	var pink = PinkNoise.ar(0.2);
	var brown = BrownNoise.ar(0.2);

	// Use slow LFOs to control individual amplitudes
	var whiteAmp = LFNoise2.kr(0.2).range(0, 1);
	var pinkAmp = LFNoise2.kr(0.15).range(0, 1);
	var brownAmp = LFNoise2.kr(0.25).range(0, 1);

	// Pan them differently
	var whiteSig = Pan2.ar(white * whiteAmp, -0.7);
	var pinkSig = Pan2.ar(pink * pinkAmp, 0);
	var brownSig = Pan2.ar(brown * brownAmp, 0.7);

	whiteSig + pinkSig + brownSig;
}.play
)



// Exercise 5: Add at least two filtered Saw waves together and use a sine wave
// to control the balance between the two.

(
{
	var saw1 = RLPF.ar(Saw.ar(100, 0.3), 800, 0.3);
	var saw2 = RLPF.ar(Saw.ar(150, 0.3), 1200, 0.3);

	var balance = SinOsc.kr(0.5); // Oscillates between -1 and 1
	var mixed = XFade2.ar(saw1, saw2, balance);

	mixed ! 2;
}.play
)

// Alternative: using sine to control amplitude directly
(
{
	var saw1 = RLPF.ar(Saw.ar(110, 0.5), 600, 0.4);
	var saw2 = RLPF.ar(Saw.ar(220, 0.5), 1500, 0.3);

	var balance = SinOsc.kr(0.3).range(0, 1); // 0 to 1
	var mixed = (saw1 * (1 - balance)) + (saw2 * balance);

	mixed ! 2;
}.play
)

