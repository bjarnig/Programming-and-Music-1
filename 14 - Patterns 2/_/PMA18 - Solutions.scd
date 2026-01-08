////////////////////////////////////////////////////////////////
//
//            PMA18 - Solutions from Exercises
//
////////////////////////////////////////////////////////////////

(

SynthDef(\snd, { arg freq=100, gate=1, out=0, lop=2000, atk=0.1, rel=0.5, amp=0.5;
	var env = EnvGen.kr(Env.asr(atk, amp, rel), gate);
	var signal = RLPF.ar(Blip.ar(freq, 150).fold2(SinOsc.ar(freq/10)), lop);
    Out.ar(out, Pan2.ar(signal * env));
}).add;

)

/* 1. Choose three pitches and create an array with these, octave down and octave up version of them. Finally implement a pbind where an envelope is used to read from the array. */

(

var pitches = [120,340,650];
var material = (pitches * 0.5) ++ pitches ++ (pitches * 2);

Pbind(
	\instrument, \snd,
	\index, Pn(Penv([0.1,0.5,0.8,0.2,0.9], [1.5,0.5,2.5,3.5])), // create the index on a unique line
	\freq, Pfunc{|ev| material[ev.index * material.size]},
	\amp, 0.3,
	\dur, 0.2
).trace.play

)


/* 2. Implement a pbind that uses a tendency mask for amplitudes and beta distribution for the pitches. */

(

var pitches = [120,340,650];
var material = (pitches * 0.5) ++ pitches ++ (pitches * 2);

Pbind(
	\instrument, \snd,
	\hi, Pn(Penv([0.2,0.8,0.7],[1,2,3])),
	\lo, Pn(Penv([0.1,0.7,0.2],[1,2,3])),
	\amp, Pfunc{|ev| rrand(ev.lo, ev.hi)} * 0.5,
	\freq, Pbeta(200,800,0.5,0.5),
	\dur, Pbrown(0.1,0.2,0.01)
).trace.play

)

)


/* 3. Implement a pbind where a single random number is used to determine pitch, amplitude and duration. */

(

var pitches = [120,340,650];
var material = (pitches * 0.5) ++ pitches ++ (pitches * 2);

Pbind(
	\instrument, \snd,
	\number, Pwhite(0.0,1.0),
	\rel, 0.75, \at, 0.1,
	\freq, Pfunc{|ev| ev.number.linexp(0.0,1.0,200,300)},
	\amp, Pfunc{|ev| ev.number.linexp(0.0,1.0,0.0001,0.5)},
	\dur, Pfunc{|ev| ev.number.linexp(0.0,1.0,0.01,0.15)},
).trace.play

)

)

/* 4. Implement a pbind where a list of four random numbers is repeated four times before generating them and repeating again. */

(

var pitches = [120,340,650];
var material = (pitches * 0.5) ++ pitches ++ (pitches * 2);

Pbind(
	\instrument, \snd,
	\freq, Pn(Plazy{ Pseq( Array.rand(4,1000,1300), 4) },inf),
	\amp, 0.2,
	\dur, 0.1
).trace.play

)


/* 5. Create a layeres pbind process where the number of layers is chosen randomly at the start. */

(

var layers = rrand(2,8);
Ppar( layers.collect {|i| var n = i + 1; Pbind(\instrument, \snd, \amp, 0.1, \dur, 1/n, \freq, Pwhite(100 * n, 500*n)).play }, inf).play

)