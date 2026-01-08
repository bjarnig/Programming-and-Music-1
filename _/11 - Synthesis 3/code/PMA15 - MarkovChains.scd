////////////////////////////////////////////////////////////////
//
//                     Markov Chains
//
////////////////////////////////////////////////////////////////


Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)

// SynthDefs used

(

SynthDef(\sine,
    { arg out=0, freq=440, sus=0.05, amp=0.5;
        var env = EnvGen.kr(Env.perc(0.01, sus, amp), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env) ! 2)
    }).add;

)

////////////////////////// Markov Chains ///////////////////////////

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
