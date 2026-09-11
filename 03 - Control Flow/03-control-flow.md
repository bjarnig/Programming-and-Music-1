---
theme: seriph
addons:
  - ./shared
title: Programming and Music 1 — 03 Control Flow
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

<div class="deck-title">Control Flow</div>

<div class="sub">
  Programming and Music 1
  <a href="https://www.bjarni-gunnarsson.net">https://www.bjarni-gunnarsson.net</a>
</div>

<!--
The class the whole course turns on. By the end of it a single line has to make a hundred
sounds, or the leverage argument stays theoretical for another two weeks.
-->

---
class: light
---

# Control Flow

Control flow is the **order** in which statements are evaluated while a program runs, and the statements that decide that order.

> "We should do our utmost best to shorten the conceptual gap between the static program and the dynamic process, to make the correspondence between the program (spread out in text space) and the process (spread out in time) as trivial as possible."

<div class="src">(Edsger W. Dijkstra, Go To Statement Considered Harmful, Communications of the ACM, 1968)</div>

<!--
Dijkstra's letter is the origin of the whole subject, and this sentence is the reason the
class exists: what you write is laid out in space, what happens is laid out in time, and
the job of if, do and while is to keep those two as close together as possible.
-->

---

# Boolean Expressions

A **boolean expression** is an expression that results in a boolean value, that is, in a value of either **`true`** or **`false`**.

Complex boolean expressions can be built out of simple ones, using the boolean operators:

- **`&&`** and, true if and only if both sides are true
- **`||`** or, true if either side is true, or if both are
- **`not`** changes true to false, and false to true

Parentheses can be used for grouping the parts of complex boolean expressions.

---

# Boolean Evaluations

Arithmetic tests that can be used to create boolean values. These compare two or more objects, and the evaluation returns a boolean value used for program logic.

- **`<`** less than
- **`<=`** less than or equal to
- **`==`** equal to
- **`!=`** not equal to
- **`>=`** greater than or equal to
- **`>`** greater than

<span class="note">One equals sign assigns. Two compare. This is the second most common early mistake.</span>

---
class: light
---

# Truth Tables

<div class="shot"><img src="/figures/truth-000.svg" /></div>

<!--
Read the tables out loud rather than explaining them. And is strict, or is generous. The
whole of program logic is these three, combined and nested.
-->

---

# Boolean Logic

Every one of these evaluates to `true` or `false`.

```supercollider {*|1-2|4-5|7-8|10-11|13-14|*}
// either one is true
(1 == 1) || (1 == 2)

// neither one is true, with the not operator
not(1 == 2) && not(1 == 3)

// does not equal
1 != 2

// true or false, with a probability
0.3.coin

// and is also a method, so it can be written the other way round
("sono" == "logy").or("sono" == "sono")
```

<!--
0.3.coin is the one they will use. Run it ten times and let them see it is not a rule but
a tendency. It comes back in class 14 as the whole basis of Pwrand.
-->

---

# Conditionals

**Conditional** statements are used to test values and perform different actions depending on the result of the test.

The test condition must result in a boolean expression, with only an option of **`true`** or **`false`** checked for in the test.

The most commonly used conditional is the **`if`** statement, which tests an input, and if it passes the test an action is executed.

---

# If

The `if` statement usually has an **`else`** branch, which specifies actions to take if the test fails.

Related conditionals are **`switch`** and **`case`**, which offer many branches, as well as those used for iteration on collections, **`while`** and **`for`**.

---
class: light
---

# If and Else

<div class="shot"><img src="/figures/ifelse-000.svg" /></div>

<!--
The part beginners miss: both branches are functions, and only one of them ever runs. The
whole if returns the value of whichever ran, which is why you can assign it to a variable.
-->

---

# Conditionals

The test comes first, followed by the two functions.

```supercollider {*|1-2|4-8|10-11|*}
// toss a coin, then an if and an else clause
if(0.5.coin, { "true it is" }, { "false sometimes" })

// the same thing, testing a choice from a list
if([false, true].choose,
    { "expression was true" },
    { "expression was false" }
)

// an if with no else, so nothing happens when the test fails
if(Date.getDate.second % 2 == 0, { "an even second".postln })
```

<span class="note">Both branches are functions in braces. Only one of them runs.</span>

---

# Switch and Case

`switch` and `case` provide more than two branches without nesting `if` statements.

```supercollider {*|1-6|8-15|*}
// switch offers branching for different possibilities
(
var number = [1, 2, 3].choose;
switch(number,
    1, { "make noise" },
    2, { "insert silence" },
    3, { "do something else" })
)

// case tests each condition in turn and returns the first match
(
var i = [0, 1, 2].choose;
case
    { i == 1 } { \no }
    { i == 2 } { \wrong }
    { i == 0 } { \true };
)
```

<!--
switch matches a value; case evaluates tests. Students reach for nested ifs first and end
up with something unreadable, so show the alternative early even if they ignore it.
-->

---

# Brackets, Braces, and Parentheses

SuperCollider uses brackets, braces and parentheses in its language syntax.

**Brackets** `[ ]` are used to define arrays of objects, or literals.

**Braces** `{ }` are used to define function or class bodies.

**Parentheses** `( )` are used to express events, separate expressions, or define function argument lists.

---
class: light
---

# Bracket Types

