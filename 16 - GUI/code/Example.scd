////////////////////////////////////////////////////////////////
//
//                      GUI Example
//
////////////////////////////////////////////////////////////////

( // SynthDef

SynthDef(\bliped, {|freq=100, modFreq=6, atk=0.1, sus=1, rel=1, gate=1, harms=150|
	var env = EnvGen.ar(Env.asr(atk,sus,rel), gate, doneAction:2);
	var sig = Splay.ar(HPF.ar(Blip.ar(Array.series(4, freq, 5), harms), 30)) * 0.6;
	sig = BBandStop.ar(sig, LFNoise1.ar(1).exprange(100, 8000), 4);
	sig = sig * env;
	Out.ar(0, LPF.ar(sig, 12000))
}).add

)


( // Interface with synth and pattern controls

var pb, ps, dp = PatternProxy();
dp.source = 0.1;
w = Window("GUI Interface", Rect(400,400,400,400));
w.background = Color.fromHexString("#49392C");
pb = Button(w, Rect(10,10,100,100));
pb.states = [
	["play synth", Color.cyan, Color.fromHexString("#49392C")],
	["stop synth", Color.black, Color.white]
];
pb.action = {|b|
	if(b.value == 1,
		{ x = Synth(\bliped) },
		{ x.set(\gate,0) }
	)
};
~f = Slider(w, Rect(120,10,100,100));
~f.action = { x.set(\freq, ~f.value.linlin(0,1,100,1000)) };
~h = Slider(w, Rect(220,10,100,100));
~h.action = { x.set(\harms, ~h.value.linlin(0.0,1.0,2,200)) };
~pt = Button(w, Rect(10,150,100,100));
~pt.states = [
	["play pattern", Color.black, Color.white],
	["stop pattern", Color.white, Color.black],
];
~pt.action = {|b|
	if(b.value == 1,
		{ p = Pbind(\instrument, \bliped, \dur, dp, \freq, 80, \harms, 70).play; },
		{ p.stop }
	)
};
ps = Knob(w, Rect(120,150,100,100));
ps.action = { dp.source = 0.1 + ps.value; };
w.front;

)
