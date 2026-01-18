////////////////////////////////////////////////////////////////
//
//                    Patterns Examples
//
////////////////////////////////////////////////////////////////

This document covers simple synths, noises, playing samples
and sequencing with patterns.


( // Install the SafetyNet Quark (be careful with sound volumes!)

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)



////////////////////////// SynthDefs ///////////////////////////

(

SynthDef(\fm, {
	|out=0,pan=0,note=60,amp=1.0,mod=1000,amt=0.5,atk=0.1,sus=0.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = PMOsc.ar(note.midicps, mod, amt);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

SynthDef(\noise, {
	|out=0,pan=0,note=60,amp=1.0,res=0.5,atk=0.1,sus=0.1,rel=0.1|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, note.midicps, res);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

SynthDef(\saw, {
	|out=0,pan=0,note=40,amp=1.0,res=0.5,atk=0.1,sus=0.1,rel=0.1,lop=8000|
	var sig, env;
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);
	sig = BLowPass4.ar(Saw.ar(note.midicps), lop);
	Out.ar(out, Pan2.ar(sig, pan, amp) * env);
}).add;

)

////////////////////////// Patterns ///////////////////////////

/* Patterns with midi output.  */

MIDIClient.init;

(

var midiout = MIDIOut.newByName("IAC Driver", "BG.Virtual");

Pbind(
	\midinote, Pbrown(30, 60, 4),
	\dur, 1/2,
	\amp, 0.5,
	\midiout, midiout,
	\type, \midi
).trace.play

)




/* Use envelope shapes for pitches (here a sine shape) and fm
modulation (here a generated shape) */

(

var sine, pitch, shape, mod;

sine = Env.sine;
pitch = Pn(Penv(sine.levels.linlin(0,1,40,80), sine.times * 2));

shape = Env(Array.rand(10, 0.0, 10.0), Array.rand(9, 0.0, 2.0));
mod = Pn(Penv(shape.levels, shape.times));

sine.plot;
shape.plot;

Pbind(
	\instrument,\fm,
	\note, pitch,
	\amt, mod,
	\dur, 0.1
).play

)




/* Use a shape to read from previously created collection. */

(

var shape, coll;

shape = Env([0,0.5,0.8,0.2,1.0], 2.5 ! 4);
shape.plot;
coll = Array.series(24, 48, 0.5);

Pbind(
	\instrument, \fm,
	\env, Pn(Penv(shape.levels, shape.times)),
	\mod, 1500,
	\dur, 0.3,
	\atk, 0.5,
	\note, Pfunc{|event| coll[(coll.size - 1) * event.env] }
	).play
)




/* Tendancy mask reads from a collection, shuffled durations and clock at 90 bpm */

(

var low, hi, clock, coll;

clock = TempoClock(90/60);

hi = Env([0.26, 0.51, 0.9], [0.5, 0.5]);
low = Env([0.25, 0.49, 0.01]);
coll = Array.series(16, 40, 2);

Pbind(
	\instrument, \saw,
	\th, Pn(Penv(hi.levels, hi.times * 2)),
	\tl, Pn(Penv(low.levels, low.times * 2)),
	\note, Pfunc{|ev| coll[((coll.size-1) * rrand(ev.tl, ev.th))]}.trace,
	\dur, Pn(Pshuf([0.125,0.25,0.5], 2))
).play(clock);

)




/* Group repeats of incoming values, controls rate of change */

(

var groupSize = 4, repeats = 2;

var seq = { Pshuf(Pwhite(30,50).asStream.nextN(groupSize), repeats) };
var seq2 = { Pshuf(Pwhite(20,80).asStream.nextN(groupSize/2), repeats) };

Pbind(
	\instrument, \saw,
	\note, Pseq([Pn(Plazy(seq), 2), Pn(Plazy(seq2), 4)], inf).trace,
	\lop, Pbrown(800, 1500, 50),
	\dur, 0.2
).play

)




/* Checking already decided properties of the Event and use Pswitch for selecting generators */

(

var wa, wb, stutter;

wa = Pwhite(48,60);
wb = Pwhite(70,80);
stutter = Pstutter(Pseq([2,3],inf), Pseq([0,1],inf));

Pbind(
	\instrument, \noise,
	\note, Pswitch1([wa, wb], stutter),
	\rel, Pfunc({ arg event;
			event.postln;
			if(event.note < 60, {
				rrand(1.0, 2.0);
			}, 0.5);
		}),
	\dur, 0.2
).play

)




/* Change patterns on the fly using EventPatternProxy */

(

a = PatternProxy(Pwhite(80,88));
a.quant = 1/16;

Pbind(
	\instrument, \noise,
	\note, a,
	\dur, 0.2
).play;

)

a.source = Pseq([50,60,70,80], inf);
a.source = Pbrown(50,90);




/* Sequencing three (or more) properties at a time */

(

Pbind(
	\instrument, \saw,
	[\note, \lop, \dur],
	Pseq([
		[32, 8000, 1/8],
		[72, 800, 1/16],
		Pfuncn({ [rrand(50,55),rrand(400,600),rrand(1/32,1/4)]},1)
	], inf)
).play

)




/* Upper limit of an exponential distribution changes */

(

Pbind(
	\instrument, \saw,
	\dur, Pexprand(0.1, Env([0.1, 0.2, 0.15], [5,5], Env([0.1,0.8, 0.15], [5,5], [2,8]))),
	\note, Pexprand(10, Env([30, 40, 80], [5,5], Env([0.1,0.8, 0.15], [5,5], [2,8])))
).trace.play

)




/* One value from each sub-pattern and return as array (chord) using Ptuple. Pser for durations
where we specify the number of items (otherwise like Pseq.)  */

(

Pbind(
	\instrument, \fm,
	\note, Ptuple([Pwhite(50,60,inf), Pwhite(70,80,inf)]).trace,
	\amt, Pwhite(1.0, 10.0),
	\dur, Pser([1/8, 1/10], 24)
	).play
)




/* A state machine, Pfsm, possible initial states, then state and possible next states.*/

(

var geom = Pgeom(50,1.1,4);

Pbind(\instrument, \noise,
	\note, Pfsm([[0,1], 67, [0, 0, 1], geom, [2,3], 73, [0, 2], 83, [0]], inf),
	\dur, 0.1).trace.play
)




/* A simulation of Brownian motion with a fixed start value. */

(

Pbind(
	\instrument, \fm,
	\note , Pseries(60, Pwhite(-2, 2, inf), inf).fold(50, 70).trace,
	\dur, Prand([1/16, 1/8, 1/10], inf)
).play(TempoClock(150/60))

)




/* Pspawner for fine grained control of sub-patterns */

(

Pspawner({|sp|

	"STEP 1".postln;
	sp.par(Pbind(\midinote, 60, \dur, Pwhite(0.1,0.2, 8)));
	"STEP 2".postln;
	sp.wait(2);
	"STEP 3".postln;
	sp.seq(Pbind(\midinote, 20, \dur, Pwhite(0.1,0.2, 8)));
	"STEP 4".postln;
	sp.seq(Pbind(\midinote, 80, \dur, Pwhite(0.2,0.1, 8)));
	"STEP 5".postln;

}).play;

)


/* Pmono plays one instance of a synth while changing args */

(

SynthDef(\gray, {|freq=200, amp=0.2|
	var env, sig;
	env = EnvGen.ar(Env.new([0,1,0],[10,10]), doneAction:2);
	sig = BPF.ar(GrayNoise.ar(amp), freq);
	Out.ar(0, sig * env ! 2)
}).add

)

(

	Pmono(\gray,
		\dur, Penv([0.01,0.5,0.1],[10,10]),
		\freq, Pwhite(100, 8000,inf)
	).play

)


// Collection operations, select, collect or reject.
Pbind(\instrument, \sine, \freq , Pwhite(100,900).select({|x| x < 800}), \dur, 0.1).play

// Pclutch, sample and hold a pattern, second pattern boolean indicates if one should sample again.
Pbind(\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)), \dur, 0.1).play

