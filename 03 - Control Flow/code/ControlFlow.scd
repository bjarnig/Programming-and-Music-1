////////////////////////////////////////////////////////////////
//
//                   PMA03 - Control Flow
//
////////////////////////////////////////////////////////////////

Iteration, Conditions, Control Flow.


///////////////////////// Boolean Logic ////////////////////////

// both must be true
1 & 1

// either one is true
(1 == 1) || (1 == 2)

// neither one is true with not operator
not(1 == 2) && not(1 == 3)

// true or false probability
0.3.coin

// equals
1 == 2

// does not equal
1 != 2

// greater then or equal
1 >= 1

// less then or equal
1 <= 2

// .. less then or equal
1 <= 1

// if true, then do first function otherwise do the second
if("a" == "ab", {"it's a!"}, {"it's not a"})

// always true
true.if({"it is true"}, {"it is false"})

// two different options
[true, false].choose.if({"it is true"}, {"it is false"})

// and is also a methods
("sono" == "logy").and("logy" == "logy")

// or is as well
("sono" == "logy").or("sono" == "sono")


///////////////////////// Conditionals /////////////////////////


// only an if clause
if(Date.getDate.second % 2 == 0, a)

// toss a coin for further execution, if and else clauses
if (0.5.coin, {"true it is"}, {"false sometimes"})


// test for further execution
if ( [false, true].choose,
    { "expression was true" },
    { "expression was false" }
)

// switch offers branching for different possibilities
(

var number = [1,2,3].choose;

switch(number,
	1, {"make noise"},
	2, {"insert silence"},
	3, {"asdf"})

)

// case is an assignment way of choosing among various options
(

var i, x, z;
z = [0, 1, 2];
i = z.choose;
x = case
    { i == 1 } { \no }
    { i == 2 } { \wrong }
    { i == 0 } { \true };
x;

)


/////////////////////////// Iteration //////////////////////////

// iterate a list of items and multiplies by ten
do ( [1,2,3,4], {|item, index| (item * 10 + index).postln } )

// do something a number of times
7.do ( { rrand(10,100).postln } )

// goes from 10 to 50 and prints each step
for (10, 50, { arg i; i.postln });

// goes from 10 to 100 by a stepsize of 10
forBy (10, 100, 10,  { arg i; i.postln });

// fill p with random pitches until it has at least 32 ones
p = [];
while ({p.size < 32}, {p = p ++ Array.series(rrand(2, 4), 64.rand, 1)});
p

// repeat a pattern and ask for its next 32 values
x = Prand([10, 12]).loop.asStream;
x.nextN(32);

// loop using a routine and yield
~routine = {
	loop {
		(degree: 10.rand, dur: 0.5, amp: 0.1.rand).play;
		0.05.rand.wait;
	}
};

~routine.fork;
~routine.stop;


//////////////// Brackets, Braces, and Parentheses /////////////

// empty array
a = []

// array with integers
b = [0, 1]

// function for calculating 2 + 4
f = { 2 + 4 }

// function with arguments
g = {arg number; number * 2 }
g.value(8)

// empty event
e = ()
e.play

s

// event with duration and pitch
m = (\dur: 2, \midinote: 24)
m.play

// code block
(

x = 2 + 4.rand;
y = 8 + 16.rand;
x + y

)

