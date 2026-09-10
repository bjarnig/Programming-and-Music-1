---
theme: seriph
addons:
  - ./shared
title: Programming and Music 1 — 01 Introduction
titleTemplate: '%s'
layout: default
class: title
transition: slide-left
colorSchema: dark
favicon: /favicon.ico
mdc: true
---

<div class="logos">
  <img src="/figures/logo-001.png" alt="Institute of Sonology" />
  <img src="/figures/logo-002.png" alt="Royal Conservatoire The Hague" />
</div>

<div class="deck-title">Programming and Music 1</div>

<div class="sub">
  Programming and Music 1
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---
layout: center
class: divider
---

Class

---

# Course Description

The course covers programming fundamentals, **synthesis**, **composition** and **interaction**. Topics are studied using the **SuperCollider** environment.

It starts with the basic concepts of programming, then gradually introduces sound synthesis and ways of organising music in time.

It ends with interaction: graphical interfaces and external controllers, used to build original systems that make music.

---

# Programming and Music

A program is a **description of a process**, written so that a machine can carry it out.

That is a useful thing for a musician to be able to write, because a great deal of music is process: something repeated, something varied, something responding.

- You write **what should happen**, not every result
- The machine produces the results, as many as you ask for
- You change the description, and every result changes with it

<span class="q">What would you want to hear a hundred of, that you would not want to record one at a time?</span>

---

# Objectives

At the end of this course, you:

- Know the basics of **programming** in SuperCollider, and how to use it for musical projects
- Have basic knowledge of **algorithmic composition** and of programming **sounds**
- Can implement **user interfaces** and use **external controllers** for musical applications

---

# Assessment Criteria

- Computer programming **basics**
- Ability to **read and write** computer code
- **Clarity** in implementing technical solutions
- Knowledge of computer music **fundamentals**

---

# Prerequisites

An interest in learning **programming** and **computer music**.

Having a computer capable of running **SuperCollider**, or be willing to come to the Sonology studios to use it.

Some *experience* with computers and digital audio is useful but not required.

<span class="note">No previous programming is assumed. Everything the course needs is taught in it.</span>

---

# Course Format

A class usually focuses on one topic, or a small group of related topics.

Part of the lesson is a **presentation** of the topic, with slides and discussion.

The other part is **hands-on** work in SuperCollider. Discussion and interaction should take place as much as possible.

<span class="note">If you can, bring your laptops to classes.</span>

---

# Assessment

Three practical **assignments**, each worth 30% of the final grade.

Each involves writing programs for a musical or sonic problem, with **documentation** explaining the chosen solutions and their motivations.

**Attendance** counts for the remaining 10%. All three assignments must be completed to pass.

---

# Materials

Slides, code and handouts for every class are published as the year goes.

<span class="note">Slides: <a href="https://slides.bjarni-gunnarsson.net">slides.bjarni-gunnarsson.net</a> &nbsp;·&nbsp; downloads: <a href="https://bjarni-gunnarsson.net/pma">bjarni-gunnarsson.net/pma</a></span>

---

# Topics: Programming

<div class="topics">
Class 01, <b>Introduction</b><br>
Class 02, <b>Syntax</b><br>
Class 03, <b>Control Flow</b><br>
Class 04, <b>Functions</b><br>
Class 05, <b>Data Structures</b><br>
Class 06, <b>Approaches</b><br>
Class 07, <b>Exercises</b><br>
Class 08, <b>Routines</b>
</div>

<span class="note">Assignment 1, 30%</span>

---

# Topics: Sound and Time

<div class="topics">
Class 09, <b>Synthesis</b><br>
Class 10, <b>Synthesis 2</b><br>
Class 11, <b>Modulation</b><br>
Class 12, <b>Shaping</b><br>
Class 13, <b>Clocks</b><br>
Class 14, <b>Patterns 1</b><br>
Class 15, <b>Patterns 2</b><br>
Class 16, <b>Review</b>
</div>

<span class="note">Assignment 2, 30%</span>

---

# Topics: Systems and Interfaces

<div class="topics">
Class 17, <b>Interfaces</b><br>
Class 18, <b>MIDI and Mapping</b><br>
Class 19, <b>Control</b><br>
Class 20, <b>Effects</b><br>
Class 21, <b>Objects and Classes</b><br>
Class 22, <b>Examples</b><br>
Class 23, <b>More Examples</b><br>
Class 24, <b>Building a System</b><br>
Class 25, <b>Exercises</b>
</div>

<span class="note">Assignment 3, 30%</span>

---
layout: center
class: divider
---

SuperCollider

---

# SuperCollider

An environment for **real-time audio** and **composition**.

