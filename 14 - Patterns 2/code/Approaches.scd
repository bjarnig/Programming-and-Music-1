////////////////////////////////////////////////////////////////
//
//                    Patterns, Approaches
//
////////////////////////////////////////////////////////////////

(

SynthDef(\sine,{ arg out=0, freq=440, atk=0.01, rel=0.15, amp=0.5;
    var env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction:2);
    Out.ar(out, SinOsc.ar(freq, 0, env) ! 2)
}).add;

)


///////////////////////// Markov Chains ///////////////////////////

Quarks.install("MathLib")

( // Probabilities are set for future states

m = MarkovSetN(
			  [ [[ 60 ], 	[ 61, 100 ], 	[ 0.9, 0.1 ]],
				[[ 61 ], 	[ 60 ], 		[ 1 ]],
				[[ 100 ], 	[ 101, 60 ], 	[ 0.9, 0.1 ]],
				[[ 101 ], 	[ 100 ], 		[ 1 ]]
			], 1);

m.makeSeeds;

p = Pbind(
	\instrument, \sine,
	\midinote, m,
	\dur, 1/8);

p.trace.play;

)


/* A state machine, Pfsm, possible initial states, then state and possible next states. */

(

var geom = Pgeom(50,1.1,4);

Pbind(
	\instrument, \sine,
	\midinote, Pfsm([ [0], 67, [0, 1], geom, [2,3], 73, [0, 2], 83, [0] ], inf),
	\dur, 0.1).trace.play
)



/////////////////////////// Tendency ///////////////////////////

Tendency (random between changing boundaries)

(
	Pbind(
	    \instrument, \sine,
	    \midinote, Pwhite(
		    Pseg(
			    Pseq([ 60, 80, 10, 100 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf)),
			Pseg(
			    Pseq([ 80, 100, 50, 120 ], inf),
				Pseq([ 5, 5, 5, 5 ], inf))
			),
	    \dur, 0.1
	).trace.play;
)



///////////////////////// Chords ///////////////////////////////

(
    Pbind(
	    \instrument, \sine,
	    \amp, 0.05,
	    \atk, 0.1,
	    \rel, 0.75,
	    \midinote, Pseq([[60, 64, 68], [53, 56, 59] ], inf),
	    \dur, Pseq([0.5, 0.25], inf)
	).play;
)

(
    Pbind(
	    \instrument, \sine,
	    \atk, 0.1,
	    \rel, 0.75,
	    \amp, 0.05,
		\midinote, Pwhite([60, 70], [40, 80], inf),
		\dur, Pwrand([0.5, 0.25], [0.6, 0.4], inf)
	).trace.play;
)


////////////////////////// Probablities ///////////////////////////


( // Poisson used to model the number of events occurring within a given time interval

    Pbind(
	    \dur, 0.1,
	    \amp, 0.2,
	    \instrument, \sine,
	    \midinote, Ppoisson(90, inf).trace
    ).play;
)


( // Pgauss uses a gaussian distribution from uniformly distributed values

    Pbind(
	    \dur, 0.1,
	    \amp, 0.2,
		\instrument, \sine,
	    \midinote, Pgauss(60, 12, inf).trace
    ).play;
)


( // Pcauchy a continuous distribution describing resonance behavior

    Pbind(
	    \dur, 0.1,
	    \amp, 0.2,
	    \instrument, \sine,
	    \midinote, Pcauchy(60, 12).max(10).min(100).trace
    ).play
)


( // Pexprand, exponential distribution, lower events occur more often

    Pbind(
	    \dur, 0.1,
	    \amp, 0.2,
	    \instrument, \sine,
	    \midinote, Pexprand(40, 80).trace
    ).play
)


( // Phprand, random values that tend toward hi

    Pbind(
	    \dur, 0.1,
	    \amp, 0.2,
	    \instrument, \sine,
	    \midinote, Phprand(40, 80).trace
    ).play
)


///////////////////////// Patterns ///////////////////////////////

//Series up
a = Pbind(\midinote, Pseries(48, 1, 48), \dur, 0.1)
a.play


// Series down
b = Pbind(\midinote, Pseries(96, -1, 48), \dur, 0.1)
b.play


// Combine up and down
c = Pseq([a,b])
c.play


// Create layers from up and down
d = Ptpar([0.0, a, 0.0, b, 0.5, a, 0.5, b, 1.0, a, 1.0, b])
d.play


// Nested pattern with randomness
e = Pbind(\midinote, Pseries(60, Pwhite(-5, 5, inf).trace, inf), \dur, 0.1)
e.play


// Play for a duration, rounded floating point numbers
f = Pfindur(10, Pbind(\midinote, Pwhite(60.001, 61.008).round(0.1), \dur, 0.1)).trace
f.play


// Create and play from a collection and add an offset.
a = [0,1,2,3,4,5,6] + 60
Pbind(\midinote, Prand(a + 7, inf), \dur, 0.1).play


// Generate a collection using a pattern.
b = Pseries(1, 1).asStream.nextN(64) + 60
Pbind(\midinote, Pseq(b), \dur, 0.05).play


// Choose from different collections
c = [50,52,54]; d = [60,62]; e = [70,71];
Pbind(\midinote, Pseq([Prand(c,4), Prand(d,2), Prand(e,10)], inf), \dur, 0.1).play
