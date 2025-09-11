////////////////////////////////////////////////////////////////
//
//                      Approaches
//
////////////////////////////////////////////////////////////////

Various language considerations and methods of covered objects.


// Split a string into an array
"Sonology deals with composing the sound itself ".split($ )


// Check the contents of a string
"Sonology".contains("ono")


// Randomize a string
"Sonology".scramble


// Random true or false with probability (70% here for true)
0.7.coin


// Exponential random numbers
exprand(10,100)


// Gauss shaped random numbers (0.4 - 1.6 range (0.2 * 3))
gauss(1.0, 0.2)


// Force random numbers to reproduce with seed
thisThread.randSeed = 666; {rand(10.0)} ! 10;


// Chain methods for processing one after another
reverse(sort(dup({exprand(1, 100)}, 10)))


// Midi number from frequency values
cpsmidi(440)


// Frequency number from midi
60.midicps


// Amplitude to DB conversion
ampdb(3)


// Power of
2.pow(4)


// Map linearly from one range to the other
0.2.linlin(0.0, 1.0, 0.0, 10.0)


// Map from linear range to exponential one
2.linexp(1, 10, 1, 100)


// Returns all the methods of the string class
String.dumpInterface


// Creates a class browser for class properties
Array.browse


// Check if an object has a method
Collection.findMethod('select')


// Check also objects it inherits from
Array.findRespondingMethodFor('select')


// Find the argument names of a method
Collection.findMethod('select').argNames.dump;