// Pn, simple repetition
Pbind(\freq, Pn(Pseq([500,600,700]), 10), \dur, 0.1).play

// Pstutter, repeat values
Pbind(\freq, Pstutter(10, Pseq([500,600,700], inf)), \dur, 0.1).play

// Pconst, limit the sum of items, (here we stop after a total of 5k freqs)
Pbind(\freq, Pconst(5000, Pseq([500,600,700], inf)), \dur, 0.1).play

// Psync, limit total dur, like Pfindur but waits until clock sync, here one beat
Psync(Pbind(\freq, Pseq([500,600,700], inf), \dur, 0.03), 1, 1).play

// Ptime, the time amount since starting, used here with an if to stop
Pbind(\degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play;

// Pstep repeat input value for an amount of time
Pbind(\instrument, \sine, \freq, Pstep(Pwhite(200,400), 4, inf), \dur, 0.05).play;

// Pseq similar to step but interpolates between values
Pbind( \instrument, \sine, \freq, Pseg(Pwhite(100,500),Pseq([1,5],inf),\linear),\dur, 0.1).play;

// Use env simply within patterns
Pbind(\instrument, \sine, \freq,Env([100,1000], [5]),\dur,Env([0.05,0.01,0.1], [5,10])).play;

// Wrap envelopes inside Pn to loop
Pbind(\instrument, \sine, \freq, Pn(Pif(Ptime(inf) < 2, Env([100,200],[1])),inf), \dur,0.08).play

// Pbindef to bind value patterns to one event stream
a = Pbind(\instrument, \sine, \dur, 0.1); Pbindf(a, \freq, 800).play

// Pchain, chains pbinds together
a = Pbind(\instrument, \sine); b = Pbind(\dur, 0.1, \freq, 150); Pchain(a,b).play

