////////////////////////////////////////////////////////////////
//
//                       EX04 - Solutions
//
////////////////////////////////////////////////////////////////

/* 1. Write a function that sums all its input arguments. */

(

var sum = {|numbers| numbers.sum };

sum.([1,2,3]);

)

/* 2. Write a function that composes words based on input letters. This function should then be called repeatedly by a loop to form phrases. */

(

var words = {|letters, count| var word = ""; count.do { word = word ++ letters[letters.size.rand] }; word };
var phrase = {|times=10| var output = ""; times.do { output= output + words.value("alphabet", 10) }; output.postln };
phrase.(5);

)

/* 3. Write a function that takes a scale of notes as input and transposes them by a variable amount. */

(

var notes = 60 + Scale.minor.degrees;

var transpose = {|input, amount| notes + amount };

transpose.(notes, 12);

)


/* 4. Write a function that returns a list of durations where three are input parameters and three are random numbers. */

(

var durations = {|inputs| Array.rand(3, 0.05, 0.2) ++ inputs };

durations.([0.1, 0.15, 0.25]);

)

/* 5. Write a function that returns a different function for generating random numbers based on the input it receives. */

(

var creator = {|type|

	var range = {|min, max| rrand(min, max)};
	var ceiling = {|max| max.rand};

	if(type == "range", { range }, { ceiling })
};

var generator = creator.("range");

generator.(20, 40);

)
