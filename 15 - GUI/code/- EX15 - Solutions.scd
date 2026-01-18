////////////////////////////////////////////////////////////////
//
//                   GUI - Solutions
//
////////////////////////////////////////////////////////////////


( // SynthDef used in examples

SynthDef(\sine, {|freq=440, amp=0.2, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction:2);
	sig = SinOsc.ar(freq) * amp * env;
	Out.ar(0, sig ! 2);
}).add;

)


/* Exercise 1: Basic Window
Create a window with a StaticText that displays "Hello GUI".
Make the text centered, size 24, and red color. */

( // Solution 1

var win, txt;
win = Window("Exercise 1", Rect(200, 200, 300, 150));
txt = StaticText(win, Rect(50, 50, 200, 50));
txt.string = "Hello GUI";
txt.align = \center;
txt.font = Font("Arial", 24);
txt.stringColor = Color.red;
win.front;

)


/* Exercise 2: Slider and NumberBox
Create a window with a slider and a number box.
When the slider moves, update the number box with its value. */

( // Solution 2

var win, slider, num;
win = Window("Exercise 2", Rect(200, 200, 300, 150));
slider = Slider(win, Rect(50, 30, 200, 40));
num = NumberBox(win, Rect(125, 80, 50, 30));
slider.action = { num.value = slider.value };
win.front;

)


/* Exercise 3: EZSlider
Create a window with an EZSlider for frequency.
Use the \freq ControlSpec and set labelWidth to 80. */

( // Solution 3

var win, ez;
win = Window("Exercise 3", Rect(200, 200, 400, 100));
win.view.decorator = FlowLayout(win.view.bounds, 10@10, 10@10);
ez = EZSlider(win, 380@40, "Frequency", \freq, labelWidth: 80);
win.front;

)


/* Exercise 4: Routine with defer
Create a window with a StaticText.
Use a Routine to count from 0 to 10, updating the text every 0.5 seconds.
Remember to use defer{} to update the GUI. */

( // Solution 4

var win, txt;
win = Window("Exercise 4", Rect(200, 200, 300, 150));
txt = StaticText(win, Rect(100, 50, 100, 50));
txt.font = Font("Arial", 36);
txt.align = \center;
win.front;
Routine({
	11.do {|i|
		defer{ txt.string = i.asString };
		0.5.wait;
	};
}).play;

)


/* Exercise 5: Slider to Synth
Create a window with a slider that controls the frequency of a playing synth.
Use a simple sine wave SynthDef. */

( // Solution 5

var win, slider, syn;
win = Window("Exercise 5", Rect(200, 200, 400, 150));
syn = Synth(\sine);
slider = Slider(win, Rect(50, 50, 300, 40));
slider.action = {|s|
	var freq = s.value.linexp(0, 1, 200, 2000);
	syn.set(\freq, freq);
};
win.onClose = { syn.free };
win.front;

)


/* Exercise 6: Multi-Parameter Synth Control
Create a window with three EZSliders controlling frequency, amplitude, and filter cutoff
of a filtered saw wave synth. Use appropriate ControlSpecs for each parameter. */

( // Solution 6a - SynthDef

SynthDef(\filtered, {|freq=440, amp=0.2, ffreq=2000, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(0.01, 1, 0.1), gate, doneAction:2);
	sig = Saw.ar(freq) * amp;
	sig = RLPF.ar(sig, ffreq, 0.5);
	Out.ar(0, sig * env ! 2);
}).add;

)


( // Solution 6b - GUI

var win, syn;
win = Window("Exercise 6", Rect(200, 200, 450, 200));
win.view.decorator = FlowLayout(win.view.bounds, 10@10, 10@10);
syn = Synth(\filtered);
EZSlider(win, 430@40, "Frequency", \freq,
	action: {|ez| syn.set(\freq, ez.value)},
	labelWidth: 80
);
EZSlider(win, 430@40, "Amplitude", \amp,
	action: {|ez| syn.set(\amp, ez.value)},
	labelWidth: 80,
	initVal: 0.2
);
EZSlider(win, 430@40, "Filter", ControlSpec(200, 5000, \exp),
	action: {|ez| syn.set(\ffreq, ez.value)},
	labelWidth: 80,
	initVal: 2000
);
win.onClose = { syn.free };
win.front;

)


/* Exercise 7: Start/Stop Synth Button
Create a window with a button that starts and stops a synth.
The button should have two states: "Start" (green) and "Stop" (red).
Make sure to free the synth when stopping. */

( // Solution 7

var win, btn, syn;
win = Window("Exercise 7", Rect(200, 200, 250, 150));
btn = Button(win, Rect(50, 50, 150, 50));
btn.states = [
	["Start", Color.black, Color.green(0.7)],
	["Stop", Color.white, Color.red(0.7)]
];
btn.action = {|b|
	if(b.value == 1,
		{ syn = Synth(\sine, [\freq, 440]) },
		{ syn.free }
	)
};
win.front;

)


