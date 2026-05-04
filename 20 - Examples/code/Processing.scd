////////////////////////////////////////////////////////////////
//
//                       Processing
//
////////////////////////////////////////////////////////////////


(   // Load Samples for analysing variations

    ~path = thisProcess.nowExecutingPath.dirname;
    ~files = SoundFile.collect(~path ++ "/sounds/*");
    ~buffers = ~files.collect { |sf| var b;
    b = Buffer.read(Server.local, sf.path)};

    // Set the default server
    s = Server.default;

    // Add a test sampler
    SynthDef(\testSampler, {|out=0, buf=0|
	    var signal;
	    signal = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop:1, doneAction:2);
	    Out.ar(out, signal ! 2);
    }).add;
)

(

// Create a function that will add an effect and then play a sample
~testEffect = {|effect, args|
	var bus, effectArgs;

	Routine({

		// Add the synthedef and call sync to wait until its done
		effect.add;
		s.sync;

		// Allocate a bus, play the effect and finally the sampler
		bus = Bus.audio(Server.local, 2);
		effectArgs = [\in, bus, \out, 0].addAll(args);
		"args".postln;
		args.postln;
		effectArgs.postln;
		Synth(effect.name, effectArgs);
		Synth(\testSampler, [\out, bus, \buf, ~buffers[0]]);

	}).play
};

)



//////////////////////// Processing /////////////////////////

(

/* 1. Dual distortion, use heavy amplification before clipping
and seperate hi and lo frequencies */

~testEffect.value(

	SynthDef(\dualDistortion,
	{| in=0, out=0, lpf=200, hpf=6000, gaina=1000, gainb=200|
	var sig = In.ar(in, 2);
	sig = HPF.ar(SoftClipAmp8.ar(sig, pregain:gaina) * 0.2, hpf) +
	LPF.ar(SoftClipAmp8.ar(sig, pregain:gainb) * 0.2, lpf);
	Out.ar(out, sig) }));
)




(

/* 2. Binary distortion, experiment with binary operators and
the unusal UGen LeastChange */

~testEffect.value(

	SynthDef(\binaryOpDistortion,
	{| in=0, out=0, modFreq=15|
	var amp, sig = In.ar(in, 2);
	sig = LeastChange.ar(sig, SinOsc.ar(modFreq));
	sig = sig.thresh(Crackle.ar(0.8));
	sig = sig.scaleneg(LFSaw.ar(10 * SinOsc.kr(modFreq/100, 0.5, 0.5)));
	Out.ar(out, sig * 0.3) }));
)



(

/* 3. Pitch shift using a real-time granular method combined with
the use of comb delay in order to give tail to the sound */

~testEffect.value(

	SynthDef(\combShift,
	{| in=0, out=0, rate1=0.25, grSize=0.1, rate2=4, dispersion=0.5|
	var sig, effect, shift1, shift2, times=10, delay=0.07, decay=1.5;
	sig = In.ar(in, 2);
	shift1 = PitchShift.ar(sig, grSize, rate1, dispersion, dispersion);
	shift2 = PitchShift.ar(sig, grSize, rate2, dispersion, dispersion);
	effect = shift1 + shift2;
	effect = Mix.fill(times, {
	CombC.ar(effect.tanh, delay, rrand(delay/1, delay), decay) * 1/times});
	Out.ar(out, effect) }));
)



(

/* 4. Feedback, needs the Feedback quark. Run: Quarks.install("Feedback");
The sound is fed back to the synth through a filter with slight distortion
*/

~testEffect.value(

	SynthDef(\filterFeedback,
	{| in=0, out=0, feedback=0.98, delay=0.1|
	var sig, effect;
	sig = In.ar(in, 2);
	effect = Fb({|fbSig|
	BPF.ar(fbSig * feedback + sig, 100, 4).round(0.01);
			}, EnvGen.ar(Env([1.8, 0.1], [20], [-5]).circle), delay);
	Out.ar(out, Limiter.ar(effect))}));
)



(

/* 5. Feedback using LocalIn and LocalOut and by transforming the sound using the
FreqShift UGen  */

~testEffect.value(

	SynthDef(\freqShift,
	{| in=0, out=0, feedback=0.4, delay=0.2, shiftFreq=2000, shiftDens=0.1|
	var sig, effect;
	sig = In.ar(in, 2);
	effect = sig + LocalIn.ar(2);
	effect = FreqShift.ar(effect, LFNoise2.ar(shiftDens, shiftFreq));
			effect = DelayC.ar(effect, delay, SinOsc.ar(1).range(0.1,0.2));
	LocalOut.ar(effect * feedback);
	Out.ar(out, effect)}));
)



