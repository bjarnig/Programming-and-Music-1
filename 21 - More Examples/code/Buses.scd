////////////////////////////////////////////////////////////////
//
//                     Buses and Groups
//
////////////////////////////////////////////////////////////////


(

SynthDef("testbus", { arg bus, freqOffset = 0;

	// this will add freqOffset to whatever is read in from the bus
	Out.ar(0, SinOsc.ar(In.kr(bus) + freqOffset, 0, 0.5));

}).add;


SynthDef("testbuskr", { arg freq = 400, bus;
	Out.kr(bus, SinOsc.kr(1, 0, freq/40, freq));
}).add;

b = Bus.control(s,1);

)

(

x = Synth("testbuskr", [\bus, b.index]);

y = Synth.after(x, "testbus", [\bus, b.index]);

z = Synth.after(x, "testbus", [\bus, b.index, \freqOffset, 200]);

)

x.free; y.free; z.free; b.free;


/* use Buses and Groups */

(
	SynthDef("saw", { arg out=0, freq=100, amp=0.3;
		var sig;
		sig = Saw.ar(freq, amp);
		Out.ar(out, sig);
	}).add;

	SynthDef("noise", { arg out=0, amp=0.3;
		var sig;
		sig = Crackle.ar(1.99, mul: amp);
		Out.ar(out, sig);
	}).add;

	SynthDef("reson", { arg in=0, out=0;
		var sig;
		sig = In.ar(in);
		sig = Resonz.ar(sig, LFNoise2.kr(2.6).range(100, 1000), 0.2, 5);
		ReplaceOut.ar(out, sig);
	}).add;

	SynthDef("chop", { arg in=0, out=0;
		var sig;
		sig = In.ar(in);
		sig = LFPulse.ar(5, mul: sig);
		ReplaceOut.ar(out, sig);
	}).add;
)

~saw = Synth("saw");

// new nodes get placed before the others (by default):
~res = Synth("reson")

// but a node can be moved somewhere else:
~res.moveAfter(~saw)

// nodes can be un/muted:
~res.run(false)
~res.run(true)

~saw.free;  ~res.free;

// this node reads from bus 1 and (over)writes to bus 0:
~chop = Synth("chop", [\in, 1, \out, 0])

// this writes to bus 1:
~noise = Synth("noise", [\out, 1])

// create this node in the right position:
~res = Synth.after(~chop, "reson")

// and set its busses:
~res.set(\in, 1, \out, 1)

~res.free; ~noise.free; ~chop.free;


~src = Group(s);
~fx = Group.after(~src);

~saw = Synth("saw", [\out, 1], ~src);
~noise = Synth("noise", target: ~src);

~chop = Synth("chop", [\in, 1, \out, 1], ~fx)
~res = Synth("reson", target: ~fx)

~fx.run(false)
~fx.run(true)

~fx.moveBefore(~src)
~src.moveBefore(~fx)
