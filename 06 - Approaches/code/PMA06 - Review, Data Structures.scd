////////////////////////////////////////////////////////////////
//
//              (Review) Data Structures
//
////////////////////////////////////////////////////////////////


Arrays, Lists, Dictionaries and Collections.


/////////////////////////// Arrays /////////////////////////////

// An array
[1,2,3]


// Binary operation
[1, 2, 3] + [3, 4]


// Iterate collections
[1, 2, 3, 4].do({ arg item, i; item.postln });


// Generate series
Array.series(12, 2, 1)
(4 .. 16)
3.series(8,16)


// Random numbers
Array.rand(10, 3, 20)
{ rrand(3, 20) } ! 10


// Geometric series
Array.geom(4,2,6)


// Fill arrays
Array.fill(16, {arg i; i + 64.rand})
~ar = Array.fill(4, {arg i; i + 1 }).reverse


// Array operations
~ar.scramble
~ar.mirror
~ar.pyramid(3)


// Choose a random element
[1,2,3].choose


// Weighted random
[1,2,3].wchoose([0.25,0.10,0.65])


// Normalize an array:
[1,0.5,0.3].normalizeSum


// Create arrays with duplication operator
{ 1.0.rand } ! 5


// Differentiate between array values
[1, 1.5, 2, 4, 0.5].differentiate


// Select from  an array based on a function
[1,2,3].select({|item| item.even})


// Reject items from a list
[1,2,3].reject({|item| item.even})


// Collect items from on array to another with manipulation
[1,2,3].collect({|item| item * 2})


// Extend an array by wraping its content
[1,2,3].wrapExtend(8)


// Check if an array includes items
[1,2,3].includes(3)


// Sort an array
[1,2,3].sort({|a,b| b < a})



/////////////////////// Lists /////////////////////////////

// Similar to array but can grow automatically

a = [1,2,3]
a.add(4) // stops growing after two additions


b = List[1,2,3]
b.add(4) // grows forever


// See available methods
List.dumpFullInterface




/////////////// Dictionary & Event /////////////////

// Add with key and value
d = Dictionary.new;
d.put("abc", 10);
d["abc"]


// Key points to value
(
d = Dictionary.new;
d.add(\monkey -> 0).postln;
d.add(\robot -> 1).postln;
d.add(\monkey -> 2).postln;
)


// Events can also be used as dictionaries
(
e = ();
e[\sonology] = "makes sense";
e[\calculate] = {|input| input * 2};

e[\sonology].reverse.postln;
e[\calculate].(8)

)


// Iterate keys and values
(
d = (\pitch : [60, 68], \durations : [0.1, 0.2]);
d.keysValuesDo { |key, value| postln("key: " ++ key ++ ", value: " ++ value) };
)


// Keys and values can be accessed as arrays
e = ()
e.put(\place, 4)
e.keys.asArray
e.values.asArray




////////////////////// Set /////////////////////////

Set[1,2,3]

a = Set[60, 68, 72, 88, 90, 100];
b = Set[60, 72, 44, 24];

c = union(a, b);
d = difference(a, b);
e = sect(a, b);
