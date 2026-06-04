////////////////////////////////////////////////////////////////
//
//                         Sound Input
//
////////////////////////////////////////////////////////////////


// Use headphones in order to avoid feedback

{ Limiter.ar( CombC.ar(LPF.ar(SoundIn.ar([0,1]), SinOsc.ar([10,8]).range(500,2000)), 0.2, 0.2, 4), 0.75) }.play


{ Limiter.ar( FreeVerb.ar( LeastChange.ar(SoundIn.ar([0,1]).tanh, SoundIn.ar([0,1]) * SinOsc.ar(15)), 0.3, 0.9, 0.2), 0.75) }.play


{ Limiter.ar( CombC.ar(PitchShift.ar(SoundIn.ar([0,1]), 0.1, SinOsc.ar(10).range(0.5, 2)), 0.5, 0.5, 1), 0.75) }.play


{ Limiter.ar( GVerb.ar( SoundIn.ar([0,1]) ), 0.75) }.play


(

~recordMultiChannel = {|outName = "test", channels = 8, duration = 4, offset = 0, path = "/Users/bjarni/Desktop/record/", task|

var synths = Array.newClear(channels);
var	buffers = Array.newClear(channels);
var space = 0.1;

Routine {

	SynthDef("recorder", { |bufnum, bus|
		DiskOut.ar(bufnum, In.ar(bus, 1));
	}).add;

	s.sync;

	channels.do {|i|

		buffers[i] = Buffer.alloc(s, 262144, 1);
		s.sync;
		buffers[i].write(path ++ outName ++ i ++ ".wav", "wav", "int16", 0, 0, true);
		s.sync;
		synths[i] = Synth(\recorder, [\bufnum, buffers[i], \bus, offset + i]);
	};


	"Recording started".postln;

	space.wait;
	task.value;

	duration.wait;
	space.wait;

	channels.do {|i|
	  synths[i].free;
	  buffers[i].close;
	};

	"Recording stoped".postln;

}.play;

};

~recordMultiChannel.value(task: { { Dust.ar( rrand(10, 25) ! 8 ) }.play })

)

{ Dust.ar(20 ! 2) }.play

// - Record and overdub to a buffer (from helpfiles) -

// Execute the following in order
(
// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer
)


// record for four seconds
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125);
    RecordBuf.ar(formant, bufnum, doneAction: Done.freeSelf, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)

// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)

// overdub
(
SynthDef(\help_RecordBuf_overdub, { arg out=0, bufnum=0;
    var formant;
    formant = Formant.ar(XLine.kr(200, 1000, 4), 2000, 800, 0.125);
    // mixes equally with existing data
    RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, doneAction: Done.freeSelf, loop: 0);
}).play(s, [\out, 0, \bufnum, b]);
)

// play back the overdubbed version
Synth.new(\help_RecordBuf_playback, [\out, 0, \bufnum, b], s);

