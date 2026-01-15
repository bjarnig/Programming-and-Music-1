////////////////////////////////////////////////////////////////
//
//                     Shaping - Exercises
//
////////////////////////////////////////////////////////////////

/*

Exercise 1: Simple Filtered Noise
Create a patch with white noise passed through a resonant lowpass filter (RLPF).
Use LFNoise2 to slowly modulate the filter cutoff frequency between 300 Hz and 2000 Hz.


Exercise 2: Saw Wave with Filter Sweep
Create a sawtooth wave at 100 Hz. Add a sine wave LFO (0.5 Hz) to control the 
cutoff frequency of a lowpass filter, sweeping between 200 Hz and 1500 Hz.


Exercise 3: Pulse Width Modulation
Create a Pulse wave at 110 Hz. Use an LFO (LFTri) to modulate the pulse width
parameter between 0.1 and 0.9. Listen to how the timbre changes.


Exercise 4: Tremolo Effect
Create a sound using Mix of three slightly detuned saw waves (80, 81, 82 Hz).
Add a tremolo effect using a sine wave at 6 Hz to modulate the amplitude.


Exercise 5: Percussive Filter Envelope
Create a percussive sound with a Saw wave. Use two envelopes:
- Amplitude envelope: attack 0.01, release 0.8
- Filter envelope: attack 0.01, release 0.3, controlling filter cutoff
Make the filter sweep from 200 Hz to 3000 Hz.


Exercise 6: Simple Ring Modulation
Create a ring modulation patch with two sine waves:
- Carrier: 300 Hz
- Modulator: 150 Hz
Add a percussive envelope (attack 0.01, release 1.5) to the result.


Exercise 7: Dust Triggered Tones
Use Dust.ar to create random triggers (8 per second). On each trigger, use TRand
to choose a random frequency between 400 and 1600 Hz. Create short sine tones
at these frequencies.


Exercise 8: Additive Synthesis with Envelopes
Create an additive synthesis patch using 5 sine waves at harmonic frequencies
(100, 200, 300, 400, 500 Hz). Give each partial a different envelope with random
attack (0.01 to 0.2) and release (0.5 to 2.0) times.


Exercise 9: Layered Noise Bands
Create 3 bandpass filtered noise bands at different frequencies (500, 1500, 3000 Hz).
Pan each band to a different position (left, center, right). Use different bandwidth
values (0.1, 0.05, 0.02) to create variety.


Exercise 10: LFO Pitch Modulation
Create a Blip oscillator. Use LFNoise2 at a slow rate (0.5 Hz) to modulate its
frequency between 50 and 400 Hz. Set the number of harmonics to 8.


Exercise 11: Detuned Oscillator Stack
Create 5 saw waves all based around 200 Hz but slightly detuned (198, 199, 200, 
201, 202 Hz). Mix them together and add a slow amplitude LFO using SinOsc at 0.3 Hz.


Exercise 12: Filtered Dust with Resonance
Create a Dust source with 150 impulses per second. Pass it through a resonant
filter (Resonz) at 800 Hz with a Q of 0.05. Multiply the output by 3 to boost
the signal.


Exercise 13: Sample and Hold Melody
Create a melody using sample and hold. Use Impulse.kr as a trigger at 6 Hz.
Use TChoose to select frequencies from this array: [220, 247, 277, 330, 370].
Apply Lag (0.03) to smooth the transitions slightly.


Exercise 14: Waveshaping with Fold
Create a sine wave at 120 Hz. Multiply it by a slowly changing amount using
LFNoise2.kr (0.3 Hz) ranging from 1 to 3. Apply .fold2(1) to create harmonic
distortion. Listen to how the spectrum changes.

*/
