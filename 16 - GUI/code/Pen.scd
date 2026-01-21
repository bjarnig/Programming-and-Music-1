////////////////////////////////////////////////////////////////
//
//                   UserView and Pen
//
////////////////////////////////////////////////////////////////


////////////////////////// Basic UserView ///////////////////////////

( // Colored square

w = Window("UserView", Rect(200, 200, 400, 400));
~v = UserView(w, Rect(100, 100, 200, 200))
	.background_(Color.rand);
w.front;

)


( // Custom drawing

w = Window("Custom Drawing", Rect(200, 200, 400, 400));
~v = UserView(w, Rect(50, 50, 300, 300));
~v.drawFunc = {
	Pen.strokeColor = Color.red;
	Pen.width = 5;
	Pen.strokeRect(Rect(10, 10, 280, 280));
};
w.front;

)


////////////////////////// Lines ///////////////////////////

( // Single line

w = Window("Line", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.background_(Color.white);
~v.drawFunc = {
	Pen.strokeColor = Color.black;
	Pen.width = 3;
	Pen.line(50@50, 350@350);
	Pen.stroke;
};
w.front;

)


( // Grid lines

w = Window("Lines", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.background_(Color.white);
~v.drawFunc = {
	Pen.strokeColor = Color.blue;
	Pen.width = 2;
	10.do {|i|
		Pen.line(0@(i*40), 400@(i*40));
		Pen.stroke;
		Pen.line((i*40)@0, (i*40)@400);
		Pen.stroke;
	};
};
w.front;

)


////////////////////////// Shapes ///////////////////////////

( // Rectangle

w = Window("Rectangle", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.drawFunc = {
	Pen.fillColor = Color.cyan;
	Pen.fillRect(Rect(100, 100, 200, 150));
};
w.front;

)


( // Circle

w = Window("Circle", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.drawFunc = {
	Pen.fillColor = Color.yellow;
	Pen.fillOval(Rect(100, 100, 200, 200));
};
w.front;

)


( // Multiple shapes

w = Window("Shapes", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.background_(Color.gray(0.2));
~v.drawFunc = {
	Pen.fillColor = Color.red(0.7);
	Pen.fillRect(Rect(50, 50, 100, 100));
	Pen.fillColor = Color.blue(0.7);
	Pen.fillOval(Rect(200, 50, 100, 100));
	Pen.fillColor = Color.green(0.7);
	Pen.moveTo(125@200);
	Pen.lineTo(50@300);
	Pen.lineTo(200@300);
	Pen.lineTo(125@200);
	Pen.fill;
};
w.front;

)


////////////////////////// Interactive ///////////////////////////

( // Click to change color

w = Window("Click Me", Rect(200, 200, 400, 400));
~c = Color.rand;
~v = UserView(w, w.view.bounds);
~v.drawFunc = {
	Pen.fillColor = ~c;
	Pen.fillRect(Rect(100, 100, 200, 200));
};
~v.mouseDownAction = {
	~c = Color.rand;
	~v.refresh;
};
w.front;

)


( // Draw where you click

w = Window("Drawing", Rect(200, 200, 400, 400));
~pts = [];
~v = UserView(w, w.view.bounds);
~v.background_(Color.white);
~v.drawFunc = {
	Pen.fillColor = Color.red;
	~pts.do {|pt|
		Pen.fillOval(Rect(pt.x - 5, pt.y - 5, 10, 10));
	};
};
~v.mouseDownAction = {|view, x, y|
	~pts = ~pts.add(Point(x, y));
	~v.refresh;
};
w.front;

)

( // Random circles

w = Window("Random Circles", Rect(200, 200, 400, 400));
~v = UserView(w, w.view.bounds);
~v.background_(Color.black);
~v.drawFunc = {
	20.do {
		Pen.fillColor = Color.rand;
		Pen.fillOval(Rect(
			400.rand,
			400.rand,
			50.rand + 10,
			50.rand + 10
		));
	};
};
~v.mouseDownAction = { ~v.refresh };
w.front;

)
