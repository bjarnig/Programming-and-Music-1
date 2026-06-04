////////////////////////////////////////////////////////////////
//
//     GUI + MIDI sharing the same controls
//
////////////////////////////////////////////////////////////////


(

SynthDef(\voice, {|freq=220, cutoff=800, res=0.3, amp=0.2|
	var sig, filt;
	sig  = Saw.ar([freq, freq * 1.01]) * 0.3;
	filt = RLPF.ar(sig, cutoff.clip(40, 18000), res.clip(0.05, 1.0));
	Out.ar(0, filt * amp);
}).add;

)

(

s.waitForBoot({

	var win, freqSlider, cutoffSlider, resSlider, ampSlider;
	var freqSpec, cutoffSpec, resSpec, ampSpec;
	var sliders, specs, keys;
	var buildRow;

	// Free anything from a previous run
	Window.closeAll;
	MIDIdef.freeAll;
	MIDIIn.connectAll;

	// Single source of truth for the parameter ranges
	freqSpec   = ControlSpec(40,   2000, \exp, 0, 220);
	cutoffSpec = ControlSpec(60,   18000, \exp, 0, 800);
	resSpec    = ControlSpec(0.05, 1.0,  \lin, 0, 0.3);
	ampSpec    = ControlSpec(0,    0.6,  \lin, 0, 0.2);

	// One running synth — the only audio object
	~synth = Synth(\voice);

	// Build the window
	win = Window("GUI + MIDI", Rect(200, 200, 420, 260))
		.background_(Color.gray(0.15))
		.front
		.onClose_({
			MIDIdef.freeAll;
			~synth.free;
		});

	buildRow = {|label, spec, y, key|
		var slider, number, txt;

		txt = StaticText(win, Rect(20, y, 80, 24))
			.string_(label)
			.stringColor_(Color.white);

		slider = Slider(win, Rect(110, y, 220, 24))
			.value_(spec.unmap(spec.default))
			.action_({|v|
				var mapped = spec.map(v.value);
				~synth.set(key, mapped);
				number.string = mapped.round(0.01);
			});

		number = StaticText(win, Rect(340, y, 60, 24))
			.string_(spec.default.round(0.01))
			.stringColor_(Color.white);

		slider
	};

	freqSlider   = buildRow.("Freq",   freqSpec,   20,  \freq);
	cutoffSlider = buildRow.("Cutoff", cutoffSpec, 60,  \cutoff);
	resSlider    = buildRow.("Res",    resSpec,    100, \res);
	ampSlider    = buildRow.("Amp",    ampSpec,    140, \amp);

	sliders = [freqSlider, cutoffSlider, resSlider, ampSlider];
	specs   = [freqSpec,   cutoffSpec,   resSpec,   ampSpec];
	keys    = [\freq,      \cutoff,      \res,      \amp];

	MIDIdef.cc(\ctrl, {|val, num|
		var idx = num - 14; // CC 14 -> slider 0, etc.
		if(idx >= 0 and: { idx < sliders.size }, {
			{ sliders[idx].valueAction_(val / 127) }.defer;
		});
	});

	"Window built. Move the GUI sliders or send MIDI CC 14..17.".postln;
});
)
