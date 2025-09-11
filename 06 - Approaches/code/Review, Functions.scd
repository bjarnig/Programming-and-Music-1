////////////////////////////////////////////////////////////////
//
//              (Review) Functions
//
////////////////////////////////////////////////////////////////


Functions, Arguments, Scope and Closures. Iteration, Conditions,
Creating behavior and Executing Tasks.


////////////////////////// Functions ///////////////////////////


// simple function
a = { 'I am a function' }

a.value

// simple function with name
(

var myFunction;

myFunction = {10 * 2};

myFunction.value.postln;

)

// function with arguments, variables and calculation
f = { |a, b|  var c;   c = a * b; c * 2 }

f.value(1, 2)

// empty funcion
{ 6; 8 }.value

// function that returns a calculated value
{ 1 + 1 }.value

// function causes side-effects
n = 4
f = { n = 8 }
f.value
n


// display the translated byte code for a function
~function = { 2 + 4 }
~function.def.dumpByteCodes




////////////////////////// Arguments ///////////////////////////

// function with arguments
f = {arg a,b; a.pow(b)}

f.value(5,3)


// function with arguments using vertical bars (pipe style)
~combineNames = {|first, second| "The composers name is" + first + second}


~combineNames.value("Giacinto", "Scelsi")


// function with an unknown number of arguments
f = {|... numbers| numbers.sum }
f.value(1,2,3)


// function with default arguments and arg keyword
~omlette = {|eggs=4, cheese=0.5, butter=1, ham=2|
eggs * cheese * butter * ham}
~omlette.value(ham: 4)


// function where the default value is an expression
{ |rand = (10.rand)| "Random number is" + rand }.value




///////////////////// Functional Notation //////////////////////

// receiver notation
440.cpsmidi
440.121212.cpsmidi.round


// functional notation
cpsmidi(440)
round(cpsmidi(445))


// random with both
rrand(10,20)
10.rrand(20)


// collect results of 4 calls
x = { 4.rand; }.dup(4);
x.postln;


// another way of calling dup
x = { 4.rand } ! 4;
x.postln;


// functions have methods
f = {"5"}
f.asInt.value




///////////////////// First-Class Functions ////////////////////

// a function can take functions as arguments
~runner = {|job1, job2| job1.value + job2.value }

a = { 2 * 4 }
b = { 1 + 1 }

~runner.value(a,b)


// functions can return functions
~factory = {|name| { "Hello" + name + "today is" + Date.getDate } }
~day = ~factory.value("Karlheinz");
~day.value;


// appending a method to a function
f = { 1 + 2 }
f.addUniqueMethod(\augmented, { 2 + 4 })
f.value
f.augmented


// the structure of a function can be inspected
~myFunction = { 3 + 6 }
~myFunction.def.sourceCode




/////////////////// Asynchronous Functions /////////////////////

// callback pattern executes an incoming function once it is done
f = {|callback| "I shout".postln; "and then".postln; callback.value}
f.value({"callback executes"})

s.makeGui

// boot server, load buffer and callback gets executed once done
Server.default.boot
(

Buffer.read(path: Platform.resourceDir +/+ "sounds/a11wlk01.wav",
	action: { | buffer | "Buffer has now been loaded".postln; buffer.postln });

"Why does this display first ?".postln;

)




//////////////////////////// Scope and Closures /////////////////////////////

// variable scope is local to the function block they are declared in
~fa = { var test = 2; test }

~fb = {|input| var number = 4; number * input}  // won't work!

~fb.value(~fa.value)

a = 8

// a can be used both as a local and global variable at the same time
a = a
~local = { var a = 1; a * 2 }
~local.value
a.value


// child functions have access to mother functions through closures
~mother = { var number = 4, child = { number.postln }; child.value }
~mother.value


// why does the following not run ? try changing the calculate function
(

f = {
var one, two, test, calculate;
	one = 1;
	two = 2;
	test = { var three = 3; three = three * two };
	calculate = { three * two };
};

f.value.value;

)


// closures can simulate objects, here for information hiding
~functionObject = {|password|
	var secret = "secret is hidden";

	{ if(password == "sonology",
	{ secret }, { "wrong password!"}) }.value;
}

~functionObject.value("sonology")




///////////////////////// Decomposition ////////////////////////

// a code for a melody all in one function
(

~myLongPiece = {
var pitches, durations;

	pitches = [60, 64];
	pitches = pitches ++ (pitches * 2);
	pitches = pitches ++ (pitches * 0.5);

	durations = [0.5, 0.2];
	durations = durations ++ (durations * 4);
	durations = durations ++ (durations * 0.2);
	durations.postln;

	Pbind(
		\midinote, Pseq(pitches, inf),
		\dur, Pseq(durations, inf)
	).play
};

~myLongPiece.value;

)

// decomposing the code using functions
(

~add = {|list, amount| list ++ (list * amount) };

~player = {|pitches, durations|
	Pbind(
		\midinote, Pseq(pitches, inf),
		\dur, Pseq(durations, inf)
).play };

~myShortPiece = {
	~player.value(
		~add.value(~add.value([60, 64], 1.2), 0.5),
		~add.value(~add.value([0.5, 0.2], 4), 0.2))
}.value;

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


// fille p with random pitches until it has at least 32 ones
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
