////////////////////////////////////////////////////////////////
//
//                        Feedback
//
////////////////////////////////////////////////////////////////


s.boot; s.plotTree;

// SynthDefs

(
SynthDef(\src, { |out = 0, freq = 220, amp = 0.25|
	Out.ar(out, Saw.ar(freq * [1, 1.004], amp));
}).add;

// LocalIn/LocalOut — feedback within a single SynthDef
SynthDef(\fbLoop, { |out = 0, fb = 0.99, amp = 0.3|
	var sig = LocalIn.ar(1) + (Dust.ar(4) * 0.2);
	sig = LPF.ar(sig, 2000) * fb;
	LocalOut.ar(sig);
	Out.ar(out, sig * amp ! 2);
}).add;

// Karplus-Strong string via LocalIn feedback
SynthDef(\ks, { |out = 0, freq = 220, fb = 0.995, amp = 0.3|
	var burst = PinkNoise.ar * EnvGen.kr(Env.perc(0.001, 0.02));
	var sig = LocalIn.ar(1) + burst;
	sig = LPF.ar(DelayC.ar(sig, 0.05, freq.reciprocal), 3000);
	LocalOut.ar(sig * fb);
	Out.ar(out, sig * amp ! 2);
}).add;

// Modulated BPF in a feedback loop
SynthDef(\resoFb, { |out = 0, freq = 1000, del = 0.004, fb = 0.99, amp = 0.3|
	var sig = LocalIn.ar(1) + (Dust.ar(3) * 0.15);
	sig = BPF.ar(sig, SinOsc.kr(0.2).range(freq, freq * 2), 0.1, 2);
	sig = DelayC.ar(sig, 0.2, del);
	LocalOut.ar(sig * fb);
	Out.ar(out, sig * amp ! 2);
}).add;

// InFeedback — reads previous block, no order-of-execution requirement
SynthDef(\fbDelay, { |in, ret, out = 0, delay = 0.2, fb = 0.6|
	var dry = In.ar(in, 2);
	var fed = InFeedback.ar(ret, 2) * fb;
	var sig = DelayC.ar(dry + fed, 1.0, delay);
	Out.ar(out, sig);
	Out.ar(ret, sig);
}).add;

// Circular: A uses InFeedback to read B (which is after it in the tree)
SynthDef(\pingA, { |inFromB, outToB, out = 0|
	var sig = RLPF.ar(Dust.ar(2) * 0.2 + (InFeedback.ar(inFromB, 1) * 0.7), 600, 0.2);
	Out.ar(outToB, sig);
	Out.ar(out, sig ! 2 * 0.3);
}).add;

SynthDef(\pingB, { |inFromA, outToA|
	Out.ar(outToA, CombC.ar(In.ar(inFromA, 1), 0.3, 0.2, 3) * 0.8);
}).add;

// LagIn — smoothed control bus reading
SynthDef(\toneSmoothed, { |freqBus = 0, amp = 0.2, lag = 0.3|
	Out.ar(0, SinOsc.ar(LagIn.kr(freqBus, 1, lag), 0, amp) ! 2);
}).add;

SynthDef(\pair, { |bus = 0, amp = 0.2, lag = 0.4|
	var p = LagIn.kr(bus, 2, lag); // [freq, pan]
	Out.ar(0, Pan2.ar(Saw.ar(p[0], amp), p[1]));
}).add;
)


// 1. LocalIn / LocalOut
// Feedback inside one SynthDef. One-block delay (64 samples).
// Always decay (multiply by < 1.0) to prevent explosion.

x = Synth(\fbLoop);
x.set(\fb, 0.995);
x.set(\fb, 0.95);
x.free;

// Karplus-Strong plucked string
Synth(\ks, [\freq, 220]);
Synth(\ks, [\freq, 330]);
Synth(\ks, [\freq, 165, \fb, 0.999]);
s.freeAll;

// Evolving resonances
x = Synth(\resoFb, [\freq, 1200, \del, 0.003]);
x.set(\freq, 400);
x.set(\del, 0.01);
x.free;


// 2. InFeedback.ar
// In.ar needs the writer BEFORE it in the node tree.
// InFeedback.ar reads the previous block — works regardless of order.
// Cost: one-block latency (~1.3 ms at 48 kHz).

~srcBus = Bus.audio(s, 2);
~retBus = Bus.audio(s, 2);
(
~src = Synth(\src, [\out, ~srcBus, \freq, 110]);
~fx  = Synth.after(~src, \fbDelay,
	[\in, ~srcBus, \ret, ~retBus, \out, 0, \delay, 0.33, \fb, 0.65]);
)
~fx.set(\delay, 0.12);
~fx.set(\fb, 0.85);
s.freeAll;
~srcBus.free; ~retBus.free;

// Circular graph: A → B → A. First synth uses InFeedback for the return.
~ab = Bus.audio(s, 1);
~ba = Bus.audio(s, 1);
(
~a = Synth(\pingA, [\inFromB, ~ba, \outToB, ~ab, \out, 0]);
~b = Synth.after(~a, \pingB, [\inFromA, ~ab, \outToA, ~ba]);
)
s.freeAll;
~ab.free; ~ba.free;


// 3. LagIn.kr
// Reads a control bus with built-in lag — smooths abrupt .set jumps.

~freqBus = Bus.control(s, 1);
~freqBus.set(440);

~t = Synth(\toneSmoothed, [\freqBus, ~freqBus, \lag, 0.5]);
~freqBus.set(220);  // glides
~freqBus.set(880);
~freqBus.set(110);
~t.set(\lag, 2);    // slower glide
~freqBus.set(1320);
~t.free;
~freqBus.free;

// Multi-channel: read [freq, pan] from one bus
~ctrl = Bus.control(s, 2);
~ctrl.setn([220, 0]);
~p = Synth(\pair, [\bus, ~ctrl, \lag, 0.7]);
~ctrl.setn([440, -1]);
~ctrl.setn([110,  1]);
~ctrl.setn([660,  0]);
~p.free;
~ctrl.free;
