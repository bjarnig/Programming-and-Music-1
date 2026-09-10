---
theme: seriph
addons:
  - ./shared
title: Programming and Music 1 — 02 Syntax
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

<div class="deck-title">Syntax</div>

<div class="sub">
  Programming and Music 1
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

---

# Programs and Programming

A program consists of a set of **instructions**.

A computer executes these instructions to complete tasks set out for the program.

New computer operations can be composed by **defining combinations of old operations**.

Defining new operations and combining them to do useful things is what programming is about.

---

# Programs and Programming

Programming is usually aimed at finding ways to solve a **specific problem**.

This includes analysis of the problem, implementation of the solution and testing of the correctness of the program.

Programs are created using **programming languages**.

---

# Programming Languages

A programming language is a formally constructed language used to specify instructions to a computer.

It presents an **abstract model of computation** where issues that are not relevant to the problem domain of the program are excluded.

The better a language is in providing useful **abstractions**, the less one has to worry about the language and can focus more on the task to be accomplished.

---

# Programming Languages

SuperCollider is a **dynamically typed**, single-inheritance, garbage-collected and **object-oriented** language created with musical applications in mind.

<span class="note">Version 3.14. The language is one of two programs; the other is the sound server, which is not the subject today.</span>

---
layout: center
class: divider
---

Programming with SuperCollider

---
class: light
---

# Every Line Has the Same Shape

<div class="shot"><img src="/figures/object-message-000.svg" /></div>

<!--
Draw this once and refer back to it all year. Everything is an object, and the only thing
you ever do is send one a message. Read a line aloud in these words: "four forty, give me
your midicps". The answer is another object, which is why chaining works.
-->

---

# Objects

SuperCollider is a **pure object-oriented** language, meaning all entities inside the program are some kind of objects.

Objects are the basic entities of the language. They bundle **data** and the **methods** that act on that data.

Two basic types exist: objects with a fixed slot of data, and objects with a dynamic slot of data, the **collections**.

Objects belong to a **class**, which is a blueprint of the object. It describes its attributes and methods.

Objects belonging to a class are called **instances** of that class.

---

# Objects

A class can inherit properties and methods from another class, its **superclass**, and then becomes its **subclass**.

To interact with an object one sends it a **message**.

The **receiver** is the one receiving the message. It looks up its own implementation corresponding to the message and then produces a **return value**.

There exist **instance methods** and **class methods**, such as `new`.

<span class="note">Instance methods are the common case in SuperCollider.</span>

---

# Objects

Making one, asking it something, chaining the answer.

```supercollider {*|1-2|4-5|7-9|11-12|*}
// creation using new
p = Point.new(1, 2)

// fixed object slot creation with 'new' omitted
e = Env([0, 1], [1])

// r is a rectangle, top an instance variable and moveTo a method
r = Rect(2, 4, 6, 8)
r.top

// messages can be chained, left to right
"reverse it and convert to upper".toUpper.reverse
```

<!--
Run each line and read the post window. The last one is the argument for the diagram:
toUpper returns a string, so the string can be asked to reverse itself.
-->

---

# Arguments

Messages to objects come with **arguments**. These are either instances of other objects, or literals.

If there are several arguments provided, they are separated by **commas**.

**Default values** can be set so that one does not have to set all arguments each time.

The argument **keyword** can be used to target a specific argument in the list of all possible ones.

---

# Arguments

The same message four ways. Only the third one says what it means.

```supercollider {*|1-2|4-5|7-8|10-11|*}
// no arguments specified
{ SinOsc.ar }.play

// all arguments specified, in order
{ SinOsc.ar(200, 0, 1, 0) }.play

// only freq and mul, named with argument keywords
{ SinOsc.ar(freq: 200, mul: 0.1) }.play

// use * to split a list into separate arguments
Array.series(*[10, 5, 2])
```

<span class="q">Which of these will you still understand in three weeks?</span>

<!--
Keywords are not decoration, they are the difference between code you can read later and
code you cannot. The second line is loud, warn them before running it.
-->

---

# Expressions and Statements

An **expression** consists of values and operators, for example `1 + 2`.

Expressions are evaluated to make calculations and produce a value that is the result of the evaluation.

A **statement** is the smallest standalone element expressing an action to be carried out.

Programs are created by sequences of one or more statements. Statements in SuperCollider are separated by **semicolons**.

---

# Expressions and Statements

```supercollider {*|1-2|4-5|7-8|10-11|*}
// simple expression
2 * 4

// expression with strings
"sono" ++ "logy"

// assignment statement
x = [1, 2, 3, 4].rotate(1);

// an if statement, which is also an expression: it returns a value
if(1.0.rand >= 0.5) { "0.5 or higher" } { "lower than 0.5" }
```

<span class="note">Shift-Enter evaluates one line. Command-Enter evaluates the whole block between the outer parentheses.</span>

---

# Variables

A variable is a **storage location** with an associated **identifier**, containing a value used in a program.

Variable names usually consist of letters, digits and the underscore symbol.

Variables usually contain values, or the result of evaluated expressions.

Variables can be thought of as **boxes with labels**.

---

# Variables

Several variables can be created in one statement.

Variables must be **declared at the beginning** of a function.

An empty variable has the value **`nil`**.

---
class: light
---

# Three Kinds of Box

<div class="shot"><img src="/figures/variables-000.svg" /></div>

<!--
The single-letter interpreter variables are the reason for the joke in the code file: s is
the server, so assigning a string to it breaks everything afterwards. Environment variables
with the tilde are what most student code should use.
-->

---

# Variable Types

Different kinds of variables exist in SuperCollider:

