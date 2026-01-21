////////////////////////////////////////////////////////////////
//
//                         Interfaces
//
////////////////////////////////////////////////////////////////


////////////////////// Window and Rect /////////////////////////

// Left, top, width, height
r = Rect(400,200,300,400);

// Title and rect
w = Window("Empty Window", r);

// Display
w.front


( // Scrollable Window

Slider2D(Window("Scroll", scroll: false).front, Rect(0, 0, 1500, 100));

)


( // Action when closed

Window.new.front.onClose = { { Dust.ar(LFNoise0.kr(2, 10, 50)) }.play };

)


/////////////////////// Text and Color /////////////////////////

( // Window with text

~w = Window("", Rect(200,200,200,200));
~w.name = "The Window";
~t = StaticText(~w, Rect(130,160,100,50));
~t.string = "The Text";
~t.stringColor = Color.rand;
~w.front

)


( // Blue text on white

w = Window("White background", Rect(200,200,400,400));
~t = StaticText(w, Rect(150,150,200,100));
~t.string = "Blue Text";
~t.stringColor = Color.blue;
w.background = Color.white;
w.front

)


( // Iteration

w = Window("", Rect(200,200,400,400));
w.name = "12 times";
12.do {|i|
	i = i + 1;
	~t = StaticText(w, Rect(75,20 + (20 * i),200,100));
	~t.string = "Iteration: " + i;
	~t.font = Font("Monaco", 10 + i);
};
w.front

)


( // Animated colors

var w = Window("Colorful", Rect(200,200,400,400)).front;
w.background = Color.new255(153, 255, 102).vary;
w.drawFunc = { w.background = Color.new(1, 1.0.rand,1.0.rand,1.0.rand) };
{ while { w.isClosed.not } { w.refresh; 0.1.wait; } }.fork(AppClock);

)


///////////////////// Sliders and Buttons //////////////////////

( // Slider to number box

w = Window("Slider and Box", Rect(200,200,200,200));
~b = NumberBox(w, Rect(20, 20, 160, 20));
~a = Slider(w, Rect(20, 60, 160, 30));
~a.action = { ~b.value = ~a.value };
w.front

)


( // Add/remove actions

w = Window.new("A Slider");
w.background = Color.new255(210,220,230,240);
~a = Slider.new(w, Rect(50, 50, 400, 300));
w.front

)

~f = {|sl| sl.value.postln };
~a.addAction(~f);
~a.removeAction(~f);

~c = {|sl| w.background = Color.rand };
~a.addAction(~c);
~a.removeAction(~c);


( // Button with sound

w = Window.new("Impulse", Rect(100,100,200,200));
~b = Button(w, Rect(45, 45, 100, 100));
~b.states = [
	["Start", Color.black, Color.white],
	["Stop", Color.white, Color.black],
	["Random".scramble, Color.rand, Color.rand]
];
~b.action = {|btn|
	btn.value.postln;
	if(btn.value == 1,
		{ ~a = { Impulse.ar(40) ! 2 }.play },
		{ ~a.free }
	)
};
w.front

)


( // SynthDef with slider

var mkWin = {
	var w, trig, sl, slA, s, spec;
	w = Window.new("SynthDef - Control", Rect(100,100,400,300));
	w.background = Color.fromHexString("#434371");
	spec = ControlSpec(100, 200, \exp, 10);
	sl = Slider(w, Rect(50, 150, 300, 50));
	sl.action = { s.set(\freq, spec.map(sl.value)) };
	slA = Slider(w, Rect(50, 220, 300, 50));
	slA.background = Color.fromHexString("#70EE9C");
	slA.action = { s.set(\amp, slA.value) };
	trig = Button(w, Rect(50, 50, 300, 50));
	trig.states = [
		["Play", Color.black, Color.white],
		["Release", Color.white, Color.black]
	];
	trig.mouseDownAction = {|btn| if(btn.value == 0) { s = Synth(\Pulse) }};
	trig.action = {|btn| btn.value.postln; if(btn.value == 0, { s.set(\gate, 0) })};
	w.front
};
SynthDef(\Pulse, {|gate=1, freq=200, amp=1|
	var env = EnvGen.kr(Env.asr(1, 0.1, 4), gate, doneAction:2);
	Out.ar(0, Impulse.ar(freq, 0, amp) * env ! 2);
}).add();
mkWin.value;

)


