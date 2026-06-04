////////////////////////////////////////////////////////////////
//
//     Chained effects with buses + groups
//
////////////////////////////////////////////////////////////////


(

SynthDef(\src, {|out=0, freq=110, dur=0.3, amp=0.3|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.005, dur), doneAction: 2);
	sig = Saw.ar([freq, freq * 1.005]) * 0.5;
	sig = sig + (SinOsc.ar(freq * 0.5) * 0.3);
	Out.ar(out, sig * env * amp);
}).add;

SynthDef(\fxDist, {|in=0, out=0, drive=2.0, mix=0.5|
	var dry  = In.ar(in, 2);
	var wet  = (dry * drive).tanh;
	ReplaceOut.ar(out, XFade2.ar(dry, wet, mix.linlin(0, 1, -1, 1)));
}).add;

SynthDef(\fxFilter, {|in=0, out=0, cutoff=2000, res=0.4, lfo=0.2, lfoDepth=0.5|
	var dry  = In.ar(in, 2);
	var mod  = SinOsc.kr(lfo).range(1 - lfoDepth, 1 + lfoDepth);
	var wet  = RLPF.ar(dry, (cutoff * mod).clip(60, 18000), res);
	ReplaceOut.ar(out, wet);
}).add;

SynthDef(\fxDelay, {|in=0, out=0, time=0.25, fb=0.5, mix=0.4|
	var dry = In.ar(in, 2);
	var wet = CombL.ar(dry, 1.0, time, fb * 4);
	ReplaceOut.ar(out, XFade2.ar(dry, wet, mix.linlin(0, 1, -1, 1)));
}).add;

SynthDef(\fxVerb, {|in=0, out=0, room=0.7, damp=0.4, mix=0.3|
	var dry = In.ar(in, 2);
	var wet = FreeVerb2.ar(dry[0], dry[1], 1.0, room, damp);
	ReplaceOut.ar(out, XFade2.ar(dry, wet, mix.linlin(0, 1, -1, 1)));
}).add;

SynthDef(\fxOut, {|in=0, out=0, amp=0.8|
	var sig = In.ar(in, 2);
	Out.ar(out, sig * amp);
}).add;

)


(

~bus = Bus.audio(s, 2);
~src = Group.new;
~fx  = Group.after(~src);

~dist   = Synth(\fxDist,   [\in, ~bus, \out, ~bus, \drive, 3.0,  \mix, 0.6], ~fx);
~filter = Synth.after(~dist,   \fxFilter, [\in, ~bus, \out, ~bus, \cutoff, 1500]);
~delay  = Synth.after(~filter, \fxDelay,  [\in, ~bus, \out, ~bus, \time, 0.33, \fb, 0.55, \mix, 0.4]);
~verb   = Synth.after(~delay,  \fxVerb,   [\in, ~bus, \out, ~bus, \room, 0.85, \mix, 0.4]);

~tap = Synth.after(~verb, \fxOut, [\in, ~bus, \out, 0]);
)

(

Pdef(\hits,
	Pbind(
		\instrument, \src,
		\group, ~src,
		\out,   ~bus,
		\dur,   Pwhite(0.12, 0.4),
		\freq,  Pseq([55, 82, 110, 165], inf),
		\amp,   Pwhite(0.15, 0.35)
	)
).play;

)

~dist.set(\drive, 8, \mix, 0.8);
~filter.set(\cutoff, 400, \lfo, 0.8, \lfoDepth, 0.7);
~delay.set(\time, 0.18, \fb, 0.7);
~verb.set(\room, 0.95, \mix, 0.6);

~filter.moveAfter(~delay);


~dist.run(false);
~dist.run(true);
