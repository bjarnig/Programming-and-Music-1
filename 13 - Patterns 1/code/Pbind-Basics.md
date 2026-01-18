# Pbind Basics - Key Concepts

---

## Slide 1: What is Pbind?

**Pbind** = Pattern Bind - connects parameter names with patterns of values

### Core Structure
```
Pbind(
    \instrument, \synthName,
    \midinote, Pseq([60, 64, 67], inf),
    \dur, 0.2,
    \amp, 0.3
).play
```

### Key Concepts
- **Events**: Dictionaries of instructions for making sound
- Each event specifies: pitch, timing, amplitude, and other parameters
- Patterns generate sequences of values
- `.play` starts the pattern on a clock (TempoClock by default)

### Control
- `.stop` - stop the pattern
- `.pause` / `.resume` - pause and resume
- `.reset` - start from beginning

---

## Slide 2: Specifying Pitch

### Four Methods (in order of priority)

**1. \degree** - Scale degrees (most musical)
- Uses scale steps: `0, 1, 2, 3...`
- Works with `\scale` (Scale.major, Scale.minor, Scale.chromatic, etc.)
- Example: `\degree, Pseq([0, 2, 4, 5, 7], inf), \scale, Scale.minor`

**2. \note** - Chromatic notes within an octave
- 0-11 (12 semitones)
- Combine with `\octave` to specify register
- Example: `\note, Pseq([0, 4, 7], inf), \octave, 5`

**3. \midinote** - MIDI note numbers
- 60 = middle C, 69 = A440
- Each number = one semitone
- Example: `\midinote, Pseq([60, 61, 66, 73], inf)`

**4. \freq** - Direct frequency in Hz
- Raw frequency values (440 = A4)
- Example: `\freq, Pseq([220, 330, 440], inf)`

### Conversions
- `60.midicps` → MIDI to Hz
- `440.cpsmidi` → Hz to MIDI

---

## Slide 3: Timing & Duration

### \dur - Controls WHEN the next note plays
```
\dur, 1              // 1 beat
\dur, 0.25           // quarter beat
\dur, 1/3            // triplets
\dur, Pseq([0.25, 0.5], inf)  // rhythmic pattern
```

### \legato - Controls HOW LONG the note lasts
- Value is fraction of duration
- `0.8` (default) = 80% of duration
- `0.1` = staccato (short)
- `1.5` = legato (overlapping)

### Rest() - Creates silence
```
\midinote, Pseq([60, 64, Rest(), 72], inf)
```

### TempoClock - Global tempo control
```
t = TempoClock(120/60);  // 120 BPM
Pbind(...).play(t);
t.tempo = 180/60;        // Change tempo while playing
```

---

## Slide 4: Amplitude & Pattern Types

### Amplitude Control

**\amp** - Direct amplitude (0.0 to 1.0)
```
\amp, Pseq([0.6, 0.2, 0.3], inf)  // accents
\amp, Pwhite(0.2, 0.5)            // random
```

**\db** - In decibels (more natural)
```
\db, Pseq([-20, -10, -6], inf)
```

### Essential Pattern Types

**Pseq** - Play values in sequence
```
Pseq([60, 64, 67], inf)      // infinite repetition
Pseq([60, 64, 67], 2)        // repeat twice then stop
```

**Pwhite** - Uniform random
```
Pwhite(60, 84)               // random between 60-84
```

**Pbrown** - Random walk (Brownian motion)
```
Pbrown(60, 84, 2, inf)       // wander with step size 2
```

**Pseries** - Arithmetic series
```
Pseries(48, 1, 13)           // start 48, add 1, 13 times
Pn(Pseries(48, 1, 13))       // wrap in Pn() to repeat
```

**Pgeom** - Geometric series
```
Pgeom(0.1, 1.1, 20)          // start 0.1, multiply by 1.1
```

---

## Quick Reference Card

### Pitch Priority (highest to lowest)
`\degree > \note > \midinote > \freq`

### Essential Parameters
- `\instrument` - which SynthDef to use
- `\midinote` / `\degree` - pitch
- `\dur` - timing between events
- `\amp` - volume (0.0 - 1.0)
- `\legato` - note length (fraction of dur)
- `\scale` - Scale.major, Scale.minor, Scale.chromatic
- `\octave` - which octave (4 = middle C)
- `\root` - transposition

### Common Patterns
- `Pseq(array, repeats)` - sequence
- `Pwhite(lo, hi)` - random uniform
- `Pbrown(lo, hi, step)` - random walk
- `Pseries(start, step, length)` - arithmetic
- `Pgeom(start, grow, length)` - geometric
- `Rest()` - silence

### Remember
- Use `inf` for infinite repetition
- Wrap finite patterns in `Pn()` to repeat: `Pn(Pseries(...))`
- Different pattern lengths create polyrhythm
- Arrays create chords: `[60, 64, 67]`
