////////////////////////////////////////////////////////////////
//
//                  Exercises, solutions
//
////////////////////////////////////////////////////////////////

// 1
(
~one = "Programming"; ~two = " and "; ~three = "Music";
~one ++ ~two ++ ~three;
)

// 2
(Array.series(10, 1, 1) ++ Array.series(10, 10, -1)) * 2;

// 3
1 + 2 * 3;                 // 9: left to right, no times-before-plus rule
1 + (2 * 3);               // 7
(1 + 2) * 3;               // 9

// 4
(
var a, b, c;
# a, b, c = [10, 20, 30];
a = c;
[a, b, c];
)

// 5
[3.14.class, "abc".class, 'abc'.class, [1, 2].class].do(_.postln);

// 6
Array.series(5, 2, 3);
Array.series(size: 5, start: 2, step: 3);
Array.series(size: 5, start: 2, step: 10);   // step: the gaps widen, the start stays

// 7
(
var x = 2 + 2;
~result = 2 + 2;
)
x;          // nil, the var died with the block
~result;    // 4, an environment variable outlives it

// 8
(
var a = #[60, 64, 67];
a[0] = 62;
)
// ERROR: Primitive '_BasicPut' failed. A literal array is fixed once written.

// 9
441.cpsmidi;            // 69.0393, because 441 is not an equal tempered pitch
441.cpsmidi.midicps;

// 10
(
~tone = { |freq = 440| SinOsc.ar(freq, 0, 0.1) ! 2 };
~freqs = [60, 64, 67, 72].midicps;
~voices = 4.collect { ~tone.play };
4.do { |i| ~voices[i].set(\freq, ~freqs[i]) };
)

~voices.do { |v| v.release(2) };

// 11
(60 + 7).postln.midicps;   // postln returns what it was given, so the chain continues

// 12
Array.series(7, 60, 2).midicps;

// 13
([60, 64, 67] + [0, 0.12, -0.12]).midicps;

// 14
69 + 0.5.midicps;          // 77.42, a frequency added to a note number
(69 + 0.5).midicps;        // 452.89, a quarter-tone above A440

// 15
(
3.14.class;                        // Float
3.14.class.superclass;             // SimpleNumber
3.14.class.superclass.superclass;  // Number
Float.superclass.superclass.superclass;          // Magnitude
Float.superclass.superclass.superclass.superclass;   // Object
)
