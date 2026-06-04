////////////////////////////////////////////////////////////////
//
//              Programming and Music 1 - Solutions
//
////////////////////////////////////////////////////////////////

// One solution per exercise. Evaluate the setup block first, then any
// solution block. Press Cmd-. to stop sound between exercises.


( // Setup - SynthDefs used by the pattern exercises

SynthDef(\sine, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\saw, {|freq=440, amp=0.2, cutoff=2000, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = LPF.ar(Saw.ar(freq), cutoff) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\noise, {|freq=1000, amp=0.2, rq=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.3), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

)


/* Exercise 1: Steady Pulse
Use a Pbind with \instrument \sine to trigger a fixed frequency (say 300)
at a steady rate. Set \dur to 0.25 so it pulses four times a second. */

( // Solution 1

Pbind(
	\instrument, \sine,
	\freq, 300,
	\dur, 0.25
).play

)


/* Exercise 2: Random Rhythm
Take Exercise 1 and make the rhythm irregular by setting \dur to a
Pwhite between 0.05 and 0.4. Keep the frequency fixed. */

( // Solution 2

Pbind(
	\instrument, \sine,
	\freq, 300,
	\dur, Pwhite(0.05, 0.4)
).play

)


/* Exercise 3: Frequency Cloud
Create a Pbind that picks a random \freq between 200 and 3000 for every
event using Pwhite. Use a short \dur (0.1) so it forms a pointillist cloud. */

( // Solution 3

Pbind(
	\instrument, \sine,
	\freq, Pwhite(200, 3000),
	\dur, 0.1
).play

)


/* Exercise 4: Exponential Spread
Repeat Exercise 3 but use Pexprand(200, 3000) instead of Pwhite. Listen to
how the frequencies spread more evenly across our perception of pitch. */

( // Solution 4

Pbind(
	\instrument, \sine,
	\freq, Pexprand(200, 3000),  // exponential = perceptually even
	\dur, 0.1
).play

)


/* Exercise 5: Frequency Drift
Use Pbrown to make the \freq wander smoothly between 100 and 2000 with a
maximum step of 100. This creates a gliding, connected texture. */

( // Solution 5

Pbind(
	\instrument, \sine,
	\freq, Pbrown(100, 2000, 100),
	\dur, 0.12
).play

)


/* Exercise 6: Rests
Use Pseq for \freq with a Rest() in the sequence, e.g. [300, 600, Rest(), 900],
so the pattern has rhythmic gaps. Set \dur to 0.2. */

( // Solution 6

Pbind(
	\instrument, \sine,
	\freq, Pseq([300, 600, Rest(), 900], inf),
	\dur, 0.2
).play

)


/* Exercise 7: Two Layers
Use Ppar to play two Pbinds at once: a slow low layer (freq ~100, dur 0.5)
and a fast high layer (random freq 2000-5000, dur 0.1). */

( // Solution 7

Ppar([
	Pbind(\instrument, \sine, \freq, 100, \dur, 0.5, \amp, 0.3),
	Pbind(\instrument, \sine, \freq, Pexprand(2000, 5000), \dur, 0.1, \amp, 0.1)
]).play

)


/* Exercise 8: Percussive Sine
Write a SynthDef \ping with a SinOsc and a percussive envelope
(Env.perc) that frees itself with doneAction:2. Trigger it from a Pbind. */

( // Solution 8

SynthDef(\ping, {|freq=440, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.005, 0.4), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \ping, \freq, Pexprand(200, 2000), \dur, 0.2).play;

)


/* Exercise 9: Envelope Shapes
Extend \ping with \atk and \rel arguments controlling the attack and
release of Env.perc. Play a Pbind that randomises both per event. */

( // Solution 9

SynthDef(\ping2, {|freq=440, amp=0.2, atk=0.01, rel=0.3, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \ping2,
	\freq, Pexprand(200, 2000),
	\atk, Pwhite(0.001, 0.2),
	\rel, Pwhite(0.05, 0.6),
	\dur, 0.25
).play;

)


/* Exercise 10: Subtractive
Write a SynthDef \subt with a Saw through a low-pass filter (LPF or RLPF).
Add an envelope. Play it from a Pbind with random \cutoff values. */

( // Solution 10

SynthDef(\subt, {|freq=110, amp=0.2, cutoff=1000, rq=0.4, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.4), doneAction:2);
	sig = RLPF.ar(Saw.ar(freq), cutoff, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \subt,
	\freq, Pexprand(60, 400),
	\cutoff, Pexprand(300, 5000),
	\dur, 0.2
).play;

)


/* Exercise 11: Filter Sweep
In a SynthDef, modulate a filter's cutoff with a slow LFO (SinOsc.kr or
LFNoise1.kr) mapped to a frequency range. Play one long held synth. */

( // Solution 11

x = {
	var sig, cutoff;
	cutoff = SinOsc.kr(0.2).exprange(200, 5000);  // slow sweep
	sig = RLPF.ar(Saw.ar(80), cutoff, 0.2);
	sig * 0.2 ! 2;
}.play;

)
x.free;


/* Exercise 12: Pulse Width Modulation
Write a SynthDef using Pulse.ar where the width is modulated by a slow
SinOsc.kr (mapped to roughly 0.1 to 0.9). Listen to the timbre move. */

( // Solution 12

x = {
	var width = SinOsc.kr(0.5).range(0.1, 0.9);
	Pulse.ar(120, width) * 0.2 ! 2;
}.play;

)
x.free;


/* Exercise 13: Additive
Write a SynthDef that stacks several sine partials with Mix.fill, where
each partial is a harmonic (freq * (i+1)) with decreasing amplitude. */

( // Solution 13

SynthDef(\additive, {|freq=110, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.8), doneAction:2);
	sig = Mix.fill(8, {|i| SinOsc.ar(freq * (i + 1)) * (1 / (i + 1)) });
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \additive, \freq, Pexprand(50, 300), \dur, 0.5).play;

)


/* Exercise 14: FM
Write a SynthDef using PMOsc.ar (phase modulation). Expose the modulation
\index as an argument and play a Pbind that randomises it per event. */

( // Solution 14

SynthDef(\fm, {|freq=200, ratio=2, index=4, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction:2);
	sig = PMOsc.ar(freq, freq * ratio, index) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \fm,
	\freq, Pexprand(80, 500),
	\index, Pwhite(1, 10),
	\dur, 0.25
).play;

)


/* Exercise 15: Filtered Noise
Write a SynthDef that filters WhiteNoise (or PinkNoise) through a band-pass
filter (BPF). Play a gesture by randomising the centre frequency. */

( // Solution 15

SynthDef(\fnoise, {|freq=1000, rq=0.1, amp=0.4, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.linen(0.05, 0.1, 0.3), doneAction:2);
	sig = BPF.ar(WhiteNoise.ar, freq, rq) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \fnoise,
	\freq, Pexprand(400, 6000),
	\rq, Pwhite(0.05, 0.3),
	\dur, Pwhite(0.2, 0.6)
).play;

)


/* Exercise 16: Ring Modulation
Write a SynthDef that multiplies two sine oscillators (carrier * modulator)
to produce sidebands. Expose both frequencies as arguments. */

( // Solution 16

SynthDef(\ring, {|carrier=300, modulator=140, amp=0.3, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction:2);
	sig = SinOsc.ar(carrier) * SinOsc.ar(modulator);
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \ring,
	\carrier, Pexprand(200, 1200),
	\modulator, Pexprand(50, 400),
	\dur, 0.3
).play;

)


/* Exercise 17: Distortion
Write a SynthDef that drives a Saw or Sine hard into a non-linearity using
.tanh, .distort or .fold2. Add an envelope and play it. */

( // Solution 17

SynthDef(\dist, {|freq=110, drive=8, amp=0.2, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, 0.4), doneAction:2);
	sig = (Saw.ar(freq) * drive).tanh;  // soft clipping
	Out.ar(0, Pan2.ar(sig * env * amp, pan));
}).add;

Pbind(\instrument, \dist,
	\freq, Pexprand(60, 300),
	\drive, Pwhite(2, 20),
	\dur, 0.25
).play;

)


