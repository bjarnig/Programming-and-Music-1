////////////////////////////////////////////////////////////////
//
//                    SC Environment
//
////////////////////////////////////////////////////////////////

Be careful with volume. SafetyNet can prevent harmful signals.

( // Installs the SafetyNet Quark.

Quarks.fetchDirectory(true); Quarks.install("SafetyNet");
thisProcess.recompile;

)


//////////////////////////// Starting ////////////////////////////


// Boot the server before making any sound
s.boot;


// Check if server is running
s.serverRunning;



// Stop all sound with Cmd+. (Mac) or Alt+. (Windows)
// Or :
s.freeAll;



///////////////////////// Server Operations /////////////////////////


// Access the default server
s = Server.default;



// Boot, quit, and reboot
s.boot;
s.quit;
s.reboot;



// Wait for boot before executing code
(

s.waitForBoot({
	"Server is ready!".postln;
	// Initialize your sounds here
});

)



// Check server status
s.status;



// Free all nodes on the server
s.freeAll;



// Kill all servers
Server.killAll;



///////////////////////// Visualization  /////////////////////////


// Scope - see waveforms in real-time
{ SinOsc.ar(440, 0, 0.3) }.scope;



// FreqScope - see frequency spectrum
{ Saw.ar(200, 0.3) }.freqscope;



// Open server scope window
s.scope;



// Open frequency scope
s.freqscope;



// Open level meters
s.meter;



/////////////////////////// Plotting ////////////////////////////


// Plot a function's waveform (time in seconds)
{ SinOsc.ar(100) }.plot(0.05);



// Plot an array
[0, 1, 0.5, 0.2, 0.8].plot;



// Plot an envelope
Env.perc(0.01, 1.0).plot;
Env([0,1,0],[1,1],[-10,2]).plot;



// Compare waveforms
{ LFSaw.ar(100) }.plot(0.02);
{ Saw.ar(100) }.plot(0.02);


///////////////////////// Server Options /////////////////////////


// Configure BEFORE booting
Server.local.options.numOutputBusChannels = 8;
Server.local.options.numInputBusChannels = 2;

s.options.memSize = 8192 * 16;  // Memory in KB




///////////////////////// Volume Control /////////////////////////


// Set master volume
s.volume = 0.5;



// Mute and unmute
s.mute;
s.unmute;



//////////////////////// Posting and Debugging /////////////////////////


// Post values to the console
"Hello".postln;
440.postln;
[1, 2, 3, 4].postln;



// Formatted posting
"The frequency is % Hz\n".postf(440);



// Poll UGen values in real-time
(
{
	var freq = LFNoise0.kr(4).range(200, 800);
	freq.poll(4, \frequency);
	SinOsc.ar(freq, 0, 0.1);
}.play;
)




///////////////////////// Node Tree /////////////////////////


// View all running synths
s.queryAllNodes;



// After starting synths, check the node tree
{ SinOsc.ar(440, 0, 0.1) }.play;
{ SinOsc.ar(880, 0, 0.1) }.play;
s.queryAllNodes;




///////////////////////// Help System /////////////////////////


// Open the help browser
Help.gui;



// Get help for a class (select and press Cmd+D)
SinOsc



// Programmatically open help
SinOsc.help;
Env.help;


///////////////////////// Keyboard Shortcuts /////////////////////////


/*

Essential Shortcuts (Mac)
---------------------------------

Cmd+Return        Execute code (or Shift+Return)
Cmd+.             Stop all sound (emergency stop!)
Cmd+B             Boot server
Cmd+D             Open help for selected text
Cmd+I             Open source code for selected class

Cmd+Shift+L       Recompile class library
Cmd+T             Dump node tree


Text Selection
--------------

Double-click on (  Select everything within brackets
Triple-click       Select entire line
Cmd+A              Select all

*/

///////////////////////// Quick Reference /////////////////////////


/*

s.boot;               Boot server
s.quit;               Quit server
s.freeAll;            Free all nodes
s.queryAllNodes;      Show running synths
s.meter;              Show level meters
s.scope;              Show oscilloscope
s.freqscope;          Show spectrum analyzer

{ }.scope;            Scope a function
{ }.freqscope;        Frequency analyze a function
{ }.plot(dur);        Plot waveform

Server.killAll;       Kill all servers (emergency)

*/


///////////////////////// Common Problems /////////////////////////


/*

Problem: No sound
-----------------
1. Check server is running: s.serverRunning;
2. Boot server: s.boot;
3. Check volume: s.volume = 0.8; s.unmute;


Problem: Sound won't stop
-------------------------
1. Press Cmd+. multiple times
2. s.freeAll;
3. s.quit;
4. Server.killAll;


Problem: Server won't boot
--------------------------
1. Server.killAll;
2. Wait a moment
3. s.boot;

*/

