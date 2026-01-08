////////////////////////////////////////////////////////////////
//
//                      EX12 - Solutions
//
////////////////////////////////////////////////////////////////


( // Synth used in some of the examples

SynthDef(\sine, {|note=40, amp=0.2|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2);
	sig = SinOsc.ar(note.midicps) * amp;
	Out.ar(0, sig * env ! 2);

}).add

)

/* 1. Create a process where two clocks are used each in its own routine. These routines should be nested where the parent routine is creating a list of pitches that are used for scheduled synths played by the inner routine. */

(

f = {|notes, dur=0.2, tempo=140|
	Routine({
		notes.do {|note|
			Synth(\sine, [\note, note, \amp, 0.1]);
			dur.wait;
		}
	}).play(TempoClock(tempo/60))
};

r = Routine({
	var pitches;

	inf.do {
		pitches = Array.rand(12, 50, 70);
		pitches.postcs;
		f.(pitches);
		6.wait;
	}
});

r.play(TempoClock(130/60))

)


/* 2. Implement a sequencing process that will play synths with the time between them determined randomly. This process should then be added to an array so that four or more instances of it can run at the same time. */

(

f = {|noteFrom, noteTo, durFrom, durTo| Routine({
	 { Synth(\sine,[\note, rrand(noteFrom, noteTo), \amp, 0.1]);
	   rrand(durFrom, durTo).wait }.loop
      })
};

a = Array.new(4);

a.add(f.(40, 44, 0.8, 1.0));
a.add(f.(50, 54, 0.4, 0.6));
a.add(f.(60, 64, 0.2, 0.3));
a.add(f.(70, 74, 0.1, 0.2));

a.do({|i| i.play})

)

/* 3. Implement a sequencing process with four routines. One routine should be used as a stream and generate pitch values, the second one should generate duration values and the third one amplitude values.These should then be played by the fourth routine, the player that request values from the other and schedules synths. */

(

var pitches = Routine ({ inf.do {  rrand(60, 72).yield } });
var durations = Routine ({ inf.do {  rrand(0.05, 0.2).yield } });
var amplitudes = Routine ({ inf.do {  rrand(0.01, 0.5).yield } });

var sequence = Routine ({

	inf.do {
		var note = pitches.next();
		var dur = durations.next();
		var amp = amplitudes.next();

		Synth(\sine, [\note, note, \amp, amp]);
		dur.wait;
	}

});

sequence.play;

)

/* 4. Create a mini piece with at least three sections and one routine for each one so that the order they are played in could easily be changed later. */

(

a = Routine ({ 8.do { Synth(\sine, [\note, rrand(60, 65), \amp, rrand(0.2, 0.8)]); 0.2.wait; } });
b = Routine ({ 16.do { Synth(\sine, [\note, rrand(80, 85), \amp, rrand(0.02, 0.3)]); 0.05.wait; } });
c = Routine ({ 16.do { Synth(\sine, [\note, rrand(50, 90), \amp, rrand(0.08, 0.4)]); 0.1.wait; } });

Routine({

	a.play;

	4.wait;

	b.play;

	2.wait;

	c.play;

}).play

)

/* 5. Implement a class called sequencer. It should take as inputs three different kind of arrays that will be used for shapes in time (envelopes). One should be used for pitches, another for durations and the third for amplitudes.The sequencer should then offer two different playback methods, fast and slow.These should create envelopes out of the arrays and sequence in time using routines to play synths. */

SequencerX {

	var <>durations, <>amplitudes, <>frequencies;

	*new{|inDurations, inAmplitudes, inFrequencies|
		^super.new.init(inDurations, inAmplitudes, inFrequencies);
	}

	init {|inDurations, inAmplitudes, inFrequencies|
		this.durations = inDurations;
		this.amplitudes = inAmplitudes;
		this.frequencies = inFrequencies;
	}

	fast {
		this.run(0.5);
	}

	slow {
		this.run(10);
	}

	run {|stretch|
		var envDurations, envAmplitudes, envFrequencies;
		envDurations = Env(this.durations, [4,6]);
		envAmplitudes = Env(this.amplitudes, [4,6]);
		envFrequencies = Env(this.frequencies, [4,6]);

		Routine({
			10.do {|i|
				var index = i;
				envFrequencies[index].postln;
				Synth(\sine, [\note, envFrequencies[index].cpsmidi, \amp,  envAmplitudes[index]]);
				(envDurations[index] * stretch).wait;
			}
		}).play
	}
}

/*

x = SequencerX([1/16, 1/8, 1/32], [0.5, 0.75, 0.5], [400, 1500, 200])
x.slow()
x.fast()

*/