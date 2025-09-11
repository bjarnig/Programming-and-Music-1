////////////////////////////////////////////////////////////////
//
//                		Object Modeling
//
////////////////////////////////////////////////////////////////

/* Implement a program that is capable of generating text but also
   to print it, and speak.
*/

e = ();

e.generateText = {|ev, n=12| var text = "sound space"; var t = ""; n.do { t = t ++ text.choose }; ev.text = t }
e.generateText.()

e.print = {|ev| ev.text.postln}
e.print.()

e.randomize = {|ev| ev.text.scramble }
e.randomize.()

/* A generative program can help a composer exploring areas that
he would otherwise not be aware of. Write a generative program for
assisting a composer exploring simple patterns where the generated
materials are pitches, durations and dynamics. The program should be
able to generate these according to its private rules.

Additionally the object could play what has been generated to the
composer. */

g = ();
g.pitches = [12, 34];
g.durations = [1,2];
g.dynamics = [10,20];
g.generatePitches = {|ev| ev.pitches = Array.rand(12, 20, 72)}
g.generateDynamics = {|ev| ev.dynamics = Array.rand(12, 0.1, 1.0)}
g.generateDurations = {|ev| ev.durations = Array.rand(12, 0.01, 0.2)}
g.playResult = {|ev|
	Pbind(
		\midinote, Pseq(ev.pitches, inf),
		\dur, Pseq(ev.durations, inf),
		\amp, Pseq(ev.dynamics, inf)
).play  }

g.generateAll = {|ev| ev.generatePitches; ev.generateDurations; ev.generateDynamics; }
g.generateAll
g.playResult


/* Create a simple calculator object that can perform basic mathematical
   operations and store results. The calculator should have methods for
   addition, subtraction, multiplication, division, and memory functions. */

c = ();
c.memory = 0;
c.lastResult = 0;

c.add = {|ev, a, b| 
    ev.lastResult = a + b;
    "Result: ".post; ev.lastResult.postln;
    ev.lastResult;
};

c.subtract = {|ev, a, b| 
    ev.lastResult = a - b;
    "Result: ".post; ev.lastResult.postln;
    ev.lastResult;
};

c.multiply = {|ev, a, b| 
    ev.lastResult = a * b;
    "Result: ".post; ev.lastResult.postln;
    ev.lastResult;
};

c.divide = {|ev, a, b| 
    if(b != 0, {
        ev.lastResult = a / b;
        "Result: ".post; ev.lastResult.postln;
    }, {
        "Error: Division by zero".postln;
        ev.lastResult = 0;
    });
    ev.lastResult;
};

c.store = {|ev, value| ev.memory = value; "Stored: ".post; value.postln; };
c.recall = {|ev| "Memory: ".post; ev.memory.postln; ev.memory; };
c.clear = {|ev| ev.memory = 0; ev.lastResult = 0; "Cleared".postln; };

// Test the calculator
c.add(10, 5);
c.multiply(3, 4);
c.store(c.lastResult);
c.divide(c.recall, 2);
c.clear;


/* Create a text processor object that can manipulate strings in various
   ways. It should have methods for counting words, finding patterns,
   transforming text, and generating random text. */

t = ();
t.text = "";
t.wordCount = 0;
t.charCount = 0;

t.setText = {|ev, str| 
    ev.text = str;
    ev.wordCount = str.split($ ).size;
    ev.charCount = str.size;
    "Text set: ".post; str.postln;
};

t.countWords = {|ev| 
    "Word count: ".post; ev.wordCount.postln;
    ev.wordCount;
};

t.countChars = {|ev| 
    "Character count: ".post; ev.charCount.postln;
    ev.charCount;
};

t.toUpper = {|ev| 
    ev.text = ev.text.toUpper;
    "Uppercase: ".post; ev.text.postln;
    ev.text;
};

t.toLower = {|ev| 
    ev.text = ev.text.toLower;
    "Lowercase: ".post; ev.text.postln;
    ev.text;
};

t.reverse = {|ev| 
    ev.text = ev.text.reverse;
    "Reversed: ".post; ev.text.postln;
    ev.text;
};

t.findPattern = {|ev, pattern| 
    var found = ev.text.find(pattern);
    if(found >= 0, {
        "Pattern found at position: ".post; found.postln;
    }, {
        "Pattern not found".postln;
    });
    found;
};

t.generateRandom = {|ev, length=10| 
    var chars = "abcdefghijklmnopqrstuvwxyz ";
    var result = "";
    length.do { result = result ++ chars[chars.size.rand] };
    ev.setText(result);
    result;
};

t.stats = {|ev| 
    "Text: ".post; ev.text.postln;
    "Words: ".post; ev.wordCount.postln;
    "Characters: ".post; ev.charCount.postln;
};

// Test the text processor
t.setText("Hello World from SuperCollider");
t.stats;
t.toUpper;
t.reverse;
t.findPattern("WORLD");
t.generateRandom(15);
t.stats;
