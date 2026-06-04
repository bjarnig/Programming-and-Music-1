# Programming and Music 1

The course covers programming fundamentals, synthesis, composition,
and interaction approaches. Topics are studied using the SuperCollider
programming environment.

The course starts by going through the basic concepts of programming
and computer science while gradually introducing topics related to
algorithmic composition and sound synthesis.

Finally, interaction processes using graphical user interfaces and external
controllers are studied to create original systems capable of generating
music.

## Course Structure

### 01 - Introduction
- Course overview and introduction to SuperCollider
- PMA01 - Introduction.pdf

### 02 - Syntax
- Basic SuperCollider language syntax and fundamentals
- **Code files:**
  - `Syntax.scd` - Core syntax examples and language fundamentals
  - `Basics.scd` - Essential syntax elements and environment shortcuts
- PMA02 - Syntax.pdf

### 03 - Control Flow
- Iteration, conditions, and program flow control
- **Code files:**
  - `ControlFlow.scd` - Loops, conditionals, and control structures
- PMA03 - Control Flow.pdf

### 04 - Functions
- Functions, arguments, scope, and closures
- **Code files:**
  - `Functions.scd` - Function definitions, arguments, and scope
  - `EX03 - Solutions.scd` - Exercise solutions
- PMA04 - Functions.pdf

### 05 - Data Structures
- Arrays, lists, dictionaries, sets, and object modeling
- **Code files:**
  - `Data Structures.scd` - Collections and data organization
  - `Object Modelling.scd` - Event-based objects and modeling
  - `EX04 - Solutions.scd` - Exercise solutions
- PMA05 - Data Structures.pdf

### 06 - Approaches
- Programming strategies, problem-solving, and best practices
- **Code files:**
  - `Approaches.scd` - Programming methodologies
  - `Strategies.scd` - Problem-solving techniques and debugging
  - `Review, Syntax.scd` - Syntax review exercises
  - `Review, Functions.scd` - Function concepts review
  - `Review, Data Structures.scd` - Data structures review
  - `Review, ControlFlow.scd` - Control flow review
  - `EX05 - Solutions.scd` - Exercise solutions
- PMA06 - Approaches.pdf

### 07 - Exercises
- Practice exercises covering fundamental concepts
- **Code files:**
  - `Set A - Exercises.scd` / `Set A - Solutions.scd` - Exercise set A
  - `Set B - Exercises.scd` / `Set B - Solutions.scd` - Exercise set B
  - `Set C - Exercises.scd` / `Set C - Solutions.scd` - Exercise set C
- PMA07 - Exercises.pdf
- PMA - Assignment 1 (2025).pdf

### 08 - Routines
- Temporal control using Routines and Tasks
- **Code files:**
  - `Routines.scd` - Routine fundamentals and temporal sequencing
  - `EX06 - Solutions.scd` - Exercise solutions
- PMA08 - Routines.pdf

### 09 - Synthesis
- Introduction to sound synthesis techniques
- **Code files:**
  - `Synthesis.scd` - Additive synthesis, noises, filters, and subtractive synthesis
- PMA09 - Synthesis 1.pdf

### 10 - Modulation
- Amplitude modulation, ring modulation, and frequency modulation
- **Code files:**
  - `Modulation.scd` - Tremolo, AM, ring modulation, and FM synthesis
  - `LFOs.scd` - Low-frequency oscillators
  - `Envelopes.scd` - Envelope generators
  - `SynthDefs.scd` - Synthesizer definitions
  - `Environment.scd` - Environment setup
  - `- EX10 - Exercises.scd` - Practice exercises
  - `- EX09 - Solutions.scd` - Exercise solutions
- PMA10 - Modulation.pdf

### 11 - Shaping
- Signal shaping techniques: lag, clipping, folding, wrapping, and quantization
- **Code files:**
  - `Shaping.scd` - Waveshaping fundamentals
  - `Expansion.scd` - Multichannel expansion
  - `Waveforms.scd` - Waveform generation
  - `Formants.scd` - Formant synthesis
  - `Examples.scd` - Practical examples
  - `Shaping - Exercises.scd` / `Shaping - Solutions.scd` - Practice exercises
  - `EX10 - Solutions.scd` - Exercise solutions