(

/* 6. Simple Cross-synthesis by modulating oscillator amplitude using
the incoming sound as the source of control. Fed into a comb network. */

~testEffect.value(

	SynthDef(\crossPulse,
	{| in=0, out=0, freq=500|
	var sig, osc, verb, thres;
	sig = In.ar(in, 2);
	thres = Lag.kr(Amplitude.kr(sig), 0.1);
	osc = Splay.ar(Pulse.ar(Array.series(10, freq, 5))) * thres;
	verb = Mix.ar(Array.fill(10,{ CombL.ar(osc, 0.05, rrand(0.02, 0.04), 10.rand) }));
	Out.ar(out, osc + (verb * 0.5))}));
)


(

/* 7. Pitch tracking cross-synthesis with slight delay for stereo effect */

~testEffect.value(

	SynthDef(\test,
	{| in=0, out=0|
	var sig, effect, amp, freq, hasFreq;
	sig = In.ar(in, 1) * 2;
	amp = Amplitude.kr(sig, 0.05, 0.05);
    #freq, hasFreq = Tartini.kr(sig, 0.93, 1024, 512, 512);
    effect = Mix.new(VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp));
    6.do({ effect = AllpassN.ar(effect, 0.040, [0.040.rand,0.040.rand], 2) });
	effect = [DelayC.ar(effect, 0.01, 0.01);
		   , DelayC.ar(effect, 0.08, 0.08)];
	Out.ar(out, effect)}));

)



/* 8. Granulated input with Convolution reverb */

~pulsePath = thisProcess.nowExecutingPath.dirname ++ "/sounds/impulses/impulse.aif";
~irbuffer= Buffer.read(Server.default, ~pulsePath);
~fftsize = 2048;
~bufsize= PartConv.calcBufSize(~fftsize, ~irbuffer);
~irspectrum= Buffer.alloc(Server.default, ~bufsize, 1);
~irspectrum.preparePartConv(~irbuffer, ~fftsize);

(

~testEffect.value(

	SynthDef(\grainConv,
	{| in=0, out=0, fftsize=2048, specBufNum=8|
	var sig, verb;
	sig = GrainIn.ar(2, Dust.kr(120), 0.01, In.ar(in, 2));
	verb = PartConv.ar(sig, fftsize, specBufNum) * 0.1;
	Out.ar(out, (sig * 0.6) +  (verb * 0.4))}), [\specBufNum, ~irspectrum.bufnum]);

)


/* 9. Custom waveshaping with envelope followed reverb. */

x = Signal.sineFill(512, Array.rand(128, -1.0, 1.0).normalizeSum);
b = Buffer.alloc(s, 1024, 1);
b.sendCollection(x.asWavetableNoWrap);

(

~testEffect.value(

	SynthDef(\revShaper,
	{| in=0, out=0, sinFreq=0.1, buffer=0, player, index, mod, analyse|
	var sig, verb;
	sig = In.ar(in, 1) * 4 ;

	// Modulating the end position with a sine wave
	mod = BufFrames.kr(buffer) * SinOsc.ar(sinFreq, 0, 0.5, 0.5)  ;

	// A reading index modulated by the incoming sound and end pos
	index = LinLin.ar(sig, -1.0, 1.0, 0.0, mod);

	// Read the buffer with the index
	player = BufRd.ar(1, buffer, index);

	// Follow the amplitude of the sound
	analyse = Amplitude.ar(sig, 0.1, 0.1, 2).range(0.2, 0.8);

	// Use the analysis to control a reverb
	player = FreeVerb.ar(player, analyse, analyse, 0.2);

	Out.ar(out, player ! 2)}), [\buffer, b.bufnum]);
)



/* 10. Buffer 3, Freeze a feedback sound using demand rate to sequence the freezing */

b = Buffer.alloc(s,2048);

(

~testEffect.value(

	SynthDef(\frozen,
	{| in=0, out=0, feedback=0.95, delay=0.1, bufnum=9, analyzeAmp=8|
	var sig, effect, thres, trig;
	sig = In.ar(in, 2);
    sig = Fb({|fbSig|
	BPF.ar(fbSig * feedback + sig, LFNoise1.kr(1, 200, 2000), 4).tanh;
	}, 0.2);
	effect = FFT(bufnum, sig);
	thres = Duty.ar(Dwhite(0.01, 0.1,inf), 0, Dwhite(0.4, 0.6,inf));
	effect = PV_Freeze(effect, thres > 0.5 );
	Out.ar(out, IFFT(effect).dup)}), [\bufnum, b.bufnum] );
)
