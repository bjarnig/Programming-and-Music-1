////////////////////////////////////////////////////////////////
//
//                       Set A - Solutions
//
////////////////////////////////////////////////////////////////

/* 1. Write a function that takes an array of numbers and returns
   a new array containing only the even numbers from the input array. */

(
~getEvenNumbers = {|numbers|
    numbers.select({|n| n.even});
};

~getEvenNumbers.value([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
)

/* 2. Write a function that counts how many times a specific character
   appears in a given string. The function should take a string and
   a character as arguments. */

(
~countCharacter = {|text, char|
    var count = 0;
    text.do({|c|
        if(c.asString == char, { count = count + 1 });
    });
    count;
};

~countCharacter.value("hello world", "l");
)

/* 3. Write a program that generates an array of 10 random numbers
   between 1 and 100, then finds and prints the smallest number
   and its position (index) in the array. */

(
var numbers = Array.rand(10, 1, 100);
var minValue = numbers.minItem;
var minIndex = numbers.indexOf(minValue);

("Numbers: " ++ numbers).postln;
("Smallest number: " ++ minValue).postln;
("Found at index: " ++ minIndex).postln;
)

/* 4. Write a function that takes two arrays of equal length and
   returns a new array where each element is the sum of the
   corresponding elements from the two input arrays. */

(
~addArrays = {|arr1, arr2|
	var result = List();
    arr1.size.do({|i|
        result = result.add(arr1[i] + arr2[i]);
    });
    result;
};

~addArrays.value([1, 2, 3], [4, 5, 6]);
)

/* 5. Write a function that takes a number and returns true if it's
   within a specified range (inclusive), and false otherwise. The
   function should take the number, minimum value, and maximum value
   as arguments. */

(
~isInRange = {|number, min, max|
    (number >= min) && (number <= max);
};

~isInRange.value(5, 1, 10);
~isInRange.value(15, 1, 10);
~isInRange.value(0, 0, 100);
)

/* 6. Write a function that takes a string and returns a dictionary
   where each key is a unique character from the string and each
   value is the count of how many times that character appears. */

(
~countCharacters = {|text|
    var charCount = Dictionary.new;

    text.do({|char|
        if(charCount.at(char).isNil, {
            charCount.put(char, 1);
        }, {
            charCount.put(char, charCount.at(char) + 1);
        });
    });

    charCount;
};

~countCharacters.value("hello");
)

/* 7. Write a program that uses a loop to print all numbers from
   1 to 100, but for multiples of 3 print "Sono", for multiples
   of 5 print "Logy", and for multiples of both 3 and 5 print
   "SonoLogy". */

(
100.do({|i|
    var num = i + 1;
    var output = "";

    if((num % 3) == 0, { output = output ++ "Sono" });
    if((num % 5) == 0, { output = output ++ "Logy" });
    if(output == "", { output = num.asString });

    output.postln;
});
)


/* 8. Write a function that takes an array of numbers and returns
   the average (mean) of all the numbers in the array. */

(
~average = {|numbers|
    var sum = numbers.sum;
    var count = numbers.size;
    sum / count;
};

~average.value([1, 2, 3, 4, 5]);
~average.value([10, 20, 30, 40, 50]);
)

/* 9. Write a function that takes a string and returns a new string
   with all the vowels (a, e, i, o, u) removed, regardless of case. */

(
~removeVowels = {|text|
    var vowels = "aeiouAEIOU";
    var result = "";

    text.do({|char|
        if(vowels.includes(char).not, {
            result = result ++ char;
        });
    });

    result;
};

~removeVowels.value("Composing with Process").postln;
~removeVowels.value("Programming and Music").postln;
)

/* 10. Write a function that generates an array of random numbers.
    The function should take the count (how many numbers) and a range
    (minimum and maximum values) as arguments, then return an array
    of random numbers within that range. */

(
~generateRandomNumbers = {|count, min, max|
    var result = [];
    
    count.do({
        result = result.add(rrand(min, max));
    });
    
    result;
};

~generateRandomNumbers.value(5, 1, 10);
~generateRandomNumbers.value(8, 20, 50);
)

