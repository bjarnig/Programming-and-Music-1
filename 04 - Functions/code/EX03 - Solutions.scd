////////////////////////////////////////////////////////////////
//
//                       EX03 - Solutions
//
////////////////////////////////////////////////////////////////

/* 1. Write a program to find the sum of three numbers,
where these numbers can be different each time the program runs. */

(

~sumNumbers = {|a,b,c| a + b + c; };

~sumNumbers.value(1,2,3)

)

// or using an array
(

~sumList = {|list| list.sum};
~sumList.value([1,2,3,6,9])

)

/* 2. Write a programs that calculates which
is the largest of three input numbers. */

(

~largestOfThree = {|a,b,c,cd|
	var largest;

	if((a > b) && (a > c), { largest = a });
	if((b > a) && (b > c), { largest = b });
	if((c > a) && (c > b), { largest = c });

	largest;
};

~largestOfThree.value(1,2,3,4,5)

)

(

~largestOfThreeIterate = {|list|
	var largest = 0;
	list.do{|item,index|	index.postln; if(item > largest, { largest = item})};
	largest
};

~largestOfThreeIterate.value(Array.rand(120,1,100))

)



/* 3. Write a program that generates a random number and based on its value prints the value number of times the word ‘Sonology’. */

(

~rand = {
	var text = "Sonology", number = rrand(5,10);
  var finalValue;

	number.do {|number|
		(number + text).postln;
	}

};

~rand.value;

)


/* 4.Write a program that prints out all odd numbers between 10 and 50 */

(

forBy (10, 48, 2,  { arg i; (i+1).postln });

)


/* 5.Write a loop that displays the multiplication table of a given number from 1 to 9. */

(

~multiplicationTable = {|number=2|

	10.do{|i|
		(i + "times" + number + "equals" + (i * number)).postln;
	}
};

~multiplicationTable.value(3)

)



/* 6.Write a nested loop that will print a pattern that follows the logic:

1
22
333
4444

*/

(

4.do {|outer|
	var text = "";

	outer = outer + 1;

	outer.do {|inner|
		text = text ++ outer;
	};

	text.postln;
}

)
