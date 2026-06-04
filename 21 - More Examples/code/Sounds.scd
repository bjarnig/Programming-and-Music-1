////////////////////////////////////////////////////////////////
//
//                     Sounds
//
////////////////////////////////////////////////////////////////


( // Use Demand rate for modulation

{
	var trig, seq, freq;
	trig = Impulse.kr(10);
	seq = Dseq([2,4,8], inf).midicps;
    freq = Demand.kr(trig, 0, seq);
	SinOsc.ar(LFCub.kr([freq, freq/2], 0, 50, 200))
}.play

)


( // Non Standard Synthesis

{
	var sd = SampleDur.ir * 0.15;
	var size = 5, from = 1, to = 25;
	var modFreq = 1, modFrom = 5, modTo = 25;

	DemandEnvGen.ar(
		Dseq([1, [-1, 0.5]], inf),
		Dseq(Array.rand(size,from,to), inf) * sd
	).mod(SinOsc.ar(LFNoise0.ar(modFreq).range(modFrom, modTo)));
}.play;

)


( // Soft sine bass feedback

{
	DFM1.ar(SinOsc.ar([60,70],0,0.1),1600,SinOsc.kr(0.1).range(0.92,0.99),1,0,0.001, 1.5)
}.play;

)


( // Saw multiplied with envelopes

{
	RLPF.ar(Saw.ar([75,50,60,80]), 600) * EnvGen.ar(Env.perc(0.1, 0.15), Dust.ar(1)) ! 2;
}.play

)


( // Crossfading modulation (dry/wet)

{
	var signal = Saw.ar(LFNoise2.ar(10).range(20,60));
	var mod = SinOsc.ar(8 ! 2,0,0.5,0.5);
	XFade2.ar(signal, signal * mod, LFNoise2.ar(0.2).range(-1,1)) * 0.5;
}.play

)


( // Boomy FM

{
Splay.ar(16.collect({ PMOsc.ar(LFTri.ar(0.001, 0, 80, 100), rrand(10, 1000), rrand(0.2, 2.3)) * 0.15 })) *
EnvGen.ar(Env.perc(0.1, 0.15), Dust.ar(10)) ;
}.play;

)



( // Allpass network

{
    var z = Decay.ar(Dust.ar([1,0.5]), 0.1, WhiteNoise.ar) * 2;
	    8.do { z =
		LPF.ar(AllpassL.ar(z, 0.02, LFNoise1.ar(0.1).range(0.001, 0.002), LFNoise1.ar(1).range(2, 20)), 8000) };
    z
}.play

)

