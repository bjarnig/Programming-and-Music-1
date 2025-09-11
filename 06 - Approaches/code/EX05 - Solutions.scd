////////////////////////////////////////////////////////////////
//
//                       EX06 - Solutions
//
////////////////////////////////////////////////////////////////


/* 1. Create an array that contains random numbers. Then iterate the
array and compare it item by item and finally print the largest number
found and the index it was found at. */

(

var maxItem = -1, numbers = Array.rand(12, 2, 20);

numbers.do {|number| if(number > maxItem, {maxItem = number})  };

("Numbers:" + numbers).postln;
("Max item found:" + maxItem).postln;

)

/* 2. Implement a function that generates an array that consists of
frequency numbers between 100 and 1000 Hz and and octave up transposed
version of those numbers. */
(

var frequencies = [100, 1000];
var octaveUp = {|input| input ++ ( input * 2 ) };
octaveUp.(frequencies);

)

/* 3. Implement a function that generates an array filled with a variable
amount of odd numbers only. */
(

var fill = {|amount|  Array.fill(amount, {
	var number = 100.rand;
	if(number.odd, { number }, { number + 1 })
}) };
fill.(10);

)

/* 4. Implement a function that generates a variable amounts of array containing
random numbers. */
(

var generateArrays = {|amount, minSize=2,maxSize=8,minVal=10,maxVal=20|
	var output = Array.new(amount);

	amount.do {
		output.add(Array.rand(rrand(minSize, maxSize),minVal, maxVal));
	};

	output;
};

generateArrays.(10);

)

/* 5. Implement a function that fills a dictionary with a scale of pitches. Write another one
that iterates the dictionary and retrieves only odd number pitches.  */
(

var pitches = Dictionary(8), oddPitches = Array.new(8);

( 60 + Scale.major.semitones).do {|item, index|
	pitches.put(index, item.asInteger);
};

pitches.postln;
pitches.values.do {|item|
	if(item.odd, { oddPitches.add(item) })
};

oddPitches

)
