////////////////////////////////////////////////////////////////
//
//              Programming and Music 1 - Exercises
//
////////////////////////////////////////////////////////////////

/*

//////////////////////////// Patterns ////////////////////////////

Exercise 1: Steady Pulse
Use a Pbind with \instrument \sine to trigger a fixed frequency (say 300)
at a steady rate. Set \dur to 0.25 so it pulses four times a second.

Exercise 2: Random Rhythm
Take Exercise 1 and make the rhythm irregular by setting \dur to a
Pwhite between 0.05 and 0.4. Keep the frequency fixed.

Exercise 3: Frequency Cloud
Create a Pbind that picks a random \freq between 200 and 3000 for every
event using Pwhite. Use a short \dur (0.1) so it forms a pointillist cloud.

Exercise 4: Exponential Spread
Repeat Exercise 3 but use Pexprand(200, 3000) instead of Pwhite. Listen to
how the frequencies spread more evenly across our perception of pitch.

Exercise 5: Frequency Drift
Use Pbrown to make the \freq wander smoothly between 100 and 2000 with a
maximum step of 100. This creates a gliding, connected texture.

Exercise 6: Rests
Use Pseq for \freq with a Rest() in the sequence, e.g. [300, 600, Rest(), 900],
so the pattern has rhythmic gaps. Set \dur to 0.2.

Exercise 7: Two Layers
Use Ppar to play two Pbinds at once: a slow low layer (freq ~100, dur 0.5)
and a fast high layer (random freq 2000-5000, dur 0.1).



/////////////////////////// Synthesis ////////////////////////////

Exercise 8: Percussive Sine
Write a SynthDef \ping with a SinOsc and a percussive envelope
(Env.perc) that frees itself with doneAction:2. Trigger it from a Pbind.

Exercise 9: Envelope Shapes
Extend \ping with \atk and \rel arguments controlling the attack and
release of Env.perc. Play a Pbind that randomises both per event.

Exercise 10: Subtractive
Write a SynthDef \subt with a Saw through a low-pass filter (LPF or RLPF).
Add an envelope. Play it from a Pbind with random \cutoff values.

Exercise 11: Filter Sweep
In a SynthDef, modulate a filter's cutoff with a slow LFO (SinOsc.kr or
LFNoise1.kr) mapped to a frequency range. Play one long held synth.

Exercise 12: Pulse Width Modulation
Write a SynthDef using Pulse.ar where the width is modulated by a slow
SinOsc.kr (mapped to roughly 0.1 to 0.9). Listen to the timbre move.

Exercise 13: Additive
Write a SynthDef that stacks several sine partials with Mix.fill, where
each partial is a harmonic (freq * (i+1)) with decreasing amplitude.

Exercise 14: FM
Write a SynthDef using PMOsc.ar (phase modulation). Expose the modulation
\index as an argument and play a Pbind that randomises it per event.

Exercise 15: Filtered Noise
Write a SynthDef that filters WhiteNoise (or PinkNoise) through a band-pass
filter (BPF). Play a gesture by randomising the centre frequency.

Exercise 16: Ring Modulation
Write a SynthDef that multiplies two sine oscillators (carrier * modulator)
to produce sidebands. Expose both frequencies as arguments.

Exercise 17: Distortion
Write a SynthDef that drives a Saw or Sine hard into a non-linearity using
.tanh, .distort or .fold2. Add an envelope and play it.

Exercise 18: Tremolo
Write a SynthDef where the amplitude is modulated by an LFO (a unipolar
SinOsc.kr) to create tremolo. Expose the tremolo \rate as an argument.

Exercise 19: Vibrato
Write a SynthDef where a slow SinOsc.kr is added to the frequency to create
vibrato. Expose the vibrato \rate and \depth as arguments.

Exercise 20: Envelope-Modulated Filter
Write a SynthDef where an EnvGen (Env.perc) modulates a filter's cutoff,
giving each note a "sweep". Play it from a Pbind.



//////////////////////// Control & Time ///////////////////////////

Exercise 21: TempoClock
Create a TempoClock at 132 BPM and play a Pbind on it. Then change the
tempo while it is running.

Exercise 22: Routine
Write a Routine that plays a few synths in sequence with .wait between
them, building a short timed gesture.



////////////////////////////// GUI ///////////////////////////////

Exercise 23: One Slider
Start a synth, then build a Window with an EZSlider that controls one of
its parameters (e.g. filter cutoff) live.

Exercise 24: Control Panel
Build a Window with three EZSliders controlling frequency, cutoff and
amplitude of a running synth. Use ControlSpec for sensible ranges.



////////////////////////////// MIDI //////////////////////////////

Exercise 25: MIDI Trigger
Use MIDIFunc.noteOn to trigger a percussive synth from a MIDI keyboard.
Map velocity to amplitude and the note number to the filter cutoff
(so the keyboard controls timbre, not melody).

*/
