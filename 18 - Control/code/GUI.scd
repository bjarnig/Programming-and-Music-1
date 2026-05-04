////////////////////////////////////////////////////////////////
//
//                           GUI
//
////////////////////////////////////////////////////////////////


Graphical user interfaces in SuperCollider.
Windows, views, controls, drawing, animation,
and connecting interfaces to sound.


////////////////// Window Basics ///////////////////////////////


// left, top, width, height

r = Rect(400, 200, 300, 400);


// Title and rect instance

w = Window("Empty Window", r);


// Display the window

w.front


// Action when closed

Window.new.front.onClose = { { Dust.ar(LFNoise0.kr(2, 10, 50)) }.play(AppClock) };



///////////////////// Slider to Sound //////////////////////////


// Slider controls resonant body frequency

(
Routine {
	var win, slider, synth, spec;

	SynthDef(\resSlider, {|freq=200, decay=0.4|
		var sig = DynKlank.ar(
			`[[freq, freq * 2.73, freq * 5.1],
			  nil,
			  [decay, decay * 0.5, decay * 0.2]],
			Dust.ar(12) * 0.05
		);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\resSlider);

	spec = ControlSpec(40, 4000, \exp);

	win = Window("Resonant Body", Rect(200, 200, 400, 150));
	win.background = Color.fromHexString("#1a1a2e");

	slider = Slider(win, Rect(30, 50, 340, 50));
	slider.knobColor = Color.fromHexString("#e94560");
	slider.action = {
		synth.set(\freq, spec.map(slider.value))
	};

	win.onClose = { synth.free };
	win.front;

}.play(AppClock)
)


// Button triggers impulse bursts

(
SynthDef(\chaoBurst, {|amp=0.3|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, 10.8), doneAction: 2);
	sig = DynKlank.ar(
		`[Array.rand(6, 100, 6000), nil, Array.rand(6, 2.05, 13.3)],
		Impulse.ar(0) * 0.1
	);
	Out.ar(0, sig * env * amp ! 2);
}).add;

{
	var win, btn;

	win = Window("Burst", Rect(200, 200, 200, 200));
	win.background = Color.fromHexString("#0f3460");

	btn = Button(win, Rect(30, 30, 140, 140));
	btn.states = [
		["Strike", Color.white, Color.fromHexString("#e94560")]
	];
	btn.action = { Synth(\chaoBurst) };

	win.front;
}.value
)


// Two sliders: frequency and feedback amount

(
Routine {
	var win, slFreq, slFb, synth, specF, specFb;

	SynthDef(\fbSlider, {|freq=200, fb=0.3, amp=0.2|
		var sig, fbIn;
		fbIn = LocalIn.ar(1);
		sig = SinOsc.ar(freq + (fbIn * freq * 4));
		LocalOut.ar(sig * fb);
		Out.ar(0, LeakDC.ar(sig) * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\fbSlider);

	specF = ControlSpec(30, 2000, \exp);
	specFb = ControlSpec(0, 0.95, \lin);

	win = Window("Feedback", Rect(200, 200, 400, 200));
	win.background = Color.fromHexString("#7c616c");

	slFreq = EZSlider(win, Rect(20, 30, 360, 40), "Freq", specF, labelWidth: 60);
	slFreq.action = {|ez| synth.set(\freq, ez.value) };

	slFb = EZSlider(win, Rect(20, 90, 360, 40), "Feedback", specFb, labelWidth: 60);
	slFb.action = {|ez| synth.set(\fb, ez.value) };

	win.onClose = { synth.free };
	win.front;

}.play(AppClock)
)



///////////////// PopUpMenu with Synthesis /////////////////////


// Menu selects chaos generator

(
Routine {
	var win, menu, btn, synth;

	SynthDef(\chaosMenu, {|osc=0, freq=2000, amp=0.15|
		var sig = Select.ar(osc, [
			StandardL.ar(freq) * 0.3,
			HenonC.ar(freq) * 0.5,
			GbmanN.ar(freq) * 0.2,
			Crackle.ar(freq.linlin(100, 10000, 1.0, 2.0)) * 0.3
		]);
		sig = LPF.ar(sig, 8000);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\chaosMenu, [\osc, 0, \freq, 2000]);

	win = Window("Chaos", Rect(200, 200, 300, 200));
	win.background = Color.fromHexString("#2d3436");

	menu = PopUpMenu(win, Rect(20, 20, 120, 25));
	menu.items = ["Standard", "Henon", "Gbman", "Crackle"];
	menu.action = {
		synth.set(\osc, menu.value);
		("-> " ++ menu.items[menu.value]).postln;
	};

	btn = Slider(win, Rect(20, 60, 260, 40));
	btn.action = {
		synth.set(\freq, btn.value.linexp(0, 1, 100, 10000));
	};

	win.onClose = { synth.free };
	win.front;

}.play(AppClock)
)



////////////////// MultiSliderView Sequencer ///////////////////


// Demand-driven step sequencer with multislider display

(
Routine {
	var win, ms, numSteps = 16, synth, vals;

	vals = Array.rand(numSteps, 0.0, 1.0);

	SynthDef(\stepSeq, {|rate=10|
		var trig = Impulse.kr(rate);
		var step = Stepper.kr(trig, 0, 0, numSteps - 1);
		var freqs = \freqs.kr(Array.fill(numSteps, { 400 }));
		var freq = Select.kr(step, freqs);
		var sig = Ringz.ar(T2A.ar(trig), freq, 0.1) * 0.2;
		SendReply.kr(trig, '/step', [step]);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\stepSeq, [\freqs, vals.linexp(0, 1, 60, 8000)]);

	win = Window("Step Sequencer", Rect(200, 200, 500, 300));
	win.background = Color.fromHexString("#0f0e17");

	ms = MultiSliderView(win, Rect(20, 20, 460, 260));
	ms.value = vals;
	ms.elasticMode = 1;
	ms.showIndex = true;
	ms.isFilled = true;
	ms.fillColor = Color.fromHexString("#ff8906");
	ms.strokeColor = Color.fromHexString("#f25f4c");
	ms.background = Color.fromHexString("#0f0e17");

	ms.action = {|view|
		vals[view.index] = view.value[view.index];
		synth.set(\freqs, vals.linexp(0, 1, 60, 8000));
	};

	OSCFunc({|msg|
		var step = msg[3].asInteger;
		defer { ms.index = step };
	}, '/step');

	win.onClose = { synth.free };
	win.front;

}.play(AppClock)
)



///////////////// Keyboard and Mouse ///////////////////////////


// Keyboard as UGen

{ Dust.ar(KeyState.kr(0, 200, 10, 4)) }.play(AppClock);


// Mouse position as UGen

{ HPF.ar(Impulse.ar(MouseX.kr(20, 1000, 1), 0, 0.2), MouseY.kr(20, 10000, 1)) }.play(AppClock);


// Keyboard triggers with DynKlank resonance

(
SynthDef(\keyRes, {|freq=400|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, 0.6), doneAction: 2);
	sig = DynKlank.ar(
		`[[freq, freq * 2.3, freq * 4.7], nil, [0.3, 0.15, 0.08]],
		Impulse.ar(0) * 0.05
	);
	Out.ar(0, sig * env ! 2);
}).add;

w = Window.new("Keys", Rect(200, 300, 400, 400));
w.background = Color.fromHexString("#2d3436");
w.view.keyDownAction = {|view, char|
	Synth(\keyRes, [\freq, char.ascii.linexp(32, 127, 60, 8000)])
};

w.front
)


// Click position controls cross-FM parameters

(
SynthDef(\xyFM, {|freqA=200, freqB=300|
	var sig, env, fbIn;
	env = EnvGen.ar(Env.perc(0.01, 1.5), doneAction: 2);
	fbIn = LocalIn.ar(2);
	sig = SinOsc.ar([freqA, freqB] + (fbIn.reverse * [freqB, freqA] * 3));
	LocalOut.ar(sig);
	Out.ar(0, LeakDC.ar(sig) * env * 0.15);
}).add;

w = Window.new("Cross-FM XY", Rect(200, 300, 600, 600));
w.background = Color.fromHexString("#0f0e17");
w.view.mouseDownAction = {|view, x, y|
	Synth(\xyFM, [
		\freqA, x.linexp(0, 600, 20, 4000),
		\freqB, y.linexp(0, 600, 20, 4000)
	])
};

w.front
)



//////////////////// Pen and UserView //////////////////////////


// Draw where you click, each click also plays

(
SynthDef(\dotTone, {|freq=400, pan=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.001, 0.3), doneAction: 2);
	sig = Ringz.ar(Impulse.ar(0), freq, 0.15) * 0.3;
	Out.ar(0, Pan2.ar(sig * env, pan));
}).add;

w = Window("Sound Drawing", Rect(200, 200, 500, 500));
~pts = [];
~v = UserView(w, w.view.bounds);
~v.background_(Color.fromHexString("#0f0e17"));

~v.drawFunc = {
	~pts.do {|pt|
		Pen.fillColor = Color.hsv(
			pt.x / 500,
			0.8,
			pt.y.linlin(0, 500, 0.9, 0.3)
		);
		Pen.fillOval(Rect(pt.x - 4, pt.y - 4, 8, 8));
	};
};

~v.mouseDownAction = {|view, x, y|
	~pts = ~pts.add(Point(x, y));
	Synth(\dotTone, [
		\freq, x.linexp(0, 500, 60, 8000),
		\pan, x.linlin(0, 500, -1, 1)
	]);
	~v.refresh;
};

w.front;
)


// Animated particle system

(
var win, view, particles;

particles = Array.fill(40, {
	(x: 200.0.rand + 100, y: 200.0.rand + 100,
	 vx: rrand(-2.0, 2.0), vy: rrand(-2.0, 2.0),
	 hue: 1.0.rand)
});

win = Window("Particles", Rect(200, 200, 400, 400));

view = UserView(win, win.view.bounds)
	.background_(Color.black)
	.animate_(true)
	.frameRate_(60)
	.drawFunc_({
		particles.do {|p|
			p[\x] = p[\x] + p[\vx];
			p[\y] = p[\y] + p[\vy];

			if(p[\x] < 0 or: { p[\x] > 400 }, { p[\vx] = p[\vx].neg });
			if(p[\y] < 0 or: { p[\y] > 400 }, { p[\vy] = p[\vy].neg });

			Pen.fillColor = Color.hsv(p[\hue], 0.7, 0.9, 0.6);
			Pen.fillOval(Rect(p[\x] - 3, p[\y] - 3, 6, 6));
		};
	});

win.front;
)



///////////// Experimental: Sound-Reactive GUI //////////////////


// Amplitude-driven circle

(
Routine {
	var win, view, synth, bus;

	bus = Bus.control(s, 1);

	SynthDef(\tracker, {
		var sig, amp;
		sig = Resonz.ar(Dust.ar(30),
			LFNoise1.kr(0.5).range(200, 2000), 0.05, 20);
		amp = Amplitude.kr(sig, 0.01, 0.2);
		Out.kr(bus, amp);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\tracker);

	win = Window("Reactive", Rect(200, 200, 400, 400));

	view = UserView(win, win.view.bounds)
		.background_(Color.black)
		.animate_(true)
		.frameRate_(30)
		.drawFunc_({
			var amp = bus.getSynchronous;
			var size = amp.linlin(0, 0.5, 20, 300);
			Pen.fillColor = Color.hsv(
				amp.linlin(0, 0.5, 0.5, 0.0), 0.8, 0.9
			);
			Pen.fillOval(Rect(
				200 - (size / 2), 200 - (size / 2), size, size
			));
		});

	win.onClose = { synth.free; bus.free };
	win.front;

}.play(AppClock)
)


// XY pad controlling granular texture

(
Routine {
	var win, view, synth, xVal = 0.5, yVal = 0.5;

	SynthDef(\xyGrain, {|freq=400, density=10, amp=0.3|
		var sig, trig;
		trig = Dust.ar(density);
		sig = Ringz.ar(trig, freq * TRand.ar(0.8, 1.2, trig), 0.05);
		sig = sig * Decay2.ar(trig, 0.001, 0.05) * amp;
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\xyGrain);

	win = Window("XY Pad", Rect(200, 200, 400, 400));
	win.background = Color.fromHexString("#1a1a2e");

	view = UserView(win, win.view.bounds);
	view.background_(Color.clear);

	view.drawFunc = {
		Pen.fillColor = Color.fromHexString("#e94560");
		Pen.fillOval(Rect(
			xVal * 380 + 5,
			yVal * 380 + 5,
			15, 15
		));

		Pen.strokeColor = Color.white(0.3);
		Pen.width = 1;
		Pen.line(0 @ (yVal * 400), 400 @ (yVal * 400));
		Pen.line((xVal * 400) @ 0, (xVal * 400) @ 400);
		Pen.stroke;
	};

	view.mouseMoveAction = {|v, x, y|
		xVal = (x / 400).clip(0, 1);
		yVal = (y / 400).clip(0, 1);
		synth.set(\freq, xVal.linexp(0, 1, 60, 6000));
		synth.set(\density, yVal.linexp(0, 1, 1, 200));
		view.refresh;
	};

	view.mouseDownAction = view.mouseMoveAction;
	win.onClose = { synth.free };
	win.front;

}.play(AppClock)
)


// Waveform scope with Pen

(
Routine {
	var win, view, synth, buf, data;

	buf = Buffer.alloc(s, 512, 1);
	data = Array.fill(512, { 0 });

	SynthDef(\scopeSynth, {|bufnum|
		var sig = StandardL.ar(
			LFNoise1.kr(0.3).range(2000, 10000)
		) * 0.15;
		sig = LPF.ar(sig, 4000);
		RecordBuf.ar(sig, bufnum, loop: 1);
		Out.ar(0, sig ! 2);
	}).add;

	s.sync;
	synth = Synth(\scopeSynth, [\bufnum, buf]);

	win = Window("Scope", Rect(200, 200, 530, 280));
	win.background = Color.black;

	view = UserView(win, Rect(10, 10, 510, 260))
		.background_(Color.black)
		.animate_(true)
		.frameRate_(30)
		.drawFunc_({
			buf.getn(0, 512, {|d| data = d });

			Pen.strokeColor = Color.fromHexString("#00cec9");
			Pen.width = 1.5;
			Pen.moveTo(0 @ (data[0].linlin(-1, 1, 250, 10)));

			data.do {|val, i|
				Pen.lineTo(
					(i / 512 * 510) @ val.linlin(-1, 1, 250, 10)
				);
			};

			Pen.stroke;
		});

	win.onClose = { synth.free; buf.free };
	win.front;

}.play(AppClock)
)
