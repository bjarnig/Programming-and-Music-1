////////////////////////////////////////////////////////////////
//
//                      PMA11 - SynthDefs
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
