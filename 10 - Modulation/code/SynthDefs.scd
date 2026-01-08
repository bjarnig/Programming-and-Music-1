////////////////////////////////////////////////////////////////
//
//                       SynthDefs
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


////////////////////////// SynthDef ////////////////////////////


// An easy way to audition sounds is by using the {}.play
{ Saw.ar( Line.kr(40, 1000, 5), 0.1) }.play


/*
   This actually creates a 'SynthDef' (behind the scenes).
   However, if we would like to change any values or play
   the sound with patterns, we have to create the SynthDef
   ourselves.

  Below is a X step process of creating a SynthDef, mySynth

*/



// - STEP 1. Empty SynthDef -

// Empty SynthDef with name, empty block and .add (to server).
SynthDef(\mySynth, {    }).add;

// Play the Synth: no sound but SynthCounter goes up.
Synth(\mySynth)





// - STEP 2. Add a Saw Oscillator and Out.ar -

SynthDef(\mySynth, { Out.ar(0, Saw.ar(60)) }).add;

// Play the Synth: static saw wave at 60 hz.
Synth(\mySynth)





// - STEP 3. Add inputs (arguments) for frequency and amplitude -

SynthDef(\mySynth, {|amp=0.2, freq=60| Out.ar(0, Saw.ar(freq, amp)) }).add;

// Play the Synth: static saw wave at 150 hz.
Synth(\mySynth, [\amp, 0.5, \freq, 150])





// - STEP 4. Add an asr envelope for amplitude with doneAction:2 -

(

SynthDef(\mySynth, {|amp=0.2, freq=60, gate=1|
	var env = EnvGen.ar(Env.asr(1, 1, 1), gate, doneAction:2);
	var sound = Saw.ar(freq, amp);
	Out.ar(0, sound * env);
}).add;

)

// Play the Synth: a sustained saw.
x = Synth(\mySynth)

// Set the gate to 0 (release the envelope)
x.set(\gate, 0)





// - STEP 5. Add inputs for the envelope -

(

SynthDef(\mySynth, {|amp=0.2, freq=60, gate=1, atk=1, sus=1, rel=1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction:2);
	var sound = Saw.ar(freq, amp);
	Out.ar(0, sound * env);
}).add;

)

x = Synth(\mySynth, [\freq, 75, \at, 4, \sus, 0.8, \rel, 5])

x.set(\gate, 0)


// - STEP 6. Play with patterns -

(

Pbind(
	\instrument, \mySynth,
	\freq, Pwhite(50, 100)
).play

)

// -----------------------------------------------------------------

//   SynthDef blueprint ...

(

SynthDef(\mySynth, {|amp=0.2, freq=60, gate=1, atk=1, sus=1, rel=1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction:2);

	// Replacing the sound with something else ?
	var sound = Saw.ar(freq, amp);

	Out.ar(0, sound * env);

}).add;

)


( // Example of a substitution ..

SynthDef(\mySynth, {|amp=0.2, freq=60, gate=1, atk=1, sus=1, rel=1|
	var env = EnvGen.ar(Env.asr(atk, sus, rel), gate, doneAction:2);
	var sound = Impulse.ar(LFNoise1.ar([freq/10,freq/2], 200, 220), 0, 0.2);
	Out.ar(0, sound * env);
}).add;

)

x = Synth(\mySynth, [\freq, 500])

x.set(\gate, 0)



/////////////////////// Examples ////////////////////////


// Using { }.play is a shortcutt for actually creating a synthDef an playing it,


{ Resonz.ar(Saw.ar(100), LFNoise1.kr(2).range(200, 2000), 0.2) }.play



// The usual workflow is to add the synthDef and create multiple synths from it.

(

SynthDef("sawFilter", {|frequency = 50, modFrequency=10|
	var mod = LFNoise1.kr(modFrequency).range(200, 4000);
	var sound = Resonz.ar(Saw.ar(frequency), mod, 0.2);
	Out.ar(0, sound ! 2);
}).add;

)


a = Synth("sawFilter", [\frequency, 50]);

a.set(\frequency, 20)




// Within a SynthDef variables and arguments can be used

(

SynthDef("varSawFilter", {|from=100, to=1500|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(100);
	sig = Resonz.ar(sig, resfreq, 0.1);
	Out.ar(0, sig);
	}).add;
)

Synth("varSawFilter", [\to, 500])




// Storing synths in variables enables changing their argument or freeing them

a = Synth("varSawFilter")
a.set(\from, 1000)
a.set(\from, rrand(100,1000), \to, rrand(1001, 2000))
a.free




// A good practice is to use envelopes to free the synths using doneActions

(

SynthDef("envSawFilter", {|from=100, to=1500, freq=100|
	var resfreq, sig;
	resfreq = LFNoise1.kr(1).range(from, to);
	sig = Saw.ar(freq);
	sig = Resonz.ar(sig, resfreq, 0.1);
	sig = sig * EnvGen.ar(Env(), doneAction:2);
	Out.ar(0, sig);
	}).add;

)

Synth("envSawFilter", [\to, 500])

(

Routine({
	32.do {
		Synth("envSawFilter", [\from, rrand(100,1000), \to, rrand(1001, 2000), \freq, rrand(50, 500)]);
		rrand(0.2, 2).wait;
	}
}).play

)


// SynthDescLib can be used to organize SynthDefs

(

SynthDef(\sonology, {|freq=200, amp=0.1|
	var sig = SinOsc.ar * Line.ar(1,0,1,doneAction:2);
	Out.ar(0, sig * amp ! 2)
}).store

)

Synth(\sonology)

SynthDescLib.global.synthDescs[\sonology]

SynthDescLib.global.browse;


// SynthDefs have an additional argument for lag times

(
SynthDef(\dust, {|density=100, amp=0.75|
	var env, sig;
	env = EnvGen.ar(Env.new([0,1,0],[10,100]), doneAction:2);
	sig = Dust.ar(density.poll) * amp;
	Out.ar(0, sig * env ! 2)
}, [10, 5]).add
)

a = Synth(\dust, [\density, 20])
a.set(\density, 500)
a.set(\density, 1000)
a.set(\amp, 0.0)

