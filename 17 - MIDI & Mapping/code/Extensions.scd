////////////////////////////////////////////////////////////////
//
//                       Extensions
//
////////////////////////////////////////////////////////////////

Time-dependent and state-dependent extensions for MIDI CC.
These techniques extend basic position mapping with velocity,
direction, randomness, memory, and chase-based control.

See: https://github.com/postnature/delta-control


MIDIClient.init; MIDIIn.connectAll;



////////////////////// Test SynthDefs //////////////////////////

// Flexible SynthDef used across the examples below.
// Evaluate this block first, then try any section.

(
SynthDef(\ext, {|freq=400, amp=0.3, drive=0, ffreq=2000, rq=0.5, pan=0|
	var sig;
	sig = Saw.ar(freq);
	sig = (sig * (1 + (drive * 10))).tanh;
	sig = RLPF.ar(sig, ffreq.clip(20, 18000), rq.clip(0.01, 2));
	Out.ar(0, Pan2.ar(sig * amp, pan));
}).add;
)



///////////////// 1. Speed / Velocity //////////////////////////


( // Direct velocity mapping: speed controls distortion amount

Routine {
	var synth, lastTime, lastVal;
	lastTime = Main.elapsedTime;
	lastVal = 0;

	SynthDef(\extV, {|freq=400, amp=0.3, drive=0|
		var sig;
		sig = Saw.ar(freq);
		sig = (sig * (1 + (drive * 10))).tanh;
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extV);

	MIDIFunc.cc({|val|
		var now, delta, speed, freq;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastTime = now;
		lastVal = val;

		freq = val.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		synth.set(\drive, speed.linlin(0, 500, 0, 1).clip(0, 1));
		("speed:" + speed.round(0.1) + "drive:" + speed.linlin(0,500,0,1).clip(0,1).round(0.01)).postln;
	});

}.play
)



( // Velocity threshold (DeltaThresh): behaviour splits at a speed boundary

Routine {
	var synth, lastTime, lastVal, threshold;
	lastTime = Main.elapsedTime;
	lastVal = 0;
	threshold = 200;

	SynthDef(\extVT, {|freq=400, amp=0.3, drive=0, ffreq=4000|
		var sig;
		sig = Saw.ar(freq);
		sig = (sig * (1 + (drive * 10))).tanh;
		sig = RLPF.ar(sig, ffreq, 0.3);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extVT);

	MIDIFunc.cc({|val|
		var now, delta, speed, freq;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastTime = now;
		lastVal = val;

		freq = val.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);

		if(speed > threshold, {
			synth.set(\drive, 0.8);
			synth.set(\ffreq, 8000);
			("FAST:" + speed.round(0.1)).postln;
		}, {
			synth.set(\drive, 0);
			synth.set(\ffreq, 1500);
			("slow:" + speed.round(0.1)).postln;
		});
	});

}.play
)



/////////////// 2. Polarity and Direction //////////////////////


( // Direction of movement selects filter mode

Routine {
	var synth, lastVal;
	lastVal = 0;

	SynthDef(\extDir, {|freq=400, amp=0.3, ffreq=2000, mode=0|
		var sig, lo, hi;
		sig = PinkNoise.ar;
		lo = LPF.ar(sig, ffreq);
		hi = HPF.ar(sig, ffreq);
		sig = SelectX.ar(mode, [lo, hi]);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extDir);

	MIDIFunc.cc({|val|
		var direction;
		direction = (val - lastVal).sign;
		lastVal = val;

		synth.set(\ffreq, val.linexp(0, 127, 200, 8000));

		case
		{ direction > 0 } { synth.set(\mode, 0); "UP -> LPF".postln }
		{ direction < 0 } { synth.set(\mode, 1); "DOWN -> HPF".postln };
	});

}.play
)



( // Direction and magnitude shape amplitude envelope trigger

Routine {
	var lastVal, lastTime;
	lastVal = 0;
	lastTime = Main.elapsedTime;

	SynthDef(\ping, {|freq=800, amp=0.3, pan=0|
		var sig, env;
		env = EnvGen.ar(Env.perc(0.005, 0.3), doneAction:2);
		sig = SinOsc.ar(freq);
		Out.ar(0, Pan2.ar(sig * env * amp, pan));
	}).add;

	s.sync;

	MIDIFunc.cc({|val|
		var direction, speed, delta, now;
		now = Main.elapsedTime;
		delta = now - lastTime;
		direction = (val - lastVal).sign;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastVal = val;
		lastTime = now;

		if(speed > 100, {
			Synth(\ping, [
				\freq, val.linexp(0, 127, 200, 4000),
				\amp, speed.linlin(100, 500, 0.05, 0.4).clip(0.05, 0.4),
				\pan, direction
			]);
			("ping! dir:" + direction + "speed:" + speed.round(0.1)).postln;
		});
	});

}.play
)



////////////////// 3. Randomness / Jitter //////////////////////


( // Add configurable jitter to CC position

Routine {
	var synth, jitter;
	jitter = 10;

	SynthDef(\extJ, {|freq=400, amp=0.3|
		var sig = Saw.ar(freq);
		sig = RLPF.ar(sig, freq * 2, 0.3);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extJ);

	MIDIFunc.cc({|val|
		var jittered, freq;
		jittered = (val + rrand(jitter.neg, jitter)).clip(0, 127);
		freq = jittered.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		("raw:" + val + "jittered:" + jittered.round(0.1)).postln;
	});

}.play
)



( // Increasing jitter with speed: faster movement = more noise

Routine {
	var synth, lastTime, lastVal;
	lastTime = Main.elapsedTime;
	lastVal = 0;

	SynthDef(\extJS, {|freq=400, amp=0.3|
		var sig = Saw.ar(freq);
		sig = RLPF.ar(sig, freq * 2, 0.3);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extJS);

	MIDIFunc.cc({|val|
		var now, delta, speed, jitter, jittered, freq;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastTime = now;
		lastVal = val;

		jitter = speed.linlin(0, 400, 0, 20).clip(0, 20);
		jittered = (val + rrand(jitter.neg, jitter)).clip(0, 127);
		freq = jittered.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		("jitter:" + jitter.round(0.1) + "val:" + jittered.round(0.1)).postln;
	});

}.play
)



//////////////////// 4. Drunk Walk /////////////////////////////


( // Drunk walk drifts around the CC target position

Routine {
	var synth, drunkPos, stepSize, tendency;
	drunkPos = 64.0;
	stepSize = 5;
	tendency = 0.3;

	SynthDef(\extD, {|freq=400, amp=0.3|
		var sig = LFTri.ar(freq);
		sig = RLPF.ar(sig, freq * 3, 0.4);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extD);

	MIDIFunc.cc({|val|
		var pull, step, freq;
		pull = (val - drunkPos) * tendency;
		step = rrand(stepSize.neg.asFloat, stepSize.asFloat);
		drunkPos = (drunkPos + pull + step).clip(0, 127);
		freq = drunkPos.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		("target:" + val + "drunk:" + drunkPos.round(0.1)).postln;
	});

}.play
)



( // Drunk walk with speed-dependent step size

Routine {
	var synth, drunkPos, lastTime, lastVal, tendency;
	drunkPos = 64.0;
	lastTime = Main.elapsedTime;
	lastVal = 0;
	tendency = 0.2;

	SynthDef(\extDS, {|freq=400, amp=0.3, pan=0|
		var sig = LFTri.ar(freq);
		sig = RLPF.ar(sig, freq * 3, 0.4);
		Out.ar(0, Pan2.ar(sig * amp, pan));
	}).add;

	s.sync;
	synth = Synth(\extDS);

	MIDIFunc.cc({|val|
		var now, delta, speed, stepSize, pull, step, freq;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastTime = now;
		lastVal = val;

		stepSize = speed.linlin(0, 300, 1, 15).clip(1, 15);
		pull = (val - drunkPos) * tendency;
		step = rrand(stepSize.neg, stepSize.asFloat);
		drunkPos = (drunkPos + pull + step).clip(0, 127);
		freq = drunkPos.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		synth.set(\pan, drunkPos.linlin(0, 127, -1.0, 1.0));
		("step:" + stepSize.round(0.1) + "drunk:" + drunkPos.round(0.1)).postln;
	});

}.play
)



/////////// 5. History / Region / Threshold ////////////////////


( // Rolling history with region detection

Routine {
	var synth, history, histSize, midpoint;
	histSize = 32;
	midpoint = 64;
	history = Array.fill(histSize, { 64 });

	SynthDef(\extH, {|freq=400, amp=0.3, drive=0|
		var sig;
		sig = Saw.ar(freq);
		sig = (sig * (1 + (drive * 10))).tanh;
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extH);

	MIDIFunc.cc({|val|
		var crossed, lo, hi;
		history = history.drop(1).add(val);
		lo = history.minItem;
		hi = history.maxItem;
		crossed = (lo < midpoint) and: { hi > midpoint };

		synth.set(\freq, val.linexp(0, 127, 100, 2000));

		if(crossed, {
			synth.set(\drive, 0.6);
			("CROSSED midpoint! range:" + lo + "-" + hi).postln;
		}, {
			synth.set(\drive, 0);
			("range:" + lo + "-" + hi).postln;
		});
	});

}.play
)



( // Threshold crossing with hysteresis

Routine {
	var synth, wasAbove, upperThresh, lowerThresh;
	upperThresh = 80;
	lowerThresh = 50;
	wasAbove = false;

	SynthDef(\extTH, {|freq=400, amp=0.3, ffreq=2000|
		var sig;
		sig = Saw.ar(freq) + PinkNoise.ar(0.1);
		sig = RLPF.ar(sig, ffreq, 0.3);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extTH);

	MIDIFunc.cc({|val|
		synth.set(\freq, val.linexp(0, 127, 100, 2000));

		if(wasAbove.not and: { val > upperThresh }, {
			wasAbove = true;
			synth.set(\ffreq, 8000);
			"-> ABOVE threshold: bright".postln;
		});

		if(wasAbove and: { val < lowerThresh }, {
			wasAbove = false;
			synth.set(\ffreq, 500);
			"-> BELOW threshold: dark".postln;
		});
	});

}.play
)



( // Unlock a layer once a region has been visited

Routine {
	var synth, layer, unlocked, history, histSize;
	histSize = 64;
	history = Array.fill(histSize, { 64 });
	unlocked = false;

	SynthDef(\extBase, {|freq=400, amp=0.3|
		var sig = Saw.ar(freq);
		sig = RLPF.ar(sig, freq * 2, 0.4);
		Out.ar(0, sig * amp ! 2);
	}).add;

	SynthDef(\extLayer, {|freq=200, amp=0.15, gate=1|
		var sig, env;
		env = Linen.kr(gate, 2, 1, 2, doneAction:2);
		sig = SinOsc.ar([freq, freq * 1.005]);
		Out.ar(0, sig * amp * env);
	}).add;

	s.sync;
	synth = Synth(\extBase);

	MIDIFunc.cc({|val|
		var lo, hi, spansLow, spansHigh;
		history = history.drop(1).add(val);
		lo = history.minItem;
		hi = history.maxItem;
		spansLow = lo < 20;
		spansHigh = hi > 107;

		synth.set(\freq, val.linexp(0, 127, 100, 2000));

		if(unlocked.not and: { spansLow and: spansHigh }, {
			unlocked = true;
			layer = Synth(\extLayer, [\freq, 150]);
			"*** LAYER UNLOCKED: full range explored ***".postln;
		});

		if(unlocked, {
			layer.set(\freq, val.linlin(0, 127, 80, 400));
		});
	});

}.play
)



/////////////////// 6. ChaseValue //////////////////////////////

// Only maximum velocity returns the actual CC position.
// Slower movements map to a value between minimum and position.
// Like gravity: momentum carries you, slow movement drops you.


( // ChaseValue: velocity-scaled position

Routine {
	var synth, lastTime, lastVal, maxSpeed;
	lastTime = Main.elapsedTime;
	lastVal = 0;
	maxSpeed = 400;

	SynthDef(\extCV, {|freq=100, amp=0.3|
		var sig = Saw.ar(freq);
		sig = RLPF.ar(sig, freq * 3, 0.3);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extCV);

	MIDIFunc.cc({|val|
		var now, delta, speed, ratio, chased, freq;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		lastTime = now;
		lastVal = val;

		ratio = (speed / maxSpeed).clip(0, 1);
		chased = val * ratio;
		freq = chased.linexp(0, 127, 100, 2000);
		synth.set(\freq, freq);
		("pos:" + val + "speed:" + speed.round(0.1) + "chased:" + chased.round(0.1)).postln;
	});

}.play
)



/////////////////// 7. ChaseRatio //////////////////////////////

// Output is relative: each movement multiplies or divides the
// current value by a ratio proportional to speed.
// Fast = coarse tuning, slow = fine tuning.
// The output accumulates — it depends on movement history.


( // ChaseRatio: relative, speed-dependent output

Routine {
	var synth, lastTime, lastVal, output, ratio;
	lastTime = Main.elapsedTime;
	lastVal = 0;
	output = 400.0;
	ratio = 1.02;

	SynthDef(\extCR, {|freq=400, amp=0.3|
		var sig = Saw.ar(freq);
		sig = RLPF.ar(sig, freq * 2, 0.4);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extCR);

	MIDIFunc.cc({|val|
		var now, delta, speed, direction, factor;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		direction = (val - lastVal).sign;
		lastTime = now;
		lastVal = val;

		factor = ratio ** (speed.linlin(0, 400, 0.1, 1.0).clip(0.1, 1.0));

		if(direction > 0, {
			output = output * factor;
		}, {
			output = output / factor;
		});

		output = output.clip(50, 5000);
		synth.set(\freq, output);
		("dir:" + direction + "speed:" + speed.round(0.1) + "freq:" + output.round(0.1)).postln;
	});

}.play
)



( // ChaseRatio with configurable sensitivity

Routine {
	var synth, lastTime, lastVal, output, ratio;
	lastTime = Main.elapsedTime;
	lastVal = 0;
	output = 400.0;
	ratio = 1.05;

	SynthDef(\extCR2, {|freq=400, amp=0.3, rq=0.4|
		var sig = Pulse.ar(freq, 0.3);
		sig = RLPF.ar(sig, freq * 4, rq);
		Out.ar(0, sig * amp ! 2);
	}).add;

	s.sync;
	synth = Synth(\extCR2);

	MIDIFunc.cc({|val|
		var now, delta, speed, direction, factor;
		now = Main.elapsedTime;
		delta = now - lastTime;
		speed = (val - lastVal).abs / delta.max(0.001);
		direction = (val - lastVal).sign;
		lastTime = now;
		lastVal = val;

		factor = ratio ** (speed.linexp(1, 500, 0.01, 1.0).clip(0.01, 1.0));

		if(direction > 0, {
			output = output * factor;
		}, {
			output = output / factor;
		});

		output = output.clip(30, 8000);
		synth.set(\freq, output);
		synth.set(\rq, speed.linlin(0, 400, 0.1, 1.5).clip(0.1, 1.5));
		("freq:" + output.round(0.1) + "rq:" + speed.linlin(0,400,0.1,1.5).clip(0.1,1.5).round(0.01)).postln;
	});

}.play
)