/* Exercise 18: Tremolo
Write a SynthDef where the amplitude is modulated by an LFO (a unipolar
SinOsc.kr) to create tremolo. Expose the tremolo \rate as an argument. */

( // Solution 18

x = {|rate=8|
	var trem = SinOsc.kr(rate).range(0, 1);  // unipolar LFO
	SinOsc.ar(400) * trem * 0.2 ! 2;
}.play;

)
x.set(\rate, 3);
x.free;


/* Exercise 19: Vibrato
Write a SynthDef where a slow SinOsc.kr is added to the frequency to create
vibrato. Expose the vibrato \rate and \depth as arguments. */

( // Solution 19

x = {|rate=6, depth=10|
	var vib = SinOsc.kr(rate) * depth;  // +/- depth Hz
	SinOsc.ar(400 + vib) * 0.2 ! 2;
}.play;

)
x.set(\depth, 40);
x.free;


/* Exercise 20: Envelope-Modulated Filter
Write a SynthDef where an EnvGen (Env.perc) modulates a filter's cutoff,
giving each note a "sweep". Play it from a Pbind. */

( // Solution 20

SynthDef(\sweep, {|freq=80, amp=0.2, pan=0|
	var sig, env, fenv;
	env = EnvGen.kr(Env.perc(0.01, 0.5), doneAction:2);
	fenv = EnvGen.kr(Env.perc(0.01, 0.4)).exprange(200, 6000);  // cutoff sweep
	sig = RLPF.ar(Saw.ar(freq), fenv, 0.2) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

Pbind(\instrument, \sweep, \freq, Pexprand(40, 160), \dur, 0.3).play;

)


/* Exercise 21: TempoClock
Create a TempoClock at 132 BPM and play a Pbind on it. Then change the
tempo while it is running. */

( // Solution 21

t = TempoClock(132/60);

Pbind(
	\instrument, \sine,
	\freq, Pexprand(200, 2000),
	\dur, 0.25
).play(t);

)

t.tempo = 200/60;  // speed up
t.tempo = 80/60;   // slow down


/* Exercise 22: Routine
Write a Routine that plays a few synths in sequence with .wait between
them, building a short timed gesture. */

( // Solution 22

Routine({
	Synth(\noise, [\freq, 4000, \rq, 0.1]);
	0.3.wait;
	Synth(\subt, [\freq, 80, \cutoff, 1200]);
	0.5.wait;
	Synth(\additive, [\freq, 120]);
	0.4.wait;
	Synth(\fm, [\freq, 300, \index, 8]);
}).play;

)


/* Exercise 23: One Slider
Start a synth, then build a Window with an EZSlider that controls one of
its parameters (e.g. filter cutoff) live. */

( // Solution 23

x = {|cutoff=800| RLPF.ar(Saw.ar(80), cutoff, 0.2) * 0.2 ! 2 }.play;

w = Window("Cutoff", Rect(200, 200, 320, 60)).front;
EZSlider(w, 300@30, "cutoff", ControlSpec(100, 8000, \exponential),
	{|ez| x.set(\cutoff, ez.value) }, 800);

)


/* Exercise 24: Control Panel
Build a Window with three EZSliders controlling frequency, cutoff and
amplitude of a running synth. Use ControlSpec for sensible ranges. */

( // Solution 24

SynthDef(\panel, {|freq=80, cutoff=1000, amp=0.2|
	Out.ar(0, RLPF.ar(Saw.ar(freq), cutoff, 0.2) * amp ! 2);
}).add;
g = Synth(\panel);

w = Window("Synth", Rect(200, 200, 340, 130)).front;
w.layout = VLayout(
	EZSlider(w, 320@30, "freq",   ControlSpec(40, 800, \exp),    {|e| g.set(\freq, e.value) }, 80),
	EZSlider(w, 320@30, "cutoff", ControlSpec(100, 8000, \exp),  {|e| g.set(\cutoff, e.value) }, 1000),
	EZSlider(w, 320@30, "amp",    ControlSpec(0, 0.5, \lin),     {|e| g.set(\amp, e.value) }, 0.2)
);

)


/* Exercise 25: MIDI Trigger
Use MIDIFunc.noteOn to trigger a percussive synth from a MIDI keyboard.
Map velocity to amplitude and the note number to the filter cutoff
(so the keyboard controls timbre, not melody). */

( // Solution 25

MIDIClient.init;
MIDIIn.connectAll;

SynthDef(\hit, {|cutoff=1000, amp=0.3, pan=0|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.005, 0.25), doneAction:2);
	sig = RLPF.ar(Saw.ar(60), cutoff, 0.2) * env * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

~trig = MIDIFunc.noteOn({|vel, num|
	Synth(\hit, [
		\cutoff, num.linexp(0, 127, 200, 8000),  // note -> timbre
		\amp, vel.linlin(0, 127, 0.05, 0.4)       // velocity -> loudness
	]);
});

)
~trig.free;
