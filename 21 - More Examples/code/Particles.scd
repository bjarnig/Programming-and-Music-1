////////////////////////////////////////////////////////////////
//
//               Animated particle system
//
////////////////////////////////////////////////////////////////

(

SynthDef(\particle, {|freq=220, cutoff=1200, amp=0.05, pan=0, gate=1|
	var sig, body, env;
	body = Mix([
		SinOsc.ar(freq) * 0.6,
		LPF.ar(PinkNoise.ar(0.5), cutoff) * 0.3
	]);
	sig  = RLPF.ar(body, cutoff.clip(60, 18000), 0.6);
	env  = EnvGen.ar(Env.asr(0.05, 1, 0.4), gate, doneAction: 2);
	Out.ar(0, Pan2.ar(sig * env * amp.clip(0, 0.3), pan));
}).add;

)


(

s.waitForBoot({

	var win, view, ctrlWin;
	var particles, synths;
	var ctrlSize = 400;
	var nParticles = 16;
	var speedMul   = 1.0;
	var baseFreq   = 220;
	var masterAmp  = 0.6;

	Window.closeAll;

	// Build particle records + a synth per particle.
	particles = Array.fill(nParticles, {
		(
			x:  rrand(50.0, ctrlSize - 50),
			y:  rrand(50.0, ctrlSize - 50),
			vx: rrand(-2.0, 2.0),
			vy: rrand(-2.0, 2.0),
			hue: 1.0.rand
		)
	});

	synths = Array.fill(nParticles, { Synth(\particle, [\amp, 0]) });

	// Visualisation window
	win = Window("Particles -> Synths", Rect(200, 200, ctrlSize, ctrlSize))
		.background_(Color.black)
		.front
		.onClose_({
			synths.do(_.set(\gate, 0));
			ctrlWin !? { ctrlWin.close };
		});

	view = UserView(win, win.view.bounds)
		.background_(Color.black)
		.animate_(true)
		.frameRate_(60)
		.drawFunc_({
			particles.do {|p, i|
				var freq, cutoff, pan, amp, speed;

				// Update position
				p[\x] = p[\x] + (p[\vx] * speedMul);
				p[\y] = p[\y] + (p[\vy] * speedMul);

				// Bounce off walls
				if(p[\x] < 0 or: { p[\x] > ctrlSize }, { p[\vx] = p[\vx].neg });
				if(p[\y] < 0 or: { p[\y] > ctrlSize }, { p[\vy] = p[\vy].neg });

				// Map particle state -> synth params
				speed  = (p[\vx].squared + p[\vy].squared).sqrt;
				freq   = baseFreq * (p[\x] / ctrlSize * 4 + 0.5);
				cutoff = (p[\y] / ctrlSize).linexp(0, 1, 200, 6000);
				pan    = (p[\x] / ctrlSize) * 2 - 1;
				amp    = speed.linlin(0, 5, 0.005, 0.05) * masterAmp;

				// Push to the corresponding synth.
				synths[i].set(\freq, freq, \cutoff, cutoff, \pan, pan, \amp, amp);

				// Draw — size + brightness scale with speed
				Pen.fillColor = Color.hsv(p[\hue], 0.7, speed.linlin(0, 4, 0.4, 1.0), 0.7);
				Pen.fillOval(Rect(p[\x] - 4, p[\y] - 4, 8, 8));
			};
		});

	// Control window
	ctrlWin = Window("Controls", Rect(620, 200, 280, 200))
		.front
		.onClose_({ win.close });

	ctrlWin.layout = VLayout(
		HLayout(
			StaticText().string_("Speed"),
			Slider().orientation_(\horizontal).value_(0.25)
				.action_({|v| speedMul = v.value.linexp(0, 1, 0.1, 8) })
		),
		HLayout(
			StaticText().string_("Base Freq"),
			Slider().orientation_(\horizontal).value_(0.3)
				.action_({|v| baseFreq = v.value.linexp(0, 1, 60, 1200) })
		),
		HLayout(
			StaticText().string_("Master Amp"),
			Slider().orientation_(\horizontal).value_(0.6)
				.action_({|v| masterAmp = v.value })
		),
		Button().states_([["Kick all velocities"]])
			.action_({
				particles.do {|p|
					p[\vx] = rrand(-3.0, 3.0);
					p[\vy] = rrand(-3.0, 3.0);
				};
			})
	);
});

)
