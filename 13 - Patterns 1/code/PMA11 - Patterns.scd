////////////////////////////////////////////////////////////////
//
//                 	    PMA12 - Patterns
//
////////////////////////////////////////////////////////////////


////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\saws, {|out=0, freq=100, atk=0.5, rel=1.0, lop=500, res=0.5, amp=1.0, gate=1|
	var sig, env, filter;
	sig = Saw.ar([freq, freq*0.5], 0.2) * amp;
	env = EnvGen.ar(Env.asr(atk,1,rel), gate, doneAction:2);
	filter = BLowPass4.ar(sig, lop, res);
	Out.ar(out, filter * env);
}).add;

SynthDef(\pluck, {
	|amp=0.1, freq=200, decay=4, coef=0.1, pan=0|
	var env, sig, pluck, delay;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction:2);
	sig = WhiteNoise.ar(amp);
	delay = freq.reciprocal;
	sig = Pluck.ar(in:sig, delaytime:delay, decaytime:decay, coef:coef);
	Out.ar(0, Pan2.ar(sig * 0.5, pan));
}).add;

)

Synth(\pluck, [\note, 80, \decay, 10])

x = Synth(\saws, [\rel, 4, \lop, 1000, \freq, 50])
x.set(\gate, 0)


////////////////////////// Patterns ///////////////////////////


// Pseq for pitches and constant numbers for dur and amp
(
Pbind(
	    \instrument, \saws,
	    \freq, Pseq([200, 400, 600], inf),
		\dur, 0.5,
		\amp, 1.0
	).play
)

// Pseq for pitches and constant numbers for dur and amp
(
Pbind(
	    \instrument, \saws,
	    \midinote, Pseq([50,55,60], inf),
		\lop, Pseq([400,1000,600], inf),
	    \dur, Pseq([0.1,0.2,0.3], inf),
		\amp, Pseq([1,0.1], inf),
	).play
)


// Pwhite for pitches and filter
(
Pbind(
	    \instrument, \saws,
		\midinote, Pwhite(24, 72, 16),
	    \lop, Pwhite(100, 2000, 8),
		\dur, 0.2,
		\amp, 1.0
	).play
)


// Pwhite for duration, amplitude and filter
(
Pbind(\instrument, \saws,
		\lop, Pwhite(100, 8000),
		\dur, Pwhite(0.1, 0.2),
		\amp, Pwhite(0.0, 1.0),
	).play
)


// Pwhite for pitch and pbrown for release
(
Pbind(\instrument, \saws,
	    \midinote, Pwhite(60, 80),
	    \rel, Pbrown(0.01, 0.75, 0.05).trace,
		\dur, 0.1,
		\amp, 0.5
	).play
)


// Pwhite for note and duration
(
Pbind(\instrument, \pluck,
	    \note, Pwhite(80, 100, inf),
		\dur, Pwhite(0.05, 0.06, inf),
	    \rel, 0.2,
		\amp, 1.0
	).play
)


// Simple series for pitch
(
Pbind(\instrument, \pluck,
		\midinote, Pseries(48, 0.25, 32),
		\dur, 0.2,
		\amp, 0.2,
	).play
)


// Series for all parameters
(
Pbind(\instrument, \pluck,
		\midinote, Pseries(Pwhite(20, 40), -2),
	    \dur, Pseries(0.1, 0.01),
		\amp, Pseries(0.5, 0.01),
	).play
)


// Geom for multiplied growth
(
Pbind(\instrument, \pluck,
		\midinote, Pgeom(80, 1.01, 32),
		\dur, Pgeom(0.1, 1.1, 32),
		\amp, Pgeom(0.5, 1.001, 32),
	).play
)


// Series up and series down, with variables
(
var base, dur, step, times;
x = 2;
base = 60;
dur = 0.2;
step = x;
times = 16;

Pbind(\instrument, \pluck,
	    \midinote, Pseq([Pseries(base,x,times), Pseries(base,x.neg,times)], inf),
		\dur, dur,
		\amp, 0.5,
	).play
)


// pluck and saws at the same time
(
var noteFrom=50, noteTo=72, steps=12, growth=1.1, durations;

durations = Array.geom(steps, 0.1, growth);
durations = durations ++ durations.reverse;

~pluck = Pbind(
	\instrument, \pluck,
	\midinote, Pwhite(noteFrom, noteTo),
	\amp, 0.1,
	\dur, Pseq(durations, inf)
);

~pulse = Pbind(
	\instrument, \saws,
	\midinote, Pwhite(noteFrom, noteTo),
	\dur, Pseq(durations, inf)
);

Ppar([ ~pluck, ~pulse ]).play;

)

( // scheduling with patterns

c = \saws;

a = Pbind(
	\instrument, c,
	\amp, Pwhite(0.4, 0.7),
	\freq, Pbrown(100, 200, 100),
	\legato, 0.9,
	\rel, 0.1,
	\dur, Pseq([1, 0.5, Pbrown(0.05, 0.2, 0.01, 4)])
);

b = Pbind(
	\instrument, c,
	\amp, Pwhite(0.2, 0.6),
	\freq, Pbrown(1000, 2000, 100),
	\legato, 0.9,
	\rel, 0.8,
	\dur, Pseq([1, 0.5, Pbrown(0.05, 0.2, 0.01, 4)])
);

Pseq([Ppar([a, b]), b]).play

)


// scheduling with patterns, randomness in duration
Pbind(\dur, Pwhite(0.05, 0.2)).play


( // pitches and durations from a list

~pitches = [60,64,67,69];
~durations = [1, 0.1, 2, 0.2];

Pbind(
	\dur, Pseq(~durations, inf),
	\midinote, Pseq(~pitches, 2)
).play()

)

( // nested patterns

Pbind(
	\midinote, Pseq([Pwhite(40, 50, 5), Pwhite(80, 90, 5), 60], inf),
	\dur, Pseq([Pbrown(0.0, 1.0, 0.1, 10), Pwhite(0.1, 0.5, 10)], inf),
).trace.play

)

// patterns can be plotted

Pwhite(0.0, 1.0, 100).asStream.all.plot;

Pseries(0, 0.01, 100).asStream.all.plot;

Pwhite(Pseries(0, 0.01, 100), 1.0, 100).asStream.all.plot;