It consists of an interpreted, object-oriented **language** and a real-time sound synthesis **server**.

It supports sound synthesis, digital signal processing, algorithmic composition, live electronics and live coding.

It is **open source** and free software, released under the GNU General Public License.

<span class="note">Version 3.14. <a href="https://supercollider.github.io">supercollider.github.io</a></span>

---
class: light
---

# Design Goals

> "To realize sound processes that are different every time they are played."

> "To write pieces in a way that describes a range of possibilities rather than a fixed entity."

> "To facilitate live improvisation by a composer/performer."

<div class="src">(James McCartney, Rethinking the Computer Music Language: SuperCollider, 2002)</div>

---
class: light
---

# Two Programs

<div class="shot"><img src="/figures/sclang-server-000.svg" /></div>


---

# The Language

SC is written in the **language**, which is based on Smalltalk. It builds and sends messages to the synthesis server.

- **Objects** hold data together with the methods that act on that data
- **Classes** describe the attributes and behaviour that objects have in common
- Everything you type is an **expression** that returns a value

<span class="note">The post window is where the language replies.</span>

---

# The Server

The **server** makes the sound.

- **UGens**, unit generators, generate and process audio
- Interconnected UGens are packaged into a **SynthDef** that describes which are used and how they connect
- Sounds that are played or transformed live in **buffers** on the server
- Synths send their audio through **buses**

<span class="note">Compositional logic and scheduling stay in the language: routines, tasks and patterns.</span>

---
layout: center
class: divider
---

Code

---

# A First Sound

A function containing a unit generator, sent `.play`.

```supercollider {*|1-2|4-5|*}
// play with defaults and through a function
{ SinOsc.ar(110) }.play

// with arguments
{ SinOsc.ar(200, 0, 0.5) }.play
```

Important is `Cmd .` It stops everything.

<!--
Boot the server first and let them watch the post window. Then run line 2 and say nothing.
The three arguments in the second one are frequency, phase and amplitude, but do not
explain them yet: the point is only that a thing that made sound took arguments.
-->

---

# Many at Once

The same amount of code but now as as sixteen oscillators. Then twenty, with a frequency and an amplitude variation for each one.

```supercollider {*|1-2|4-13|*}
// Mix with multichannel expansion
{ Mix.new(Blip.ar(Array.series(16, 100, 10), 50, 0.04)) ! 2 }.play

// Random frequencies with .collect
(
{
	var freqs = Array.exprand(20, 100, 5000);
	var sig = freqs.collect({|f|
		SinOsc.ar(f, mul: f.expexp(100, 5000, 0.1, 0.005))
	});
	sig.sum * 0.3 ! 2;
}.play
)
```

---

# An Instrument

A named instrument, sent to the server once, played by name after that.

```supercollider {*|3|4|5|6|11|*}
(

SynthDef(\percSine, {|freq=440, amp=0.2, rel=0.3|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, sig ! 2);
}).add;

)

Synth(\percSine, [\freq, 330])
```

The **arguments** are the parts left open. Everything else is fixed.

---

# A Sequence

The same instrument, played as a stream of events. No scheduling written by hand.

```supercollider {*|2|3|4-5|*}
Pbind(
	\instrument, \percSine,
	\midinote, Pseq([60, 64, 67, 72], inf),
	\dur, 0.25,
	\amp, 0.3
).play;
```

---

# The Code

All four, with the server boot and the stops in the right places, are in *code/Intro.scd* in this class's folder.

- Run it **block by block**, not all at once
- Read the post window every time
- Nothing here is expected to make sense yet

<span class="workshop">- workshop -</span>

<!--
Give them the rest of the session with the file open. The goal is only that SuperCollider is
installed, boots, and makes a sound on every laptop in the room before they leave.
-->

---
class: light
---

# Resources

<div class="topics">
<a href="https://supercollider.github.io/">supercollider.github.io</a> &nbsp;— home, downloads, documentation<br>
<a href="https://sccode.org">sccode.org</a> &nbsp;— code examples<br>
<a href="https://scsynth.org">scsynth.org</a> &nbsp;— the forum, and a friendly one<br>
<a href="https://www.youtube.com/user/elifieldsteel">Eli Fieldsteel</a> &nbsp;— video tutorials<br>
<a href="https://mitpress.mit.edu/books/supercollider-book">The SuperCollider Book</a> &nbsp;— MIT Press
</div>

---
layout: center
class: divider
---

Next

---

# Before Next Class

- **Install SuperCollider** 3.14 and check that it boots and makes a sound
- Open *code/Intro.scd* and run every block once

Next class is **Syntax**: how a line of SuperCollider is put together, and how to read code.