( // Additive synthesis control

var mkWin = {
	var s, spec, w;
	w = Window("Additive", Rect(100,200,370,350));
	w.background = Color.fromHexString("#A96E6E");
	spec = ControlSpec(100, 500,'exponential');
	4.do {|i|
		var sl, txt, off, num;
		i = i + 1;
		off = 50 * i;
		num = NumberBox(w, Rect(off,255,50,20));
		sl = Slider(w, Rect(off,50,50,200));
		sl.action = {|v|
			var val = spec.map(v.value);
			s.set("f"++i,val);
			num.value = val
		};
		txt = StaticText(w,Rect(off,30,50,20));
		txt.string = "Freq" ++ i;
		txt.stringColor = Color.white;
		txt.align = \center;
	};
	Button(w, Rect(50,285,250,50))
		.states_([["Start"], ["Stop", Color.black, Color.cyan(alpha: 0.2)]])
		.action_({|v|
			if(v.value == 1,
				{ s = Synth(\additive) },
				{ s.set(\gate, 0) }
			)
		});
	w.front
};
SynthDef(\additive, {|f1=400, f2=600, f3=400, f4=600, amp=0.1, gate=1|
	var sig, env;
	env = EnvGen.kr(Env.asr(2,1,2),gate,amp,doneAction:2);
	sig = SinOsc.ar(f1) + SinOsc.ar(f2) + SinOsc.ar(f3) + SinOsc.ar(f4);
	sig = sig * 0.25;
	Out.ar(0,sig * env ! 2);
}).add();
mkWin.value();

)


//////////////////// Decoration and EZSlider ///////////////////

( // FlowLayout with knobs

var ctrls, w = Window("".scramble,Rect(200,200,345,370));
w.background = Color.fromHexString("#e2efde");
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 15@15);
ctrls = Array.fill(140,{Knob(w.view,15@15).background_(Color.white)});
ctrls.do{|c| c.value = 1.0.rand};
w.front

)


( // EZSlider

w = Window("Window", Rect(100,100,400,100));
w.view.decorator = FlowLayout(w.view.bounds);
~a = EZSlider(w, 350 @ 40, "Frequency",\freq, labelWidth: 80);
~b = EZSlider(w, 350 @ 40, "Amplitude",\amp, labelWidth: 80);
w.front

)


///////////////////////// PopUpMenu ////////////////////////////

( // PopUpMenu with actions

var w, menu, snd, acts, btn;
w = Window("Pop", Rect(400,400,300,200));
w.background = Color.cyan;
menu = PopUpMenu(w,Rect(10,10,90,20));
menu.items = (["Sine", "Saw", "Noise", "Pulse"]);
acts = [
	{SinOsc.ar(440,0,0.3)!2},
	{Saw.ar(440,0.3)!2},
	{WhiteNoise.ar(0.3)!2},
	{Pulse.ar(440,0.2,0.3)!2}
];
btn = Button(w,Rect(110,10,180,20));
btn.states = [["Play",Color.white, Color.blue]];
btn.mouseDownAction = { snd = acts.at(menu.value).play};
btn.action = { snd.free };
w.front

)


//////////////////////// EnvelopeView //////////////////////////

( // Interactive envelope

var w, env, btn, snd;
w = Window("Envelope", Rect(200, 200, 600, 300));
w.background = Color.black;
w.view.decorator = FlowLayout(w.view.bounds);
env = EnvelopeView(w, Rect(0, 0, 590, 200))
	.thumbSize_(5)
	.drawLines_(true)
	.fillColor_(Color.green)
	.selectionColor_(Color.red)
	.strokeColor_(Color.blue)
	.drawRects_(true)
	.value_([(0.0, 0.1 .. 1.0), Array.rand(11, 0.0, 1.0)])
	.setEditable(0,true);
btn = Button(w,Rect(110,550,590,80));
btn.states = [["Play",Color.white, Color.blue]];
btn.mouseDownAction = {
	snd = {
		Saw.ar(EnvGen.kr(Env.new(env.value[1] * 1000, env.value[0] * 2)))
	}.play
};
btn.action = { snd.free };
w.front

)


/////////////////////// SoundFileView //////////////////////////

~path = (PathName(thisProcess.nowExecutingPath)).pathOnly ++ "/samples/cutt.wav";
~buf = Buffer.read(s, ~path);

