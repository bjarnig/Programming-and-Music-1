////////////////////////////////////////////////////////////////
//
//                       (Pbind) Events
//
////////////////////////////////////////////////////////////////

// Events are the building blocks that Pbind works with.


///////////////////////////// Event /////////////////////////////

// An Event is like a dictionary of instructions for making sound

// The simplest event - play the default sound
().play

// Event with a specific frequency
(freq: 500).play

// Event with multiple parameters
(freq: 400, amp: 0.3).play

// Event with MIDI note instead of frequency
(midinote: 60, amp: 0.5).play

// Multiple notes at once (a chord)
(midinote: [60, 64, 67]).play


//////////////////// Default Instrument ///////////////////////

// By default, events use a built-in synth called \default

( // Our instrument that will replace it

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)

// Test the synth
Synth(\sine, [\freq, 440])

// Use it in an event by specifying \instrument
(instrument: \sine, freq: 600).play

(instrument: \sine, midinote: 72, amp: 0.5).play


//////////////////////////// Pbind ///////////////////////////

// Pbind binds (connects) keys with patterns of values

Pbind().play


( // Three notes in sequence

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67], 2), // repeat twice
	\dur, 0.1                        // 100 ms between notes
).play

)


( // Vary both pitch and duration

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, Pseq([0.5, 0.5, 0.25, 0.25], inf)
).play

)


( // Different sequence lengths

Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67], inf),      // 3 notes
	\dur, Pseq([0.1, 0.2, 0.3, 0.05], inf),  // 4 durations
	\amp, Pseq([0.3, 0.2], inf)              // 2 amplitudes
).play

)


///////////////// Storing and Controlling ///////////////////


( // Store the event stream player in a variable

p = Pbind(
	\instrument, \sine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, 0.1
).play;

)

// Control it
p.stop;
p.play;
p.pause;
p.resume;
p.reset;
