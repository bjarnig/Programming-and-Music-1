////////////////////////////////////////////////////////////////
//
//                           Syntax
//
////////////////////////////////////////////////////////////////

Syntax, Objects, Arguments, Statements, Expression, Variables,
Declarations, Assignments, Operators, Literals, Comments.


////////////////////////// Objects /////////////////////////////

// creation using new
p = Point.new(1, 2)

// creation using a class method
d = Date.getDate

// fixed object slot creation with 'new' omitted
e = Env([0,1], [1])

// dynamic object slot
a = [1,2, "this is an array"]

// r is a rectangle, top an instance variable and moveTo a method.
r = Rect(2, 4, 6, 8)
r.top
r.moveTo(10, 12)

// messages are used to interact with an object
"this is a string".scramble

// messages can be chained
"reverse it and convert to upper".toUpper.reverse

// major is a class method, degrees an instance method
m = Scale.major()
m.degrees()


////////////////////////// Arguments ///////////////////////////

// no arguments specified
{ SinOsc.ar }.play

// all arguments specified
{ SinOsc.ar(200, 0, 1, 0) }.play

// only freq and mul specified using argument keywords
{ SinOsc.ar(freq: 200, mul: 0.1) }.play

// specify multiple arguments to a method separated by a comma
Array.series(10, 5, 2)

// use * to send a list of arguments to be split to values
Array.series(*[10, 5, 2])

// omit parentheses if the only message is a function
10.do({'programming'.postln})
10.do{'programming'.postln}


////////////////// Expressions & Statements ////////////////////

// simple expression
2 * 4

// expression with strings
"sono" ++ "logy"

// simple statement
["composing", "music"].choose

// assignment statement
x = [1, 2, 3, 4].rotate(1);

// if statement
if(1.0.rand >= 0.5 ) {"0.5 or higher"} {"lower than 0.5"}


////////////////// Variables & Assignments /////////////////////

// x is an instance variable of point
Point(1, 2).x

// all is a class variable of OSCresponder
OSCresponder.all

// environment variable
~myNumber = 666

// displays all environment variables
currentEnvironment

// interpreter variables (26 a-z defined)
a = "some outside-class string variable"

// the object running the current code
this

// all instances used in the current interpreter.
this.dump

// current running method
thisMethod

// current running thread
thisThread

// single assignment
c = 2 + 4;

// multiple assignments, assign a=1, b=2, c=3
# a, b, c = [1, 2, 3, 4, 5, 6];

// multiple assignments, assign a=1, b=2, c = [3, 4, 5, 6]
# a, b ... c = [1, 2, 3, 4, 5, 6];

// series assignment, with start and end values
a = (0..10);

// series assignment, with start, increment and end values
a = (0,2..64);

// value variables
a = 1
a
b = a
b
a = 2
a
b

// reference variables
c = Ref.new
d = c
c.value = 12
d


////////////////////// Operators & Comments ////////////////////

// binary operators take a left and right operand
[1,2] + [3,4]

// ++ joins two sequencable collections
[1,2] ++ [3,4]

// first the calculation then as string
((1 + 2).asString)

// two strings combined
("1" ++ "2")

// as string then combined
(1.asString ++ 2.asString)

// calculation then to string
"1+2".interpret

// "" equals as string
(1.asString ++ "+2").interpret

// parentheses can force precedence
1 + (2 * 2)

// unary operators operate on one value only
n = 0.666
n.ceil
n.floor

// unary inversion operator
0.444.neg

// clip by a minimum threshold
(1.0.rand).min(0.8)

// Comments can be single or multi lines

// single line comment

/*
    multi
    line
    comment
*/


/////////////////////// Literals and Types /////////////////////

// a float
a = 1.2
a.class

// a character
c = $c
c.class

// a string
s = "don't use s, it's for the server!"
s.class

// a symbol
l = \l
l.class

// it's true
t = True
t.class

// literal array
a = #["array", "that", "can't", "be", "changed"]

// for possible messages send dumpInterface
Array.dumpInterface

// for inspection use .class, .dump, isKindOf
a = 'something'
b = "anything"

a.class
b.dump
a.isKindOf(Symbol)