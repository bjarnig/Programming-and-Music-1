////////////////////////////////////////////////////////////////
//
//                       Tendency Masks
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

(

SynthDef(\snd, { arg freq=500, gate=1, out=0, lop=8000, amp=0.1, pan=0, atk=0.01, rel=0.25;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate, doneAction:2);
	var signal = RLPF.ar(Saw.ar(freq, 0.25).fold2(SinOsc.ar(freq/2)), lop);
	OffsetOut.ar(out, Pan2.ar(signal * env, pan));
}).add;

)


/////////////////////////// Tendency ///////////////////////////

Tendency (random between changing boundaries)

(
	Pbind(
	    \instrument, \snd,
	    \midinote, Pwhite(
		    Pseg(
			    Pseq([ 60, 80, 10, 100 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf)),
			Pseg(
			    Pseq([ 80, 100, 50, 120 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf))
			),
	    \dur, 0.1
	).play;
)



(
	Pbind(
	    \instrument, \snd,
	    \freq, Pseq([ Pn(Pgeom(60,2,4),4), Pn(Pgeom(40,2.5,4),2)],inf),
	    \dur, Pn(Pwhite(
		    Penv([0.01,0.1,0.2],[3,4]),
		    Penv([0.1,0.2,0.4],[3,4])
	    )).trace
	).play;
)


/////////////////////// Selections /////////////////////////////

/* Use a shape to read from previously created collection. */

(

var shape, coll;

shape = Env([0,0.5,0.8,0.2,1.0], 2.5 ! 4);
shape.plot;
coll = Array.series(24, 48, 0.05);

Pbind(
	\instrument, \snd,
	\env, Pn(Penv(shape.levels, shape.times)),
	\midinote, Pfunc{|ev| ev.postln; coll[(coll.size-1) * ev.env]},
	\dur, 0.1,
	\atk, 0.1
	).play

)

/* Tendancy mask reads from a collection, shuffled durations and clock at 90 bpm */

(

var low, hi, coll;

hi = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
low = Env([0.25, 0.49, 0.01], [0.5, 0.5]);
coll = Array.series(16, 40, 2);

Pbind(
	\instrument, \snd,
	\th, Pn(Penv(hi.levels, hi.times * 2)),
	\tl, Pn(Penv(low.levels, low.times * 2)),
	\midinote, Pfunc{|ev| coll[((coll.size-1) * rrand(ev.tl, ev.th))]}.trace,
	\dur, Pn(Pshuf([1/16, 1/8, 1/32]))
).play(TempoClock(90/60));

)
