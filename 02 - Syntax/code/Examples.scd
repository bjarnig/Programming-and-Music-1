////////////////////////////////////////////////////////////////
//
//              Syntax that makes a sound
//
////////////////////////////////////////////////////////////////

/* The examples from the slides, in the order they appear there.
   Syntax.scd and Basics.scd cover the same ground without sound;
   this file is the short version that you can hear. */

s.boot


/////////////////////// Objects and messages ///////////////////

// creation using new
p = Point.new(1, 2)

// fixed object slot creation with 'new' omitted
e = Env([0, 1], [1])

// r is a rectangle, top an instance variable and moveTo a method
r = Rect(2, 4, 6, 8)

r.top

// messages can be chained, left to right
"reverse it and convert to upper".toUpper.reverse


///////////////////////////// Arguments ////////////////////////

// no arguments specified
{ SinOsc.ar }.play

// careful, this one is loud: all arguments specified, in order
{ SinOsc.ar(200, 0, 1, 0) }.play

// only freq and mul, named with argument keywords
{ SinOsc.ar(freq: 200, mul: 0.1) }.play

CmdPeriod.run

// use * to split a list into separate arguments
Array.series(*[10, 5, 2])


///////////////////// Expressions and statements ///////////////

2 * 4

"sono" ++ "logy"

x = [1, 2, 3, 4].rotate(1);

// an if statement, which is also an expression: it returns a value
if(1.0.rand >= 0.5) { "0.5 or higher" } { "lower than 0.5" }


//////////////////////////// Assignments ///////////////////////

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


/////////////////////// Operators and comments /////////////////

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


//////////////////////// Literals and types ////////////////////

1.2.class

// a symbol is not a string, and this catches everyone
'something'.class

// a literal array, which cannot be changed
#["array", "that", "cannot", "be", "changed"]

"anything".dump;

'something'.isKindOf(Symbol)


/////////////////// Four lines that do something ///////////////

// a literal array of midi notes, converted to frequencies
[60, 64, 67, 72].midicps

// an environment variable holding a function
~tone = { |freq = 440| SinOsc.ar(freq, 0, 0.1) ! 2 };

// arguments by keyword, and the function is played
~voice = ~tone.play;

// a message to the running sound, and a message to stop it
~voice.release(2);

CmdPeriod.run
