////////////////////////////////////////////////////////////////
//
//                      Strategies
//
////////////////////////////////////////////////////////////////

Programming approaches, problem solving, algorithms, and best practices
for learning and developing with SuperCollider.


////////////////////////// Debugging Techniques //////////////////

// Using postln for debugging
(

~debugExample = {|x, y|
	var result;
    "Starting calculation".postln;
    "x = ".post; x.postln;
    "y = ".post; y.postln;

    result = x * y;
    "Result = ".post; result.postln;

    result;
};

~debugExample.value(5, 3);

)

// Using debug method
(

~debugMethod = {|arr|
    arr.debug("Array contents").collect({|x| x * 2});
};

~debugMethod.value([1, 2, 3, 4]);

)

// Using postcs for collections
(

~collectionDebug = {|dict|
    dict.postcs;  // shows full collection structure
    dict.keys.postln;
    dict.values.postln;
};

~collectionDebug.value((\a: 1, \b: 2, \c: 3));

)

// Using dumpBackTrace ot print the call stack
(

f = { |x|
    g = { |y|
        thisProcess.dumpBackTrace;
        x + y
    };
    g.(3)
};

f.(5);

)

////////////////////////// Code Style Examples //////////////////

// Good: Meaningful variable names
(

~calculateCircleArea = {|radius|
    var p = 3.14159;
    var area = p * radius * radius;
    area;
};

~calculateCircleArea.(5)

)

// Good: Single purpose functions
(

~isEven = {|number| number % 2 == 0};
~isOdd = {|number| number % 2 != 0};

)

// Good: Consistent formatting
(

~processNumbers = {|numbers|
    var evenNumbers, oddNumbers, result;

    evenNumbers = numbers.select({|n| ~isEven.value(n)});
    oddNumbers = numbers.select({|n| ~isOdd.value(n)});

    result = (
        even: evenNumbers,
        odd: oddNumbers,
        total: numbers.size
    );

    result;
};

~processNumbers.value([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

)

// Good: Clear comments
(

~fibonacci = {|n|
    // Base cases
    if(n <= 1, { n }, {
        // Recursive case: F(n) = F(n-1) + F(n-2)
        ~fibonacci.value(n - 1) + ~fibonacci.value(n - 2);
    });
};

~fibonacci.value(10);  // 55

)

// Good: Avoiding deep nesting
(

~validateInput = {|input|
    var isValid = true;
    var errorMessage = "";

    if(input.isNil, {
        isValid = false;
        errorMessage = "Input cannot be nil";
    });

    if(isValid && { input.isNumber.not }, {
        isValid = false;
        errorMessage = "Input must be a number";
    });

    if(isValid && { input < 0 }, {
        isValid = false;
        errorMessage = "Input must be positive";
    });

    (valid: isValid, message: errorMessage);
};

~validateInput.value(5);
~validateInput.value(-3);
~validateInput.value("hello");

)


////////////////////////// Best Practices ////////////////////////

// DRY: Don't repeat yourself
// Bad: Repeated code
(

~badExample = {|arr1, arr2|
    var sum1 = 0, sum2 = 0;
    arr1.do({|x| sum1 = sum1 + x});
    arr2.do({|x| sum2 = sum2 + x});
    [sum1, sum2];
};

)

// Good: Reusable function
(

~sumArray = {|arr| arr.sum};

~goodExample = {|arr1, arr2|
    [~sumArray.value(arr1), ~sumArray.value(arr2)];
};

~goodExample.value([1, 2, 3], [4, 5, 6]);  // [6, 15]

)

// Orthogonality: Independent modules
(

~textProcessor = ();
~textProcessor.countWords = {|text| text.split($ ).size};
~textProcessor.countChars = {|text| text.size};
~textProcessor.reverse = {|text| text.reverse};

~numberProcessor = ();
~numberProcessor.average = {|numbers| numbers.sum / numbers.size};
~numberProcessor.max = {|numbers| numbers.maxItem};
~numberProcessor.min = {|numbers| numbers.minItem};

)

// Reversibility: Easy to change
(

~config = ();
~config.maxRetries = 3;
~config.timeout = 5.0;
~config.debugMode = true;

~robustFunction = {|input|
    var attempts = 0;
    var result = nil;

    while({ result.isNil && { attempts < ~config.maxRetries }}, {
        attempts = attempts + 1;
        "Attempt ".post; attempts.postln;

        // Simulate operation that might fail
        if(0.7.coin, {
            result = input * 2;  // Success
        });
    });

    result;
};

~robustFunction.value(10);

)


////////////////////////// Error Handling ///////////////////////

// Comprehensive error handling
(

~safeDivide = {|a, b|
    var result = ();

    if(a.isNil || b.isNil, {
        result = (success: false, error: "Arguments cannot be nil");
    }, {
        if(b == 0, {
            result = (success: false, error: "Division by zero");
        }, {
            result = (success: true, value: a / b);
        });
    });

    result;
};

~safeDivide.value(10, 2);
~safeDivide.value(10, 0);
~safeDivide.value(nil, 5);

)

// Input validation
(

~validateAndProcess = {|input, processor|
    var validation = ~validateInput.value(input);

    if(validation.valid, {
        var result = processor.value(input);
        (success: true, result: result);
    }, {
        (success: false, error: validation.message);
    });
};

~validateAndProcess.value(5, {|x| x * x});
~validateAndProcess.value(-1, {|x| x * x});
~validateAndProcess.value("hello", {|x| x * x});

)


////////////////////////// Problem Solving //////////////////////

// Sum of first n natural numbers
(

~sumNaturalNumbers = {|n|
    var result = 0;
    n.do({|i| result = result + (i + 1)});
    result;
};

~sumNaturalNumbers.value(10);  // 1+2+3+...+10 = 55

)

// Sum series and multiply by factor
(

~sumAndMultiply = {|numbers, factor|
    var sum = numbers.sum;
    sum * factor;
};

~sumAndMultiply.value([1, 2, 3, 4, 5], 2);  // (1+2+3+4+5) * 2 = 30

)

// Find largest of each pair in two arrays
(

~findLargestPairs = {|arr1, arr2|
    var result = [];
    arr1.size.do({|i|
        result = result.add(arr1[i].max(arr2[i]));
    });
    result;
};

~findLargestPairs.value([1, 5, 3], [2, 1, 4]);  // [2, 5, 4]

)

// Generate irregular durations
(

~generateDurations = {|regular, irregular, count|
    var result = [];
    count.do({|i|
        if(i % (regular + irregular) < regular, {
            result = result.add(1.0);  // regular duration
        }, {
            result = result.add(1.0.rand + 0.5);  // irregular duration
        });
    });
    result;
};

~generateDurations.value(2, 1, 9);  // [1, 1, 0.8, 1, 1, 1.2, 1, 1, 0.9]

)

// Create sentence from note numbers
(

~notesToSentence = {|noteNumbers|
    var words = ["do", "re", "mi", "fa", "sol", "la", "ti"];
    var result = "";
    noteNumbers.do({|note|
        result = result ++ words[note % 7] ++ " ";
    });
    result;
};

~notesToSentence.value([0, 2, 4, 0].scramble);  // "do mi sol do "

)

// Generate descending random numbers
(

~descendingRandom = {|count|
    var result = Array.rand(count, 1, 100);
    result.sort({|a, b| a > b});  // sort in descending order
    result;
};

~descendingRandom.value(5);  // [87, 65, 43, 21, 12]

)
