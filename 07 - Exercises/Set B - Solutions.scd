////////////////////////////////////////////////////////////////
//
//                       Set B - Solutions
//
////////////////////////////////////////////////////////////////

/* 1. Write a function that takes an array of numbers and returns
   a dictionary containing statistics about the array: the sum,
   average, minimum, maximum, and count of even and odd numbers. */

(
~arrayStatistics = {|numbers|
    var stats = Dictionary.new;
    var evenCount = 0;
    var oddCount = 0;

    numbers.do({|n|
        if(n.even, {
            evenCount = evenCount + 1;
        }, {
            oddCount = oddCount + 1;
        });
    });

    stats.put(\sum, numbers.sum);
    stats.put(\average, numbers.sum / numbers.size);
    stats.put(\min, numbers.minItem);
    stats.put(\max, numbers.maxItem);
    stats.put(\evenCount, evenCount);
    stats.put(\oddCount, oddCount);
    stats.put(\total, numbers.size);

    stats;
};

~arrayStatistics.value([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
)


/* 2. Write a function that takes a string and returns a new string
   where each word is reversed but the word order remains the same.
   For example, "composing with sound" becomes "gnisopmoc htiw dnuos".
*/


(
~reverseWords = {|text|
    var words = text.split($ );
    var reversedWords = [];
    var result = "";

    words.do({|word|
        var reversed = "";
        word.do({|char|
            reversed = char ++ reversed;
        });
        reversedWords = reversedWords.add(reversed);
    });

    reversedWords.do({|word, i|
        result = result + word;
    });

    result;
};

~reverseWords.value("programming and music");
~reverseWords.value("composing with sound asdf asdfasdf");
)

/* 3. Write a program that generates two arrays of random numbers,
   then creates a new array containing all numbers that appear in
   both arrays (the intersection), without duplicates. */

(
var arr1 = Array.rand(10, 1, 20);
var arr2 = Array.rand(10, 1, 20);
var intersection = [];
var seen = Set.new;

("Array 1: " ++ arr1).postln;
("Array 2: " ++ arr2).postln;

arr1.do({|num|
	if((arr2.includes(num)) && ( seen.includes(num).not ), {
        intersection = intersection.add(num);
        seen.add(num);
    });
});

("Intersection: " ++ intersection).postln;
)

/* 4. Write a function that takes a number and prints a multiplication
   table for that number from 1 to 10, formatted nicely with labels
   showing each calculation (e.g., "3 x 5 = 15"). */

(
~multiplicationTable = {|number|
    ("Multiplication table for " ++ number ++ ":").postln;
    "".postln;

    10.do({|i|
        var multiplier = i + 1;
        var result = number * multiplier;
        (number.asString ++ " x " ++ multiplier.asString ++ " = " ++ result.asString).postln;
    });
};

~multiplicationTable.value(7);
)

/* 5. Write a function that takes an array of strings and returns
   a dictionary where keys are the strings and values are arrays
   containing the length of the string and the count of vowels
   in that string. */

(
~stringAnalysis = {|strings|
    var result = Dictionary.new;
    var vowels = "aeiouAEIOU";

    strings.do({|str|
        var vowelCount = 0;

        str.do({|char|
            if(vowels.find(char) != -1, {
                vowelCount = vowelCount + 1;
            });
        });

        result.put(str, [str.size, vowelCount]);
    });

    result;
};

~stringAnalysis.value(["hello", "world", "programming", "music"]);
)

/* 6. Write a function that takes an array of numbers and returns
   a new array where each element is replaced with the sum of all
   previous elements plus itself. For example, [1, 2, 3, 4] becomes
   [1, 3, 6, 10]. */

(
~cumulativeSum = {|numbers|
    var result = [];
    var runningSum = 0;

    numbers.do({|num|
        runningSum = runningSum + num;
        result = result.add(runningSum);
    });

    result;
};

~cumulativeSum.value([1, 2, 3, 4, 5]);
~cumulativeSum.value([10, 20, 30, 40]);
)

/* 7. Write a function that generates a random word of a specified
   length. The function should take a length and an optional character
   set to choose from. If no character set is provided, use lowercase
   letters. Return the generated word as a string. */

(
~generateWord = {|length, chars="abcdefghijklmnopqrstuvwxyz"|
    var word = "";

    length.do({
        word = word ++ chars[chars.size.rand];
    });

    word;
};

~generateWord.value(5);
~generateWord.value(8, "aeiou");
~generateWord.value(10, "0123456789");
)

/* 8. Write a function that takes two arrays of numbers and returns
   a dictionary with keys "common", "only_first", and "only_second"
   containing the numbers that appear in both, only in the first,
   and only in the second array respectively. */

(
~compareArrays = {|arr1, arr2|
    var result = Dictionary.new;
    var common = [];
    var onlyFirst = [];
    var onlySecond = [];
    var seenCommon = Set.new;
    var seenFirst = Set.new;

    arr1.do({|num|
        if(arr2.includes(num) && { seenCommon.includes(num).not }, {
            common = common.add(num);
            seenCommon.add(num);
        });
        if(arr2.includes(num).not && { seenFirst.includes(num).not }, {
            onlyFirst = onlyFirst.add(num);
            seenFirst.add(num);
        });
    });

    arr2.do({|num|
        if(arr1.includes(num).not, {
            onlySecond = onlySecond.add(num);
        });
    });

    result.put(\common, common);
    result.put(\onlyFirst, onlyFirst);
    result.put(\onlySecond, onlySecond);

    result;
};

~compareArrays.value([1, 2, 3, 4, 5], [3, 4, 5, 6, 7]);
)

/* 9. Write a function that takes an array of numbers and returns
   a new array where each number is replaced with "small" if it's
   less than 10, "medium" if it's between 10 and 50, and "large"
   if it's greater than 50. */

(
~categorizeNumbers = {|numbers|
    var result = [];

    numbers.do({|num|
        var category;

        if(num < 10, {
            category = "small";
        }, {
            if(num <= 50, {
                category = "medium";
            }, {
                category = "large";
            });
        });

        result = result.add(category);
    });

    result;
};

~categorizeNumbers.value([5, 15, 25, 35, 55, 75, 3, 100]);
)

/* 10. Write a function that takes a string and returns a formatted
     report showing: the original string, reversed string, character
     count, word count, and a dictionary of all unique characters
     with their counts. */

(
~stringReport = {|text|
    var report = Dictionary.new;
    var reversed = "";
    var words = text.split($ );
    var charCounts = Dictionary.new;

    text.do({|char|
        reversed = char ++ reversed;

        if(charCounts.at(char).isNil, {
            charCounts.put(char, 1);
        }, {
            charCounts.put(char, charCounts.at(char) + 1);
        });
    });

    report.put(\original, text);
    report.put(\reversed, reversed);
    report.put(\charCount, text.size);
    report.put(\wordCount, words.size);
    report.put(\charFrequency, charCounts);

    report;
};

~stringReport.value("hello world");
)