- **Global** variables, available everywhere
- **Function** variables, available within a function
- **Class** variables, available to a class
- **Instance** variables, available within an instance of a class
- **Pseudo** variables, provided by the compiler, such as `this` or `thisProcess`

<span class="note">Reference variables also exist, which reference a variable container.</span>

---

# Assignments

**Single assignment.** The value of an expression on the right hand side is assigned to a variable on the left hand side.

**Multiple assignment.** Assigns the elements of a collection, which is the result of an expression on the right hand side, to a list of variables on the left hand side.

**Series assignment to a list.** A syntax for doing assignments to a range of values in an `ArrayedCollection` or `List`.

---

# Assignments

```supercollider {*|1-2|4-5|7-8|10-11|13-14|*}
// single assignment
c = 2 + 4;

// environment variable, shared while SuperCollider runs
~myNumber = 666;

// multiple assignment, a is 1, b is 2, c is 3
# a, b, c = [1, 2, 3, 4, 5, 6];

// the rest of the list can go into the last one
# a, b ... c = [1, 2, 3, 4, 5, 6];

// series assignment, with start, increment and end
a = (0, 2 .. 64);
```

<!--
The last one is worth dwelling on: it is thirty-three numbers written in nine characters,
and it is the first hint of what class 03 is about.
-->

---

# Operators

An **operator** is a program element that is applied to one or more **operands** in an expression or statement.

Operators that take one operand, such as the inversion operator `neg`, are referred to as **unary** operators.

Operators that take two operands, such as the arithmetic operators, are referred to as **binary** operators.

---

# Operators

Operator **precedence** is determined by order and parentheses.

SuperCollider supports **operator overloading**.

Operators can thus be applied to a variety of different objects, for example numbers, UGens and collections.

<span class="q">What should adding one array to another mean? SuperCollider has an answer, and it is worth disagreeing with.</span>

---

# Comments

To describe code it is helpful to write **comments**, so that when one reads it again, all explanation and detail is available and easy to grasp.

SuperCollider supports **single line** and **multiline** comments.

<span class="note">A comment explaining what the code already says is noise. A comment explaining why you chose this and not the obvious alternative is worth keeping.</span>

---

# Operators and Comments

The same operator, applied to three different kinds of thing.

```supercollider {*|1-2|4-5|7-8|10-11|13-14|*}
// two numbers
1 + 2

// two arrays, added element by element
[1, 2] + [3, 4]

// ++ joins rather than adds
[1, 2] ++ [3, 4]

// precedence: there is no times-before-plus rule, so use parentheses
1 + (2 * 2)

// unary operators take one value only
0.444.neg
```

<span class="note">Left to right, unless parentheses say otherwise. This catches everyone once.</span>

---

# Literals

Every value in SuperCollider has a specific object **type**.

A type determines what operations can be applied to the value.

SuperCollider is **dynamically typed**, so variable types are usually determined during run time.

Values having a direct syntactic representation are named **literals**.

---

# Literals

The following literals exist:

- **Integers**, `8`, `-1`, `666`
- **Floats**, `0.25`, `-25.89`
- **Strings**, `"Hello Sonology"`
- **Symbols**, `\lecture` or `'lecture'`
- **Characters**, `$a`
- **Special**, `true`, `false`, `nil`
- **Literal arrays**, `#[1, 2, 'abc', "def", 4]`

---

# Type Introspection

Where the type of an object is unknown, **introspection** can be used to determine the type, or which operations it supports.

This matters when objects with an unknown type are handled, since the program can use the introspection to reason about how to treat a specific instance.

In SuperCollider it is possible to query an object about its **class**, its **methods**, and whether it is an instance of a specific class.

---

# Literals and Types

Ask anything what it is. The answer is always a class.

```supercollider {*|1-2|4-5|7-8|10-12|*}
// a float
1.2.class

// a symbol is not a string, and this catches everyone
'something'.class

// a literal array, which cannot be changed
#["array", "that", "cannot", "be", "changed"]

// for inspection use class, dump and isKindOf
"anything".dump;
'something'.isKindOf(Symbol)
```

<!--
Symbol against String is the single most common early confusion, because they look alike
and behave differently. \freq is a symbol; "freq" is a string; Pbind wants the symbol.
-->

---

# Syntax That Makes a Sound

Everything so far, in four lines that do something.

```supercollider {*|1-2|4-5|7-8|10-11|*}
// a literal array of midi notes, converted to frequencies
[60, 64, 67, 72].midicps

// an environment variable holding a function
~tone = { |freq = 440| SinOsc.ar(freq, 0, 0.1) ! 2 };

// arguments by keyword, and the function is played
~voice = ~tone.play;

// a message to the running sound, and a message to stop it
~voice.release(2);
```

<span class="note">Four lines, and every idea from this class is in them: literals, messages, arguments, variables.</span>

<!--
Worth ending on. Ask them to name the receiver, the message and the arguments in each line
before you run it. This is also the first time this class makes a sound.
-->

---

# Next Steps

Download the code for the class and try to get a solid understanding of the topics covered so far.

- Execute some expressions and try to store the results in **variables**
- Experiment with different ways of **assigning** variable values
- Try to compose arithmetic using **operators** and values
- Experiment with operator **precedence** using parentheses

<span class="note">The two code files are *Syntax.scd* and *Basics.scd*, with the sounding examples in *Examples.scd*.</span>

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Create the string **"Programming and Music"**. It should be composed by adding together three variables, where each one contains one of the words.

2. Create an array using `Array.series` that goes from 1 to 10 and then from 10 to 1. Finally multiply the array by 2.

3. Calculate a multiplication, for example 2 times 4, and print the result to the post window. Store the result in a variable.

4. Create an array that contains the date of today, the date of tomorrow, and the number of lessons you have each day.

<span class="workshop">- workshop -</span>
