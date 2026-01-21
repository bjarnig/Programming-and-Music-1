////////////////////////////////////////////////////////////////
//
//                   Routines with GUI
//
////////////////////////////////////////////////////////////////


////////////////////////// Defer ///////////////////////////

( // Update GUI from Routine

w = Window("Counter", Rect(200, 200, 200, 200));
t = StaticText(w, Rect(50, 80, 100, 50))
	.font_(Font("Arial", 36))
	.align_(\center);
w.front;
Routine({
	10.do {|i|
		defer{ t.string = i.asString };
		1.wait;
	};
}).play;

)

////////////////////////// Animation ///////////////////////////

( // Bouncing ball

var w, v, x = 200, y = 50, vx = 5, vy = 0, g = 0.5;
w = Window("Bouncing Ball", Rect(200, 200, 400, 400));
v = UserView(w, w.view.bounds)
	.background_(Color.white)
	.animate_(true)
	.frameRate_(60)
	.drawFunc_({
		vy = vy + g;
		y = y + vy;
		x = x + vx;
		if(y > 380, {
			y = 380;
			vy = vy * -0.9;
		});
		if((x < 20) or: (x > 380), {
			vx = vx * -1;
		});
		Pen.fillColor = Color.red;
		Pen.fillOval(Rect(x - 10, y - 10, 20, 20));
	});
w.front;

)


( // Random walk slider

w = Window("Random Walk", Rect(200, 200, 400, 200));
~s = Slider(w, Rect(20, 20, 360, 40));
~n = NumberBox(w, Rect(150, 80, 100, 40));
w.front;
~v = 0.5;
Routine({
	inf.do {
		~v = (~v + rrand(-0.05, 0.05)).clip(0, 1);
		defer{
			~s.value = ~v;
			~n.value = ~v;
		};
		0.1.wait;
	};
}).play;

)


( // Progress bar

var w, p, t;
w = Window("Progress", Rect(200, 200, 400, 150));
t = StaticText(w, Rect(150, 20, 100, 30))
	.align_(\center)
	.font_(Font("Arial", 18));
p = Slider(w, Rect(20, 60, 360, 30))
	.orientation_(\horizontal);
w.front;
Routine({
	100.do {|i|
		defer{
			p.value = i / 100;
			t.string = (i + 1).asString ++ "%";
		};
		0.05.wait;
	};
	defer{ t.string = "Done!" };
}).play;

)


( // Color animation

var w, v;
w = Window("Color Fade", Rect(200, 200, 400, 400));
v = UserView(w, w.view.bounds)
	.background_(Color.rand);
w.front;
Routine({
	inf.do {
		defer{ v.background = Color.rand };
		0.1.wait;
	};
}).play;

)


( // Real-time clock

var w, c;
w = Window("Clock", Rect(200, 200, 400, 150));
c = StaticText(w, w.view.bounds)
	.font_(Font(Font.defaultMonoFace, 48))
	.align_(\center)
	.stringColor_(Color.white);
w.background_(Color.black);
w.front;
Routine({
	inf.do {
		defer{
			c.string = Date.getDate.format("%H:%M:%S");
		};
		1.wait;
	};
}).play;

)


( // Wave animation

var w, s;
w = Window("Waves", Rect(200, 200, 400, 400));
s = 8.collect {|i|
	Slider(w, Rect(i * 50 + 10, 50, 40, 300))
};
w.front;
~p = 0;
Routine({
	inf.do {
		s.do {|sl, i|
			defer{
				sl.value = sin(~p + (i * 0.5)).linlin(-1, 1, 0, 1);
			};
		};
		~p = ~p + 0.1;
		0.05.wait;
	};
}).play;

)
