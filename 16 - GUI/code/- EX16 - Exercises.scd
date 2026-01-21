////////////////////////////////////////////////////////////////
//
//                   GUI - Exercises
//
////////////////////////////////////////////////////////////////

/*

Exercise 1: Basic Window
Create a window with a StaticText that displays "Hello GUI".
Make the text centered, size 24, and red color.

Exercise 2: Slider and NumberBox
Create a window with a slider and a number box.
When the slider moves, update the number box with its value.

Exercise 3: EZSlider
Create a window with an EZSlider for frequency.
Use the \freq ControlSpec and set labelWidth to 80.

Exercise 4: Routine with defer
Create a window with a StaticText.
Use a Routine to count from 0 to 10, updating the text every 0.5 seconds.
Remember to use defer{} to update the GUI.

Exercise 5: Slider to Synth
Create a window with a slider that controls the frequency of a playing synth.
Use a simple sine wave SynthDef.

Exercise 6: Multi-Parameter Synth Control
Create a window with three EZSliders controlling frequency, amplitude, and filter cutoff
of a filtered saw wave synth. Use appropriate ControlSpecs for each parameter.

Exercise 7: Start/Stop Synth Button
Create a window with a button that starts and stops a synth.
The button should have two states: "Start" (green) and "Stop" (red).
Make sure to free the synth when stopping.

Exercise 8: Waveform Selector
Create a window with a PopUpMenu to select between four waveforms:
"Sine", "Saw", "Pulse", "Noise". Play the selected waveform at 440 Hz
when a separate "Play" button is pressed.

Exercise 9: Pattern Duration Control
Create a window with a slider that controls the duration of a simple Pbind pattern.
Use a PatternProxy for the duration so it can be changed while the pattern is playing.

Exercise 10: Multiple Synth Mixer
Create a window with 4 vertical sliders (using HLayout) that control
the amplitude of 4 different sine wave synths playing at different frequencies
(e.g., 200, 300, 400, 500 Hz).

Exercise 11: Recording Interface
Create a window with:
- A button to start/stop recording (use s.record and s.stopRecording)
- A StaticText showing "Recording..." when active
Make sure to handle the recording state properly.

Exercise 12: OSC to GUI
Create a SynthDef that sends MouseX position via SendReply.
Display the received value in a GUI slider using OSCdef and defer.

*/
