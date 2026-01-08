////////////////////////////////////////////////////////////////
//
//                 	   More Patterns
//
////////////////////////////////////////////////////////////////


////////////////////////// Synths //////////////////////////////

(

SynthDef(\sine,
    { arg out=0, freq=440, sus=0.1, rel=0.3;
        var env = EnvGen.kr(Env.perc(0.01, sus, rel), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env) ! 2)
    }).add;

SynthDef(\impulse,
    { arg out=0, freq=440, sus=0.05, rel=0.3;
        var env = EnvGen.kr(Env.perc(0.01, sus, rel), doneAction:2);
        Out.ar(out, Impulse.ar(freq, 0, env) ! 2)
    }).add;
)




//////////////////////// Patterns //////////////////////////////

( // Pbind to bind control patterns to synths

Pbind(
	\instrument, \sine,
	\dur, 0.1
).play

)

// Pseq for sequences
Pseq([Pwhite(0.1, 0.4, 4), Pwhite(1, 4, 8)], inf).asStream.nextN(100).plot


// Pwrand, weighted random
Pwrand([1, 2, 3], [0.1, 0.6, 0.3], inf).asStream.nextN(100).plot


// Ppar for paralell patterns
Ppar([Pbind(\midinote, 60), Pbind(\midinote, 70)]).play


// Penv for envelope shapes
Pbind(\dur, Penv([0.1, 1, 0.01], [8,4])).play


// Pstutter for repetition
Pbind(\degree, Pstutter(Pwhite(1, 3), Pwhite(1, 10))).play;


// Pbrown for brownian motion
Pbind(\degree, Pbrown()).play


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
