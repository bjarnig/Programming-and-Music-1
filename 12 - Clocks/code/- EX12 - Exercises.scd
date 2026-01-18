////////////////////////////////////////////////////////////////
//
//              Routines & Clocks - Exercises
//
////////////////////////////////////////////////////////////////

/*

Exercise 1: Basic Routine Sequence
Create a Routine that plays 5 notes in sequence with 0.3 second waits between them.

Exercise 2: Loop with Counter
Create a Routine that plays 8 notes using a loop. Each note should be 2 semitones
higher than the previous one. Use 0.2 second waits.

Exercise 3: Conditional Rhythm
Create a Routine that loops 16 times. On every 4th iteration, play a low note (40)
and wait 0.4 seconds. On other iterations, play a high note (80) and wait 0.1 seconds.

Exercise 4: External Control
Create a Routine that loops infinitely, using global variables ~pitch and ~tempo
to control the note and timing. Start it, then change the variables while it runs.

Exercise 5: SystemClock vs TempoClock
Create the same Routine twice: once using SystemClock and once using TempoClock
at 120 BPM. The routine should wait 0.5 (seconds or beats) between notes.
Compare the speeds.

Exercise 6: Task Control
Create a Task that counts from 1 to 20 with 0.2 second waits. Start it, pause it
after a few counts, then resume it. Observe that it continues from where it paused.

Exercise 7: Multiple Routines
Create 3 different Routines that each play notes at different intervals:
- Routine A: plays a note every 0.5 seconds
- Routine B: plays a note every 0.75 seconds
- Routine C: plays a note every 1.0 seconds
Start them all at the same time and listen to the polyrhythm.

Exercise 8: Probabilistic Stopping
Create a Routine that uses a while loop with .coin to continue. Each iteration should
have a 70% chance to continue (0.7.coin). Post the iteration number each time.
Run it several times to see different lengths.

Exercise 9: Scheduled Start Times
Create two Routines and schedule them to start at different times using clock.sched().
The first should start after 2 beats, the second after 5 beats. Use a TempoClock.

Exercise 10: Tempo Changes
Create a TempoClock and a Routine that plays notes on that clock. While it's running,
change the tempo of the clock to make the routine speed up or slow down.

*/