<div class="shot"><img src="/figures/brackets-000.svg" /></div>

<!--
Worth putting up whenever someone is stuck for the rest of the year. Nine times out of ten
a confusing error is the wrong one of these three.
-->

---

# Brackets, Braces, and Parentheses

Each bracket type, and what it produces.

```supercollider {*|1-2|4-5|7-9|11-13|*}
// brackets make an array
b = [0, 1, 2, 3];

// braces make a function, which does not run until asked
g = { |number| number * 2 };
g.value(8)

// parentheses make an event, which knows how to play itself
m = (\dur: 2, \midinote: 24);
m.play

// and parentheses also group a block, run with command-enter
(
x = 2 + 4.rand;
y = 8 + 16.rand;
x + y
)
```

---

# Iteration

When a task or function has to be executed repeatedly, an **iteration** is applied.

An example of an iteration is a **loop**. A loop is when a sequence of statements is specified once, but may be carried out several times in succession with changing variables.

Iteration is often performed up to a **condition**, where it iterates until the condition is met.

Iteration coupled with conditions attributes to the control flow of a program.

---

# Iteration

In SuperCollider, iteration can be executed in various ways:

- **`do`** execute a number of times, or iterate a collection
- **`for`** go from a start to an end count and execute a function
- **`forBy`** like `for`, but with a variable step size
- **`while`** execute while a certain test condition holds
- **`loop`** a function method that loops that function
- **`repeat`** repeats an object call a number of times

<span class="note">Additionally the collection objects have their own iteration methods, which class 05 is about.</span>

---
class: light
---

# Loop Process

<div class="shot"><img src="/figures/loop-000.svg" /></div>

<!--
Three parts and no more: a test, a body, a way back. Every loop in the list is this picture
with a different way of writing the test.
-->

---

# do, for and forBy

The counter is passed to the function as an argument, so each pass differs.

```supercollider {*|1-2|4-5|7-8|10-11|*}
// do something a number of times
7.do({ rrand(10, 100).postln })

// iterate a list, with the item and its index
do([1, 2, 3, 4], { |item, index| (item * 10 + index).postln })

// go from 10 to 50 and print each step
for(10, 50, { arg i; i.postln })

// go from 10 to 100 with a step size of 10
forBy(10, 100, 10, { arg i; i.postln })
```

<span class="q">Where does `i` come from, given that it is never declared?</span>

<!--
The answer to the question: the loop passes it in as an argument, exactly like any other
function argument from last week. That connection is the whole point of asking.
-->

---

# while

Sometimes the count is not known in advance, only the condition to stop.

```supercollider {*|1-3|5-7|*}
// fill p with random pitches until it has at least 32
p = [];
while({ p.size < 32 }, { p = p ++ Array.series(rrand(2, 4), 64.rand, 1) });

// repeat a pattern and ask it for its next 32 values
x = Prand([10, 12]).loop.asStream;
x.nextN(32)
```

<span class="note">A `while` whose condition never becomes false will hang SuperCollider. Write the exit before you write the body.</span>

---

# Iteration and Sound

Loops allow for dynamic behaviour.

```supercollider {*|1-2|4-5|*}
// a hundred grains, none of them typed out
100.do({ Synth(\ping, [\freq, exprand(200, 4000), \amp, 0.03]) })

// and the same loop, spread out in time
Routine({ 100.do({ |i| Synth(\ping, [\freq, 200 * (i + 1)]); 0.05.wait }) }).play
```

<span class="q">One line was written. Which of the hundred sounds was chosen?</span>

<!--
This is the moment the class exists for. Run it, wait for the reaction, then run it again
with a different range. The instrument is defined in Iteration.scd; play the file from the
top so percSine is already on the server.
-->

---

# do and collect

The loop walks a list, and the list supplies the values.

```supercollider {*|1-2|4-6|8-10|*}
// one note per item, straight through the list
[60, 63, 67, 70].do({ |note| Synth(\ping, [\freq, note.midicps]) })

// the index shapes the sound as well as the pitch
[60, 63, 67, 70].do({ |note, i|
    Synth(\ping, [\freq, note.midicps, \amp, 0.1 / (i + 1)])
})

// collect returns a new list rather than discarding the results
~freqs = [60, 63, 67, 70].collect({ |note| note.midicps });
~freqs.round(0.1)
```

<span class="note">`do` does not keep results while `collect` keeps them.</span>

---

# Next Steps

- Run *ControlFlow.scd* block by block, and *Iteration.scd* from the top
- Change every number in the hundred-sounds line and listen to what each one does
- Write a loop that never ends, then stop it with `Cmd .`
- Try to write the same thing twice, once with `if` and once with `case`

---
layout: center
class: divider
---

Exercises

---

# Exercises

1. Write a program to find the sum of three numbers, where these numbers can be different each time the program runs.

2. Write a program that calculates which is the largest of three input numbers.

3. Write a program that generates a random number and, based on its value, prints the word **Sonology** that number of times.

4. Write a program that prints out all odd numbers between 10 and 50.

---

# Exercises

5. Write a loop that displays the multiplication table of a given number, from 1 to 9.

6. Write a nested loop that prints a pattern following this logic:

```
1
22
333
4444
```

7. Take exercise 3 and make it play a sound each time instead of printing a word.

<span class="workshop">- workshop -</span>