( // Looper interface

var w, v, f, s;
s = SynthDef(\looper, {|start=0, end=10000|
	Out.ar(0,BufRd.ar(2, ~buf.bufnum,
		Phasor.ar(0, BufRateScale.kr(~buf.bufnum), start, end),0.0)!2)
}).play;
w = Window.new("Soundfile - Looper", Rect(200, 400, 740, 300));
w.background = Color.fromHexString("#6B97C8");
v = SoundFileView.new(w, Rect(20, 20, 700, 260));
f = SoundFile.new;
f.openRead(~path);
v.soundfile = f;
v.read(0, f.numFrames);
v.elasticMode = true;
v.timeCursorOn = true;
v.timeCursorColor = Color.red;
v.drawsWaveForm = true;
v.gridOn = true;
v.gridResolution = 0.2;
v.mouseUpAction_({arg vw;
	var pos = (vw.selections[0]);
	s.set(\start, pos[0], \end, pos[0]+pos[1]);
});
w.front

)


////////////////////// MultiSliderView /////////////////////////

( // Sequencer with multislider

var w, sz=12, ms, pl, snd, times=64, tempo=0.1;
snd = {arg freq=330; Impulse.ar(freq,0,0.2)}.play;
w = Window("Multislider", Rect(200, 450, 10 + (sz * 17), 10 + (sz * 17)));
w.view.decorator = FlowLayout(w.view.bounds);
ms = MultiSliderView(w, Rect(0, 0, sz * 17, sz * 17));
ms.value_(Array.fill(sz,{|i| i/sz}));
ms.background_(Color.rand);
ms.action = {arg pt;
	snd.set(\freq, 200+(1000*pt.value.at(pt.index)))
};
ms.elasticMode = 1;
ms.showIndex = true;
w.front;
pl = Routine({
	times.do({arg i;
		ms.index_(i%sz);
		ms.doAction;
		tempo.wait;
	});
});
AppClock.play(pl);

)


/////////////////////// Drag and Drop //////////////////////////

( // DragSource to DragSink

var w, sine, imp, dest;
w = Window("Drag and Drop", Rect(400,400,400,250));
w.background = Color.white;
w.front;
sine = DragSource(w, Rect(10, 20, 150, 20)).align_(\center);
sine.object = { { SinOsc.ar(400) }.play };
sine.string = "Sine";
sine.dragLabel = "Sine";
imp = DragSource(w, Rect(10, 50, 150, 20)).align_(\center);
imp.object = { { Impulse.ar(80) }.play };
imp.string = "Impulse";
imp.dragLabel = "Impulse";
dest = DragSink(w, Rect(170, 20, 200, 200)).align_(\center);
dest.string = "Drop here to play";
dest.canReceiveDragHandler = { View.currentDrag.isKindOf(Function) };
dest.receiveDragHandler = {arg v;
	dest.object = View.currentDrag.value;
	dest.string = "click here for silence";
	dest.background_(Color.red)
};
dest.mouseDownAction = {
	dest.object.free;
	dest.string = "I evaluate a (sound) function";
	dest.background_(Color.clear)
};

)


////////////////////// Keyboard actions ////////////////////////

// As UGen
{ Dust.ar(KeyState.kr(0, 200, 10, 4)) }.play;


( // Play with keyboard

SynthDef(\perc, {|freq=400|
	var sig, env;
	env = EnvGen.ar(Env.perc);
	sig = PMOsc.ar(freq, freq * 2, 0.5);
	Out.ar(0, sig * env ! 2);
}).add();
w = Window.new("Keys", Rect(200, 300, 400, 400));
w.background = Color.magenta;
w.view.keyDownAction = {|view, char|
	Synth(\perc, [\freq, char.ascii.midicps])
};
w.front

)


//////////////////////// Mouse actions /////////////////////////

// As UGen for clicking
{ Impulse.ar(MouseButton.kr(20, 200, 4), 0, 0.5) }.play;

// As UGen for position
{ HPF.ar(Impulse.ar(MouseX.kr(20, 1000, 1), 0, 0.2), MouseY.kr(20, 10000, 1)) }.play;


( // Click to play

SynthDef(\fm, {|carr=400, mod=200|
	var sig, env;
	env = EnvGen.ar(Env.sine);
	sig = PMOsc.ar(carr, mod, 10, mul:0.5);
	Out.ar(0, sig * env ! 2);
}).add();
w = Window.new("Mouse", Rect(200, 300, 600, 600));
w.background = Color.yellow;
w.view.mouseDownAction = {|view, x, y|
	Synth(\fm, [\carr, x, \mod, y])
};
w.front

)
