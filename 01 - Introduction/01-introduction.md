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

<!--
First class. Welcome, who is here, backgrounds. For many of you this is a first
encounter with programming of any kind, and that is the expected starting point.
Run the last code slide of this deck before anything else if the room is awake:
three lines, a hundred sine waves, then come back to the admin.
-->

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

<span class="note">Slides: <a href="https://slides.bjarni-gunnarsson.net">slides.bjarni-gunnarsson.net</a> &nbsp;·&nbsp; downloads: <a href="https://bjarni-gunnarsson.net/pma">bjarni-gunnarsson.net/pma</a> &nbsp;·&nbsp; small browser demos: <a href="https://slides.bjarni-gunnarsson.net/tools/">slides.bjarni-gunnarsson.net/tools</a></span>

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

<!--
Worth reading out. The second goal is the whole reason this course exists: a piece as a
range rather than a fixed entity is a thing you can only write down as a program.
-->

---
class: light
---

# Two Programs

<div class="shot"><img src="/figures/sclang-server-000.svg" /></div>

<!--
The single most useful picture of the year. Two separate programs talking over a network,
even when both are on your laptop. You type in the language; the server makes the sound.
Almost every confusion in the first weeks is really a confusion about which side you are on.
-->

---

# The Language

You write in the **language**, which is based on Smalltalk. It builds and sends messages to the synthesis server.

- **Objects** hold data together with the methods that act on that data
- **Classes** describe the attributes and behaviour that objects have in common
- Everything you type is an **expression** that returns a value

<span class="note">The post window is where the language answers you. Get used to reading it early.</span>

---

# The Server

The **server** makes the sound, and knows nothing about your code.

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

A function containing a unit generator, sent `.play`. That is the whole ceremony.

```supercollider {*|1-2|4-5|*}
// play with defaults and through a function
{ SinOsc.ar(110) }.play

// with arguments
{ SinOsc.ar(200, 0, 0.5) }.play
```

Learn `Cmd .` now. It stops everything, and you will need it in about a minute.

<!--
Boot the server first and let them watch the post window. Then run line 2 and say nothing.
The three arguments in the second one are frequency, phase and amplitude, but do not
explain them yet: the point is only that a thing that made sound took arguments.
-->

---

# Many at Once

The same amount of typing, and now it is sixteen oscillators. Then twenty, with a frequency and an amplitude worked out for each one.

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

<span class="q">Nobody typed twenty frequencies. Where did they come from, and who decided them?</span>

<!--
This is the leverage moment and the reason the course exists. Change the 20 to 100 live
and run it again: the code does not get longer. Do not explain collect yet, class 05 does.
-->

---

# An Instrument

A named instrument, sent to the server once, played by name after that.

```supercollider {*|1|2|3|4|7|*}
SynthDef(\percSine, {|freq=440, amp=0.2, rel=0.3|
	var env = EnvGen.ar(Env.perc(0.01, rel), doneAction: 2);
	var sig = SinOsc.ar(freq) * env * amp;
	Out.ar(0, sig ! 2);
}).add;

Synth(\percSine, [\freq, 330])
```

The **arguments** are the parts you left open. Everything else is decided.

<!--
Point at the two sides of the picture from earlier: the SynthDef is built in the language
and lives on the server. doneAction: 2 is what frees it when the envelope ends, and without
it the server slowly fills with silent synths. Classes 09 and 10 do this properly.
-->

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

Four notes, forever, a quarter of a second apart.

<!--
Change Pseq to Prand and run it again. That single substitution is most of what classes
14 and 15 are about, and it is the point where students usually decide they like this.
-->

---

# A Controller

A knob on a MIDI controller, reaching into a pattern that is already running and rewriting it.

```supercollider {*|1|3-4|6-9|*}
notes = PatternProxy(Pwhite(20, 80));

pattern = Pbind(\midinote, notes, \dur, 0.2).play;

MIDIFunc.cc({|val|
	val.postln;
	notes.source = Pwhite(val/2, val);
})
```

<span class="note">This one needs hardware, so it is a preview rather than an exercise. Classes 17 to 19 are built on it.</span>

<!--
Where the year ends up. The pattern never stops; the knob replaces the source underneath it.
That is the shape assignment 3 asks for.
-->

---

# The Code

All five, with the server boot and the stops in the right places, are in *code/Intro.scd* in this class's folder.

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
<a href="https://www.youtube.com/user/elifieldsteel">Eli Fieldsteel</a> &nbsp;— video tutorials, the best place to start<br>
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
- Bring a pair of **headphones**

Next class is **Syntax**: how a line of SuperCollider is put together, and how to read one you did not write.

<span class="note">Ask for help by email or in class rather than getting stuck for a week. Getting the thing installed is not the interesting part of this course.</span>
