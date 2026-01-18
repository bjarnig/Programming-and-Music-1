////////////////////////////////////////////////////////////////
//
//                       Layouts
//
////////////////////////////////////////////////////////////////


////////////////////////// FlowLayout ///////////////////////////

( // Auto-wrapping layout

w = Window("FlowLayout", Rect(200, 200, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 10@10);
20.do {|i|
	Button(w, 80@30).states_([[i.asString]]);
};
w.front;

)


( // Mixed sizes

w = Window("Mixed Sizes", Rect(200, 200, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 5@5);
Button(w, 180@40).states_([["Big Button"]]);
Button(w, 80@40).states_([["Small"]]);
Button(w, 80@40).states_([["Small"]]);
Slider(w, 180@40);
Button(w, 80@40).states_([["Small"]]);
Slider(w, 360@40);
w.front;

)


////////////////////////// HLayout ///////////////////////////

( // Horizontal row

w = Window("HLayout", Rect(200, 200, 400, 100));
w.layout = HLayout(
	Button().states_([["One"]]),
	Button().states_([["Two"]]),
	Button().states_([["Three"]])
);
w.front;

)


( // With sliders

w = Window("Horizontal Sliders", Rect(200, 200, 600, 100));
w.layout = HLayout(
	StaticText().string_("Freq"),
	Slider().orientation_(\horizontal),
	StaticText().string_("Amp"),
	Slider().orientation_(\horizontal),
	StaticText().string_("Pan"),
	Slider().orientation_(\horizontal)
);
w.front;

)


( // Fixed and stretchy

w = Window("Fixed and Stretch", Rect(200, 200, 400, 100));
w.layout = HLayout(
	Button().states_([["Left"]]).fixedWidth_(80),
	nil,
	Button().states_([["Center"]]).fixedWidth_(80),
	nil,
	Button().states_([["Right"]]).fixedWidth_(80)
);
w.front;

)


////////////////////////// VLayout ///////////////////////////

( // Vertical column

w = Window("VLayout", Rect(200, 200, 200, 400));
w.layout = VLayout(
	Button().states_([["Button 1"]]),
	Button().states_([["Button 2"]]),
	Button().states_([["Button 3"]]),
	Button().states_([["Button 4"]]),
	Button().states_([["Button 5"]])
);
w.front;

)


( // Mixed elements

w = Window("Vertical Controls", Rect(200, 200, 300, 400));
w.layout = VLayout(
	StaticText().string_("Frequency").font_(Font("Arial", 18)),
	Slider(),
	NumberBox(),
	StaticText().string_("Amplitude").font_(Font("Arial", 18)),
	Slider(),
	NumberBox(),
	Button().states_([["Play"], ["Stop"]])
);
w.front;

)


////////////////////////// Nested Layouts ///////////////////////////

( // VLayout with HLayout rows

w = Window("Nested Layouts", Rect(200, 200, 400, 300));
w.layout = VLayout(
	StaticText().string_("Controls").font_(Font("Arial", 24)),
	HLayout(
		StaticText().string_("Freq"),
		Slider(),
		NumberBox().fixedWidth_(60)
	),
	HLayout(
		StaticText().string_("Amp"),
		Slider(),
		NumberBox().fixedWidth_(60)
	),
	HLayout(
		StaticText().string_("Pan"),
		Slider(),
		NumberBox().fixedWidth_(60)
	),
	HLayout(
		Button().states_([["Play"]]),
		Button().states_([["Stop"]]),
		nil,
		Button().states_([["Reset"]])
	)
);
w.front;

)


////////////////////////// EZSlider ///////////////////////////

( // Label + slider + number

w = Window("EZSliders", Rect(200, 200, 400, 150));
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 10@10);
a = EZSlider(w, 380@40, "Frequency", \freq, labelWidth: 80);
b = EZSlider(w, 380@40, "Amplitude", \amp, labelWidth: 80);
c = EZSlider(w, 380@40, "Filter", ControlSpec(100, 5000, \exp), labelWidth: 80);
w.front;

)


( // SynthDef for control

SynthDef(\simple, {|freq=440, amp=0.2, ffreq=1000|
	var sig = LPF.ar(Saw.ar(freq), ffreq) * amp;
	Out.ar(0, sig ! 2);
}).add;

)


( // Control synth with EZSliders

w = Window("Synth Control", Rect(200, 200, 400, 150));
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 10@10);
~s = Synth(\simple);
a = EZSlider(w, 380@40, "Frequency", \freq,
	action: {|ez| ~s.set(\freq, ez.value)},
	labelWidth: 80
);
b = EZSlider(w, 380@40, "Amplitude", \amp,
	action: {|ez| ~s.set(\amp, ez.value)},
	labelWidth: 80
);
c = EZSlider(w, 380@40, "Filter", ControlSpec(100, 5000, \exp),
	action: {|ez| ~s.set(\ffreq, ez.value)},
	labelWidth: 80,
	initVal: 1000
);
w.onClose_({ ~s.free });
w.front;

)


