////////////////////////////////////////////////////////////////
//
//                        UGens
//
////////////////////////////////////////////////////////////////

Misc server issues.

( // Careful with sound volumes. Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


///////////////////////// Timing ////////////////////////////////

// Default latency is 20 ms
s.latency

// Set it to 50 ms
s.latency = 0.05

// Use the latency instead of 'as soon as possible'
s.bind { Synth(\sonology); };

// Simple synths using OffsetOut and Out
(
SynthDef(\no, {|freq=400, amp=0.1|
	var sig = SinOsc.ar * Line.ar(1,0,0.1,doneAction:2);
Out.ar(0, sig * amp ! 2)
}).add;

SynthDef(\oo, {|freq=400, amp=0.1|
	var sig = SinOsc.ar * Line.ar(1,0,0.1,doneAction:2);
OffsetOut.ar(0, sig * amp ! 2)
}).add;
)

( // Offset out
{
	inf.do {|i|
		s.bind {  Synth(\oo); };
		0.01.wait;
	}
}.fork;
)


( // Out
{
	inf.do {|i|
		s.bind {  Synth(\no); };
		0.01.wait;
	}
}.fork;
)




///////////////////////// Demand rate //////////////////////////

( // Demand need a trigger and a demand rate Ugen
	{
	var seq, demand, pulse;
	seq = Dseq([1,2,3] * 100, inf);
	pulse = Impulse.ar(10);
	demand = Demand.ar(pulse, 0, seq);
	Saw.ar(demand) * 0.02 ! 2
	}.play
)


( // Works with multichannel expansion and nested patterns
	{
	var seq, demand, pulse, times=10, speed=25;
	seq = Dbrown(0, Dwhite(0.1,1.0,inf), Array.rand(times, 0.01, 0.8));
	pulse = Impulse.ar(speed);
	demand = Demand.ar(pulse, 0, seq * 1000).poll;
	Splay.ar(Impulse.ar(demand), level:0.5)
	}.play
)


( // Duty allows to set the demand rate to a list of duration
	{
	var duty = Duty.ar(Dwhite(0.2, 1.5,inf), 0, Dwhite(100,1000,inf));
	LPF.ar(WhiteNoise.ar, Lag.ar(duty, 5))  ! 2;
	}.play
)


( // Demand for wavefroms, sequence and varies frequency
	{
	var trig, movement;
	trig = Impulse.ar(SinOsc.kr(0.1, 0, 6000, 8000));
	movement = Dseq([Dbrown(-0.1,0.1,0.5,32), Dbrown(-0.8,0.8,0.5,16)], inf);
	Demand.ar(trig, 0, movement) ! 2 * 0.15;
	}.play;
)




///////////////////////// Triggers ////////////////////////////////

( // Impulse to trigger an envelope
	{
	SinOsc.ar([400,420], mul: EnvGen.kr(Env.perc(0.001, 1.0), Impulse.kr(4)))
	}.play
)

( // Trand generates random number on a trigger
	{
	var trig, speed=25, env;
	trig = Impulse.kr(SinOsc.kr(0.1,0,10,15));
	env = EnvGen.kr(Env.perc(0.001, 1/speed), trig);
	SinOsc.ar(TRand.kr(2400, 2600, trig), mul: env)
	}.play
)

( // Triggering increments a counter
	{
	Saw.ar(Stepper.ar(Impulse.ar(5),0,10,100,10)*10, 0.1)
	}.play
)

( // Sample and hold on a trigger
	{
		Saw.ar(Latch.ar(SinOsc.ar(666),
		Impulse.ar(Line.kr(80,200,10))).range(100,1000), 0.1) ! 2
	}.play
)

)
