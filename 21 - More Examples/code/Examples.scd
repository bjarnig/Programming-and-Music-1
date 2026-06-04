
// Pbinds + effects

(

SynthDef(\saws, {|out=0, freq=100, atk=0.5, rel=1.0, lop=500, res=0.5, amp=1.0, gate=1|
	var sig, env, filter;
	sig = Saw.ar([freq, freq*0.5], 0.2) * amp;
	env = EnvGen.ar(Env.asr(atk,1,rel), gate, doneAction:2);
	filter = BLowPass4.ar(sig, lop, res);
	Out.ar(out, filter * env);
}).add;

SynthDef(\comb, { |in=0, out=0, mix=0.5|
	var source, delay;
	source = In.ar(in, 2);
	delay = CombL.ar(source, 0.5, MouseY.kr(0.01, 0.5), MouseX.kr(1,4));
	ReplaceOut.ar(out, (source * (1 - mix)) + (delay * mix));
}).add;

)

(

// Create a bus
~bus = Bus.audio(s, 2);

// Start the effect that will read from the bus
Synth(\comb, [\in, ~bus]);

// Start Pbind playing the synth into the bus
Pbind(\instrument, \saws, \out, ~bus, \dur, 0.3, \freq, Pbrown(100,1000,50)).trace.play

)


// (live code + effects) GUI Code is first and the live part below.

(

// waitForBoot waits until the server has been booted.
s.waitForBoot({

	var win, color, alpha, stringColor, defaultFont, synth, totalDuration, offset;
	var createKnob, createNumber, createLabel;
	var freqKnob, freqSpec, freqNumber, freqLabel;
	var ampKnob, ampSpec, ampNumber, ampLabel;
	var modKnob, modSpec, modNumber, modLabel;
	var filterKnob, filterSpec, filterNumber, filterLabel;
	var trigKnob, trigSpec, trigNumber, trigLabel;

	// Common values
	color = Color.fromHexString("#581845");
	stringColor = Color.white;
	defaultFont =  Font("Monaco", 14);
	alpha = 0.9;
	totalDuration=100;
	offset=250;

	// Add the window
	win = Window.new("Processor", Rect(20, 400, 1250, 300));
	win.front;
	win.background = color;
	win.alpha = alpha;

	// Factory for knobs
	createKnob = {|spec, numberControl, synthKey, left|
		var knob, value;
		knob =  Knob.new(win, Rect(left, 20, 200, 200));
	    knob.action = {arg v;
		value = spec.map(v.value);

		synth.set(synthKey, value);
			numberControl.string = value.round(0.1)};
		knob
	};

	// Factory for display numbers
	createNumber = {|spec, left|
		var number;
		number = StaticText.new(win, Rect(left, 210, 80, 25));
		number.background = color;
		number.alpha = alpha;
		number.align = \center;
		number.string = spec.default;
		number.font = defaultFont;
		number.stringColor = stringColor;
	};

	// Factory for labels
	createLabel = {|text, left|
		var label = StaticText.new(win, Rect(left, 240, 200, 25));
		label.string = text;
		label.align = \center;
		label.font = defaultFont;
		label.stringColor = stringColor;
	};

	// Create the specs
	freqSpec = ControlSpec(20.0, 8000.0, 'lin', 0.01, 100.0);
	ampSpec = ControlSpec(0.0, 1.0, 'lin', 0.01, 0.1);
	modSpec = ControlSpec(1.0, 20.0, 'lin', 0.01, 1.0);
	filterSpec = ControlSpec(60, 4000.0, 'lin', 0.01, 0.1);
	trigSpec = ControlSpec(1.0, 50.0, 'lin', 1, 0.1);

	// Frequency controls
	freqNumber = createNumber.value(freqSpec, 80);
	freqKnob = createKnob.value(freqSpec, freqNumber, \rate, 20);
	freqLabel = createLabel.value("Frequency", 20);

	// Amp controls
	ampNumber = createNumber.value(ampSpec, 80 + offset);
	ampKnob = createKnob.value(ampSpec, ampNumber, \amp, 20 + offset);
	ampLabel = createLabel.value("Amplitude", 20 + offset);

	// Pos controls
	modNumber = createNumber.value(modSpec, 80 + (offset * 2));
	modKnob = createKnob.value(modSpec, modNumber, \mod, 20 + (offset * 2));
	modLabel = createLabel.value("Modulation", 20 + (offset * 2));

	// filter controls
	filterNumber = createNumber.value(filterSpec, 80 + (offset * 3));
	filterKnob = createKnob.value(filterSpec, filterNumber, \filter, 20 + (offset * 3));
	filterLabel = createLabel.value("Filter", 20 + (offset * 3));

	// trigger controls
	trigNumber = createNumber.value(trigSpec, 80 + (offset * 4));
	trigKnob = createKnob.value(trigSpec, trigNumber, \trig, 20 + (offset * 4));
	trigLabel = createLabel.value("trig", 20 + (offset * 4));

	synth = Ndef(\effect);

});

)

/////////////// /////////////// LIVE CODE STARTS  /////////////// ///////////////

(

Ndef(\synth, {|freq = 100|
	var array = [];

	15.do{|i|
		var sig = SinOsc.ar(freq * (i+1)*2.5);
		array = array ++ sig;
	};
	Splay.ar(array)
});

Ndef(\effect, {|freq=3200, trig = 1, pos=0, mod=1, amp=0.2, filter=500|
	var array = Ndef(\synth).ar;
	var trigger = Impulse.ar(trig);
	array = Klank.ar(`[Array.rand(10, 100, 5000), Array.rand(10, 0.01, 0.1)], array);
	array = Decay2.ar(trigger,0.1,0.5,0.8) * array;
	10.do{ array = AllpassL.ar(array, 0.5, LFNoise0.ar(2).range(0.1, 0.5)); };
	array = CombL.ar(array, 2, LFNoise0.ar(mod).range(0.5, 1.5));
	3.do{ var bpf = BPF.ar(array, LFNoise0.ar(mod*5).range(filter*0.5, filter*2), TRand.kr(0.1, 1,Dust.ar(5)), 0.5);
	array = array ++ bpf;
	};
	array = BRF.ar(array,freq,1) * 0.5;
	array = FreeVerb.ar(array);
	Splay.ar(array * amp, center: pos)
}).play;

Ndef(\effect).fadeTime = 5;

)

Ndef.clear