/* Exercise 8: Waveform Selector
Create a window with a PopUpMenu to select between four waveforms:
"Sine", "Saw", "Pulse", "Noise". Play the selected waveform at 440 Hz
when a separate "Play" button is pressed. */

( // Solution 8

var win, menu, btn, snd, waves;
win = Window("Exercise 8", Rect(200, 200, 300, 150));
menu = PopUpMenu(win, Rect(50, 30, 200, 30));
menu.items = ["Sine", "Saw", "Pulse", "Noise"];
waves = [
	{ SinOsc.ar(440, 0, 0.2) ! 2 },
	{ Saw.ar(440, 0.2) ! 2 },
	{ Pulse.ar(440, 0.5, 0.2) ! 2 },
	{ WhiteNoise.ar(0.2) ! 2 }
];
btn = Button(win, Rect(50, 80, 200, 40));
btn.states = [
	["Play", Color.white, Color.green(0.6)],
	["Stop", Color.white, Color.red(0.6)]
];
btn.action = {|b|
	if(b.value == 1,
		{ snd = waves[menu.value].play },
		{ snd.free }
	)
};
win.front;

)


/* Exercise 9: Pattern Duration Control
Create a window with a slider that controls the duration of a simple Pbind pattern.
Use a PatternProxy for the duration so it can be changed while the pattern is playing. */

( // Solution 9

var win, slider, num, dur, pat;
win = Window("Exercise 9", Rect(200, 200, 400, 200));
dur = PatternProxy(0.2);
slider = Slider(win, Rect(50, 50, 300, 40));
slider.value = 0.5;
num = NumberBox(win, Rect(175, 100, 50, 30));
num.value = 0.2;
slider.action = {|s|
	var d = s.value.linexp(0, 1, 0.05, 1.0);
	dur.source = d;
	num.value = d;
};
Button(win, Rect(150, 140, 100, 40))
	.states_([["Start"], ["Stop"]])
	.action_({|b|
		if(b.value == 1,
			{ pat = Pbind(\freq, Pwhite(400, 800), \dur, dur).play },
			{ pat.stop }
		)
	});
win.front;

)


/* Exercise 10: Multiple Synth Mixer
Create a window with 4 vertical sliders (using HLayout) that control
the amplitude of 4 different sine wave synths playing at different frequencies
(e.g., 200, 300, 400, 500 Hz). */

( // Solution 10

var win, syns, freqs;
win = Window("Exercise 10", Rect(200, 200, 400, 350));
freqs = [200, 300, 400, 500];
syns = freqs.collect {|f| Synth(\sine, [\freq, f, \amp, 0.1]) };
win.layout = HLayout(
	*freqs.collect {|f, i|
		VLayout(
			StaticText().string_(f.asString ++ " Hz").align_(\center),
			Slider().value_(0.5).action_({|s|
				syns[i].set(\amp, s.value * 0.2);
			})
		)
	}
);
win.onClose = { syns.do(_.free) };
win.front;

)


/* Exercise 11: Recording Interface
Create a window with:
- A button to start/stop recording (use s.record and s.stopRecording)
- A StaticText showing "Recording..." when active
Make sure to handle the recording state properly. */

( // Solution 11

var win, btn, txt;
win = Window("Exercise 11", Rect(200, 200, 300, 150));
txt = StaticText(win, Rect(50, 30, 200, 30));
txt.string = "Ready";
txt.align = \center;
txt.font = Font("Arial", 16);
btn = Button(win, Rect(75, 80, 150, 50));
btn.states = [
	["Start Recording", Color.white, Color.red(0.7)],
	["Stop Recording", Color.white, Color.gray(0.3)]
];
btn.action = {|b|
	if(b.value == 1, {
		s.record;
		txt.string = "Recording...";
		txt.stringColor = Color.red;
	}, {
		s.stopRecording;
		txt.string = "Stopped";
		txt.stringColor = Color.black;
	})
};
win.front;

)


/* Exercise 12: OSC to GUI
Create a SynthDef that sends MouseX position via SendReply.
Display the received value in a GUI slider using OSCdef and defer. */

( // Solution 12a - SynthDef

SynthDef(\mouseX, {
	var x = MouseX.kr(0, 1);
	SendReply.kr(Impulse.kr(30), '/mouseX', x);
	Silent.ar;
}).add;

)


( // Solution 12b - GUI

var win, slider, syn;
win = Window("Exercise 12", Rect(200, 200, 400, 150));
slider = Slider(win, Rect(50, 50, 300, 40));
win.front;
OSCdef(\mouseXGUI, {|msg|
	defer{
		slider.value = msg[3];
	};
}, '/mouseX');
syn = Synth(\mouseX);
win.onClose = {
	syn.free;
	OSCdef(\mouseXGUI).free;
};

)
