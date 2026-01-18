////////////////////////////////////////////////////////////////
//
//                       OSC replies
//
////////////////////////////////////////////////////////////////


////////////////////////// Mouse Position ///////////////////////////

( // SynthDef with SendReply

SynthDef(\mouseDisplay, {
	var x, y;
	x = MouseX.kr(0, 1);
	y = MouseY.kr(0, 1);
	SendReply.kr(Impulse.kr(30), '/mouse', [x, y]);
	Silent.ar;
}).add;

)


( // Display mouse data in GUI

var w, xs, ys, xn, yn, s;
w = Window("Mouse Position", Rect(200, 200, 400, 200));
w.layout = VLayout(
	StaticText().string_("Move mouse over screen").align_(\center),
	HLayout(
		StaticText().string_("X:"),
		xs = Slider().orientation_(\horizontal),
		xn = NumberBox().fixedWidth_(60)
	),
	HLayout(
		StaticText().string_("Y:"),
		ys = Slider().orientation_(\horizontal),
		yn = NumberBox().fixedWidth_(60)
	)
);
w.front;
OSCdef(\mouseGUI, {|msg|
	defer{
		xs.value = msg[3];
		ys.value = msg[4];
		xn.value = msg[3];
		yn.value = msg[4];
	};
}, '/mouse');
s = Synth(\mouseDisplay);
w.onClose_({
	s.free;
	OSCdef(\mouseGUI).free;
});

)


////////////////////////// Amplitude Tracker ///////////////////////////

( // SynthDef with amp tracking

SynthDef(\ampTracker, {|amp=0.1|
	var sig, follow;
	sig = SinOsc.ar(440) * amp;
	follow = Amplitude.kr(sig);
	SendReply.kr(Impulse.kr(30), '/amp', follow);
	Out.ar(0, sig ! 2);
}).add;

)


( // Display amplitude

var w, m, n, s;
w = Window("Amplitude Meter", Rect(200, 200, 300, 400));
w.layout = VLayout(
	StaticText().string_("Amplitude").font_(Font("Arial", 24)).align_(\center),
	m = Slider(),
	n = NumberBox(),
	Slider().orientation_(\horizontal).action_({|v|
		s.set(\amp, v.value);
	})
);
w.front;
OSCdef(\ampMeter, {|msg|
	defer{
		m.value = msg[3];
		n.value = msg[3];
	};
}, '/amp');
s = Synth(\ampTracker);
w.onClose_({
	s.free;
	OSCdef(\ampMeter).free;
});

)


////////////////////////// Pitch Tracker ///////////////////////////

( // SynthDef with pitch tracking

SynthDef(\pitchTracker, {
	var sig, freq, hasFreq;
	sig = SoundIn.ar(0);
	# freq, hasFreq = Pitch.kr(sig);
	SendReply.kr(Impulse.kr(10), '/pitch', [freq, hasFreq]);
	Out.ar(0, sig ! 2);
}).add;

)


( // Display pitch

var w, ft, ht, s;
w = Window("Pitch Detector", Rect(200, 200, 300, 150));
w.layout = VLayout(
	StaticText().string_("Sing or play into mic").align_(\center),
	ft = StaticText().font_(Font("Arial", 36)).align_(\center),
	ht = StaticText().align_(\center)
);
w.front;
OSCdef(\pitchDisplay, {|msg|
	var freq = msg[3];
	var has = msg[4];
	defer{
		ft.string = freq.round(0.1).asString ++ " Hz";
		ht.string = if(has > 0.5, {"Detected"}, {"..."});
	};
}, '/pitch');
s = Synth(\pitchTracker);
w.onClose_({
	s.free;
	OSCdef(\pitchDisplay).free;
});

)


////////////////////////// Multiple Channels ///////////////////////////

( // SynthDef with multiple LFOs

SynthDef(\multiTrack, {
	var lfo1, lfo2, lfo3;
	lfo1 = LFNoise1.kr(2);
	lfo2 = LFNoise1.kr(3);
	lfo3 = LFNoise1.kr(1);
	SendReply.kr(Impulse.kr(20), '/lfos', [lfo1, lfo2, lfo3]);
	Silent.ar;
}).add;

)


( // Display LFOs

var w, sl, s;
w = Window("LFO Display", Rect(200, 200, 400, 300));
sl = 3.collect {|i|
	Slider(w, Rect(i * 120 + 20, 50, 100, 200));
};
w.front;
OSCdef(\lfoDisplay, {|msg|
	defer{
		3.do {|i|
			sl[i].value = msg[i + 3].linlin(-1, 1, 0, 1);
		};
	};
}, '/lfos');
s = Synth(\multiTrack);
w.onClose_({
	s.free;
	OSCdef(\lfoDisplay).free;
});

)


////////////////////////// Beat Counter ///////////////////////////

( // SynthDef with counter

SynthDef(\beatCounter, {|tempo=2|
	var trig, cnt;
	trig = Impulse.kr(tempo);
	cnt = PulseCount.kr(trig);
	SendReply.kr(trig, '/beat', cnt);
	SendTrig.kr(trig, 0, cnt);
	Silent.ar;
}).add;

)


( // Display beat count

var w, c, f, s;
w = Window("Beat Counter", Rect(200, 200, 300, 200));
c = StaticText(w, Rect(50, 50, 200, 100))
	.font_(Font("Arial", 72))
	.align_(\center)
	.string_("0");
f = View(w, w.view.bounds)
	.background_(Color.clear);
w.front;
OSCdef(\beatCount, {|msg|
	defer{
		c.string = msg[3].asInteger.asString;
		f.background = Color.yellow(0.5);
	};
	{
		defer{ f.background = Color.clear };
	}.defer(0.1);
}, '/beat');
s = Synth(\beatCounter);
w.onClose_({
	s.free;
	OSCdef(\beatCount).free;
});

)
