////////////////////////////////////////////////////////////////
//
//                       Set C - Solutions
//
////////////////////////////////////////////////////////////////

/* 1. Write a function that takes an array of MIDI note numbers
   and returns a dictionary containing: the lowest pitch, highest
   pitch, average pitch, and the count of notes in each octave
   (octaves are 0-11, 12-23, 24-35, etc.). */

(
~analyzePitches = {|midiNotes|
    var result = Dictionary.new;
    var octaveCounts = Dictionary.new;

    midiNotes.do({|note|
        var octave = (note / 12).floor;
        var octaveKey = octave.asString;

        if(octaveCounts.at(octaveKey).isNil, {
            octaveCounts.put(octaveKey, 1);
        }, {
            octaveCounts.put(octaveKey, octaveCounts.at(octaveKey) + 1);
        });
    });

    result.put(\lowest, midiNotes.minItem);
    result.put(\highest, midiNotes.maxItem);
    result.put(\average, midiNotes.sum / midiNotes.size);
    result.put(\octaveCounts, octaveCounts);

    result;
};

~analyzePitches.value([60, 62, 64, 67, 69, 72, 48, 84]);
)

/* 2. Write a function that takes an array of MIDI note numbers and
   a number of semitones, then returns a new array with all notes
   transposed (shifted) by that number of semitones. Positive numbers
   transpose up, negative numbers transpose down. */

(
~transpose = {|midiNotes, semitones|
    var result = [];

    midiNotes.do({|note|
        result = result.add(note + semitones);
    });

    result;
};

~transpose.value([60, 62, 64, 67], 12).postln;   // Transpose up one octave
~transpose.value([60, 62, 64, 67], -5).postln;   // Transpose down 5 semitones
~transpose.value([48, 50, 52], 7).postln;        // Transpose up 7 semitones
)

/* 3. Write a function that takes an array of durations in seconds
   and a scaling factor, then returns a new array where each duration
   is multiplied by the scaling factor. Also return the total duration
   of the original array and the scaled array. */

(
~scaleDurations = {|durations, factor|
    var result = Dictionary.new;
    var scaled = [];

    durations.do({|duration|
        scaled = scaled.add(duration * factor);
    });

    result.put(\scaled, scaled);
    result.put(\originalTotal, durations.sum);
    result.put(\scaledTotal, scaled.sum);

    result;
};

~scaleDurations.value([0.5, 1.0, 2.0, 0.25], 2).postln;
~scaleDurations.value([1.0, 0.5, 1.5], 0.5).postln;
)

/* 4. Write a function that takes an array of amplitude values
   (0.0 to 1.0) and returns a dictionary with: the minimum amplitude,
   maximum amplitude, average amplitude, and a count of how many
   values are in each range (quiet: 0-0.3, medium: 0.3-0.7, loud: 0.7-1.0). */

(
~analyzeAmplitudes = {|amplitudes|
    var result = Dictionary.new;
    var quiet = 0;
    var medium = 0;
    var loud = 0;

    amplitudes.do({|amp|
        if(amp < 0.3, {
            quiet = quiet + 1;
        }, {
            if(amp <= 0.7, {
                medium = medium + 1;
            }, {
                loud = loud + 1;
            });
        });
    });

    result.put(\min, amplitudes.minItem);
    result.put(\max, amplitudes.maxItem);
    result.put(\average, amplitudes.sum / amplitudes.size);
    result.put(\quiet, quiet);
    result.put(\medium, medium);
    result.put(\loud, loud);

    result;
};

~analyzeAmplitudes.value([0.1, 0.2, 0.5, 0.6, 0.8, 0.9, 0.15, 0.75]);
)

/* 5. Write a function that takes a starting MIDI note and a number
   of semitones, and returns an array of MIDI notes forming a
   chromatic scale (all semitones) from the starting note. */

(
~chromaticScale = {|startNote, numSemitones|
    var scale = [];

    numSemitones.do({|i|
        scale = scale.add(startNote + i);
    });

    scale;
};

~chromaticScale.value(60, 12);  // C major octave
~chromaticScale.value(48, 7);   // 7 semitones from C3
)

/* 6. Write a function that takes an array of frequencies and
   returns a new array containing only the frequencies that are
   within a specific range (e.g., between 200 Hz and 2000 Hz).
   Also return the count of filtered frequencies. */

(
~filterFrequencies = {|frequencies, minFreq=200, maxFreq=2000|
    var result = Dictionary.new;
    var filtered = [];

    frequencies.do({|freq|
        if((freq >= minFreq) && (freq <= maxFreq), {
            filtered = filtered.add(freq);
        });
    });

    result.put(\filtered, filtered);
    result.put(\count, filtered.size);
    result.put(\originalCount, frequencies.size);

    result;
};

~filterFrequencies.value([100, 440, 880, 1500, 2500, 300, 2000], 200, 2000);
)