### 12 - Clocks
- Timing, scheduling, and temporal coordination
- **Code files:**
  - `Clocks.scd` - Clock fundamentals and scheduling
  - `EX08 - Solutions.scd` - Exercise solutions
- PMA08 - Clocks.pdf

### 13 - Patterns 1
- Introduction to pattern-based composition
- **Code files:**
  - `PMA11 - Patterns.scd` - Pattern fundamentals
- PMA11 - Patterns.pdf
- PMA - Assignment 2 (2025).pdf

### 14 - Patterns 2
- Advanced pattern techniques and composition strategies
- **Code files:**
  - `MorePatterns.scd` - Advanced pattern techniques
  - `Approaches.scd` - Compositional approaches with patterns
  - `Examples.scd` - Pattern examples
  - `Recap.scd` - Pattern concepts review
  - `Misc.scd` - Additional techniques
- PMA12 - More Patterns.pdf

### 15 - Review
- Review of synthesis, SynthDefs, Routines, and Patterns
- **Code files:**
  - `Synths and Patterns.scd` - Combining SynthDefs with pattern-based composition
  - `Synths and Routines.scd` - Combining SynthDefs with Routine-based sequencing
- PMA15 - Review.pdf

### 16 - GUI
- Graphical user interfaces in SuperCollider
- **Code files:**
  - `GUI.scd` - GUI fundamentals and window/widget creation
  - `Layouts.scd` - Layout management for GUI components
  - `Interfaces.scd` - Building interactive control interfaces
  - `Movement.scd` - Animated and dynamic GUI elements
  - `Pen.scd` - Custom drawing with the Pen class
  - `Example.scd` - Practical GUI examples
  - `- EX16 - Exercises.scd` / `- EX16 - Solutions.scd` - Practice exercises
- PMA16 - GUI.pdf

### 17 - MIDI & Mapping
- MIDI communication and parameter mapping
- **Code files:**
  - `MIDI.scd` - MIDI input, output, and device interaction
  - `Mapping.scd` - Parameter mapping and scaling strategies
  - `Extensions.scd` - SuperCollider extension methods for control
- PMA15 - Mapping&MIDI.pdf

### 18 - Control
- Integrating GUI and MIDI for interactive control systems
- **Code files:**
  - `GUI.scd` - GUI-based control examples
  - `MIDI.scd` - MIDI-based control examples
- PMA18 - Control.pdf

### 19 - Effects
- Audio effects, signal routing, and feedback
- **Code files:**
  - `Effects.scd` - Reverb, delay, and other audio effects
  - `Feedback.scd` - Feedback networks and self-modulating systems
  - `Routing.scd` - Bus routing and signal flow
  - `Sampling.scd` - Sample playback and manipulation
- PMA20 - Processing.pdf

### 20 - Examples
- Synthesis and processing examples bringing together course concepts
- **Code files:**
  - `Synthesis.scd` - Synthesis technique examples
  - `Processing.scd` - Audio processing and effects examples
- PMA20 - Examples.pdf

### 21 - More Examples
- Further examples integrating synthesis, control and processing
- **Code files:**
  - `UGens.scd` - Working with unit generators
  - `Sounds.scd` - Sound design examples
  - `Effects.scd` - Effects and processing examples
  - `Buses.scd` - Audio/control bus routing
  - `Input.scd` - Live audio input processing
  - `Particles.scd` - Particle-style sound generation
  - `Defer.scd` - Deferring to the AppClock for GUI/timing
  - `Examples.scd` - Combined examples
- PMA21 - Examples.pdf

### 22 - Exercises
- Final exercises and consolidation
- **Code files:**
  - `Exercises.scd` - Practice exercises
  - `Solutions.scd` - Exercise solutions
- PMA22 - Exercises.pdf

## Resources

[https://www.bjarni-gunnarsson.net/courses](https://www.bjarni-gunnarsson.net/courses)

[https://sonology.org/bachelors-programme/](https://sonology.org/bachelors-programme/)