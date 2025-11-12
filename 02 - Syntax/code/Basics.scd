////////////////////////////////////////////////////////////////
//
//                           Basics
//
////////////////////////////////////////////////////////////////

Basic syntax elements and fundamental language features.

/////////////////////// Play a Sound ///////////////////////////

( // .release

f = { |freq = 60, amp = 0.1|
	Saw.ar(freq, mul: amp) ! 2;
};

)

Date.new(

x = f.play;

x.release(2);

x.free

////////////// Brackets, Braces, and Parentheses //////////////

// Parentheses ( )

// Function calls
SinOsc.ar(440, 0, 0.5)
"hello".postln()

// Grouping expressions
(2 + 3) * 4

// Brackets [ ]

// Creating arrays
[1, 2, 3, 4]
[440, 880, 220]
["hello", "world", 42]

// Array indexing
~myArray = [10, 20, 30];
~myArray[0]  // returns 10

// Braces { }

// Function definition
~myFunc = { |freq| SinOsc.ar(freq, 0, 0.1) };

// UGen graph for synthesis
{ SinOsc.ar(440, 0, 0.5) }.play;

// Control structures
if(true, { "yes".postln }, { "no".postln });

// Multiple statements
{
    var freq = 440;
    SinOsc.ar(freq, 0, 0.2);
}.play;


////////////////////////// Basic Statements ////////////////////

// semicolon to separate statements
"hello".postln; "world".postln

// single line statement (shift-enter)
(1 + 2) * 3

// block statements (command-enter)
(
    x = 10;
    y = 20;
    x + y
)

// simple method calls
5.neg
3.reciprocal
4.sqrt

// method chaining
5.neg.reciprocal.sqrt

// simple arithmetic
1 + 2
3 - 1
4 * 5
8 / 2
7 % 3

// comparison operators
5 > 3
2 < 4
3 == 3
4 != 5
6 >= 6
2 <= 3

{ Wrap.ar(SinOsc.ar(90), LFNoise0.ar(1), LFNoise1.ar(10)) }.play