/* 7. Write a function that takes a root note (MIDI number) and
   returns a dictionary containing arrays of MIDI notes for major
   and minor scales starting from that root. Major scale intervals:
   [0, 2, 4, 5, 7, 9, 11]. Minor scale intervals: [0, 2, 3, 5, 7, 8, 10]. */

(
~generateScales = {|rootNote|
    var result = Dictionary.new;
    var majorIntervals = [0, 2, 4, 5, 7, 9, 11];
    var minorIntervals = [0, 2, 3, 5, 7, 8, 10];
    var majorScale = [];
    var minorScale = [];

    majorIntervals.do({|interval|
        majorScale = majorScale.add(rootNote + interval);
    });

    minorIntervals.do({|interval|
        minorScale = minorScale.add(rootNote + interval);
    });

    result.put(\major, majorScale);
    result.put(\minor, minorScale);

    result;
};

~generateScales.value(60);  // C major and C minor
~generateScales.value(48);  // C3 major and C3 minor
)

/* 8. Write a function that generates a sequence of durations and
   amplitudes. The function should take a count (how many items to
   generate), a base duration, a base amplitude, and a variation range.
   It should return a dictionary with two arrays: one for durations
   and one for amplitudes, where each value varies randomly around
   the base values within the specified range. */

(
~generateSequence = {|count, baseDuration, baseAmplitude, variation=0.3|
    var result = Dictionary.new;
    var durations = [];
    var amplitudes = [];
    var durRange = baseDuration * variation;
    var ampRange = baseAmplitude * variation;
    
    count.do({
        var durVariation = rrand(-durRange, durRange);
        var ampVariation = rrand(-ampRange, ampRange);
        
        durations = durations.add((baseDuration + durVariation).max(0.01));
        amplitudes = amplitudes.add((baseAmplitude + ampVariation).clip(0.0, 1.0));
    });
    
    result.put(\durations, durations);
    result.put(\amplitudes, amplitudes);
    
    result;
};

~generateSequence.value(8, 0.5, 0.5, 0.4);
~generateSequence.value(5, 1.0, 0.3, 0.2);
)

/* 9. Write a function that generates a chord (an array of MIDI notes)
   from a root note. The function should take a root MIDI note and
   a chord type (major or minor). Major chord intervals: [0, 4, 7].
   Minor chord intervals: [0, 3, 7]. Return an array of MIDI notes
   representing the chord. */

(
~generateChord = {|rootNote, type=\major|
    var intervals;
    var chord = [];
    
    if(type == \major, {
        intervals = [0, 4, 7];
    }, {
        intervals = [0, 3, 7];
    });
    
    intervals.do({|interval|
        chord = chord.add(rootNote + interval);
    });
    
    chord;
};

~generateChord.value(60, \major);   // C major: [60, 64, 67]
~generateChord.value(60, \minor);   // C minor: [60, 63, 67]
~generateChord.value(48, \major);   // C3 major: [48, 52, 55]
)

/* 10. Write a function that takes an array of MIDI notes and
     returns a formatted report showing: all unique notes (without
     octave), the frequency range in Hz, the pitch range in semitones,
     and a dictionary mapping each note name to how many times it
     appears (regardless of octave). */

(
~pitchReport = {|midiNotes|
    var result = Dictionary.new;
    var noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
    var uniqueNotes = Set.new;
    var noteCounts = Dictionary.new;
    var frequencies = [];

    midiNotes.do({|note|
        var noteIndex = note % 12;
        var noteName = noteNames[noteIndex];
        var frequency = note.midicps;

        uniqueNotes.add(noteName);
        frequencies = frequencies.add(frequency);

        if(noteCounts.at(noteName).isNil, {
            noteCounts.put(noteName, 1);
        }, {
            noteCounts.put(noteName, noteCounts.at(noteName) + 1);
        });
    });

    result.put(\uniqueNotes, uniqueNotes.asArray.sort);
    result.put(\frequencyRange, [frequencies.minItem.round(0.01), frequencies.maxItem.round(0.01)]);
    result.put(\pitchRange, [midiNotes.minItem, midiNotes.maxItem]);
    result.put(\pitchRangeSemitones, midiNotes.maxItem - midiNotes.minItem);
    result.put(\noteCounts, noteCounts);

    result;
};

~pitchReport.value([60, 62, 64, 67, 69, 72, 60, 64, 67, 72, 48, 84]);
)