////////////////////////// Spacing ///////////////////////////

( // No spacing

w = Window("Spacing", Rect(200, 200, 300, 400));
w.layout = VLayout(
	StaticText().string_("No Spacing"),
	Button().states_([["Button 1"]]),
	Button().states_([["Button 2"]]),
	Button().states_([["Button 3"]])
).spacing_(0);
w.front;

)


( // Large spacing

w = Window("Large Spacing", Rect(200, 200, 300, 400));
w.layout = VLayout(
	StaticText().string_("Large Spacing"),
	Button().states_([["Button 1"]]),
	Button().states_([["Button 2"]]),
	Button().states_([["Button 3"]])
).spacing_(20);
w.front;

)


( // Margins

w = Window("Margins", Rect(200, 200, 300, 200));
w.layout = VLayout(
	Button().states_([["Button 1"]]),
	Button().states_([["Button 2"]]),
	Button().states_([["Button 3"]])
).margins_(50);
w.front;

)


////////////////////////// Grid Layout ///////////////////////////

( // Button grid

w = Window("Grid of Buttons", Rect(200, 200, 400, 400));
w.layout = VLayout(
	HLayout(
		Button().states_([["1"]]),
		Button().states_([["2"]]),
		Button().states_([["3"]]),
		Button().states_([["4"]])
	),
	HLayout(
		Button().states_([["5"]]),
		Button().states_([["6"]]),
		Button().states_([["7"]]),
		Button().states_([["8"]])
	),
	HLayout(
		Button().states_([["9"]]),
		Button().states_([["10"]]),
		Button().states_([["11"]]),
		Button().states_([["12"]])
	),
	HLayout(
		Button().states_([["13"]]),
		Button().states_([["14"]]),
		Button().states_([["15"]]),
		Button().states_([["16"]])
	)
);
w.front;

)


////////////////////////// Complete Interface ///////////////////////////

( // SynthDef

SynthDef(\pad, {|freq=440, amp=0.2, ffreq=1000, res=0.5, atk=0.1, rel=1, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(atk, 1, rel), gate, doneAction:2);
	sig = Saw.ar([freq, freq*1.01]) * amp;
	sig = RLPF.ar(sig, ffreq, res);
	Out.ar(0, sig * env);
}).add;

)


( // Synthesizer controller

var s;
w = Window("Synthesizer", Rect(200, 200, 450, 350));
w.background_(Color.gray(0.2));
w.layout = VLayout(
	StaticText().string_("Synthesizer Controller")
		.font_(Font("Arial", 24))
		.stringColor_(Color.white),
	nil,
	VLayout(
		HLayout(
			StaticText().string_("Freq").stringColor_(Color.white),
			Slider().orientation_(\horizontal),
			NumberBox().fixedWidth_(60)
		),
		HLayout(
			StaticText().string_("Amp").stringColor_(Color.white),
			Slider().orientation_(\horizontal),
			NumberBox().fixedWidth_(60)
		),
		HLayout(
			StaticText().string_("Filter").stringColor_(Color.white),
			Slider().orientation_(\horizontal),
			NumberBox().fixedWidth_(60)
		),
		HLayout(
			StaticText().string_("Res").stringColor_(Color.white),
			Slider().orientation_(\horizontal),
			NumberBox().fixedWidth_(60)
		)
	).spacing_(5),
	nil,
	HLayout(
		Button().states_([["Play", Color.white, Color.green(0.6)]])
			.action_({ s = Synth(\pad) }),
		Button().states_([["Stop", Color.white, Color.red(0.6)]])
			.action_({ s.set(\gate, 0) })
	)
).margins_(20);
w.onClose_({ s.free });
w.front;

)
