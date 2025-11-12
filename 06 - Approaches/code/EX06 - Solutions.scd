
1.Write a program to find the sum of the first natural numbers, where the number of items is provided by the user.

(

var sum=0, numberOfItems = 2;

(numberOfItems + 1).do {|item|

	sum = sum + item;
};

("Total sum is:" + sum);

)

2.Write a program to sum a series of numbers entered by the user and multiply it by a given factor.

(

var numbers = Array.series(3, 1, 1), factor = 4;

numbers.sum * factor

)

3.Write a program that takes as input two lists of numbers and returns a new list containing the largest of each numbers in each array slot.The lists should be the same size.

(

var lista = [3,12,1], listb = [9,1,8], output = Array.newClear(3);

lista.do{|item, index|

	if(item > listb[index], {output[index] = item}, {output[index] = listb[index]})
};

output

)

4.Write a program that reads a sentence and returns an array of numbers where each character in the string is mapped to one of three possible output numbers.

(

var sentance = "Sonology is about composing sounds", output = Array.newClear(sentance.size);

sentance.do {|letter, index|
	output[index] = letter.asString.ascii[0]
};

output

)



5.Write a program that generates a list of note durations where an input parameter specifies how many irregular durations succeed regular ones.

(

var generateDurations = {|irregular=2, regular=4, repeats=2|

	var output = List();

	repeats.do{

		regular.do{
			output.add(1);
		};

		irregular.do{
			output.add(1.0.rand);
		};

	};

	output;
};

generateDurations.();

)

6.Write a program that creates a sentence based on note numbers it takes as input.

(

var mapNumbersToSentence = {|numbers|
	var alphabet = "abc de fg", output = "";

	numbers.do{|number|
		output = output ++ alphabet.wrapAt(number);
	};

	output

};

mapNumbersToSentence.value(Array.series(24, 1, 4))

)



7.Write a program that reads a string and for each character it finds it will create a corresponding random number.A character can only appear once in the output.

(

var string = "Programming is fun!", output = List();

string.do{|letter|
	output.add(letter.asString.ascii[0].rand)
};

output

)

8.Write a program that creates a list of random numbers that appear in a descending order.

(

var numbers = Array.rand(100, 1, 100);
numbers.sort({|a,b| b < a})

)
