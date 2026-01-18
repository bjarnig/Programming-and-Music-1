////////////////////////////////////////////////////////////////
//
//                   Patterns - 100 One-Liners
//
////////////////////////////////////////////////////////////////

// 1. Plot a pattern
Pwhite(0.0, 1.0, 100).asStream.all.plot;

// 2. Sequence of values
Pbind(\freq, Pseq([200,300,500], inf), \dur, 0.2).play

// 3. Random values
Pbind(\freq, Pwhite(200, 800), \dur, 0.2).play

// 4. Shape in time
Pbind(\freq, Env([100, 1000, 100],[1, 2], 'sine'), \dur, 0.05).play

// 5. Series up
a = Pbind(\midinote, Pseries(48, 1, 48), \dur, 0.1); a.play

// 6. Series down
b = Pbind(\midinote, Pseries(96, -1, 48), \dur, 0.1); b.play

// 7. Combine layers
Pseq([a,b]).play

// 8. Create layers from up and down
Ptpar([0.0, a, 0.0, b, 0.5, a, 0.5, b, 1.0, a, 1.0, b]).play

// 9. Distribution, Exprand
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \freq, [120, 180]).play;

// 10. Distribution, Phprand
Pbind(\amp, Phprand(0.01, 1), \dur, 0.1, \freq, [120, 180]).play;

// 11. Distribution, Poisson
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Ppoisson(60, inf)).play;

// 12. Distribution, Gauss
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Pgauss(60, 6, inf)).play;

// 13. Distribution, Cauchy
Pbind(\amp, Pexprand(0.01, 1), \dur, 0.1, \midinote, Pcauchy(60, 6, inf)).play;

// 14. Random walks
Pbind(\freq, Pbrown(400, 600, 10, inf), \dur, 0.1).play

// 15. Beta (favors the extremes)
Pbind(\freq, Pbeta(200, 600, 1, 1), \dur, 0.1).play

// 16. Returns the greater of two equal-distribution random numbers
Pbind(\freq, Phprand(200, 600), \dur, 0.1).play

// 17. Returns the lesser of two equal-distribution random numbers
Pbind(\freq, Plprand(200, 600), \dur, 0.1).play

// 18. Returns the average of two equal-distribution random numbers
Pbind(\freq, Pmeanrand(200, 600), \dur, 0.1).play

// 19. Sequencing more properties at a time
Pbind([\midinote, \dur],Pseq([ [62, 1/8], Pfuncn({[rrand(50,55),rrand(1/32,1/4)]},1)], inf)).play

// 20. Nested pattern with randomness
Pbind(\midinote, Pseries(60, Pwhite(-5, 5, inf).trace, inf), \dur, 0.1).play

// 21. Play for a duration, rounded floating point numbers
Pfindur(10, Pbind(\midinote, Pwhite(60.001, 61.008).round(0.1), \dur, 0.1)).play

// 22. Create and play from a collection and add an offset
a = [0,1,2,3,4,5,6] + 60; Pbind(\midinote, Prand(a + 7, inf), \dur, 0.1).play

// 23. Generate a collection using a pattern
b = Pseries(1, 1).asStream.nextN(64) + 60; Pbind(\midinote, Pseq(b), \dur, 0.05).play

// 24. Choose from different collections
c=[50,52,54]; d=[60,62]; Pbind(\midinote, Pseq([Prand(c,4), Prand(d,2)], inf), \dur, 0.1).play

// 25. Group repeats, control rate of change
Pbind(\dur,0.1, \midinote, Pn(Plazy({ Pshuf(Pwhite(40,60).asStream.nextN(3),4)}))).play;

// 26. Collection operations, select
Pbind(\freq , Pwhite(100,900).select({|x| x < 800}), \dur, 0.1).play

// 27. Pclutch, sample and hold a pattern
Pbind(\freq, Pclutch(Pwhite(95.123, 551.1234), Pseq([1, 0, 0, 0, 0], inf)), \dur, 0.1).play

// 28. Pn, simple repetition
Pbind(\freq, Pn(Pseq([500,600,700]), 10), \dur, 0.1).play

// 29. Pstutter, repeat values
Pbind(\freq, Pstutter(10, Pseq([500,600,700], inf)), \dur, 0.1).play

// 30. Pconst, limit the sum of items
Pbind(\freq, Pconst(5000, Pseq([500,600,700], inf)), \dur, 0.1).play

// 31. Psync, limit total dur, waits until clock sync
Psync(Pbind(\freq, Pseq([500,600,700], inf), \dur, 0.03), 1, 1).play

// 32. Ptime, the time amount since starting
Pbind(\degree, Pif(Ptime(inf) < 1.0, Pwhite(-4, 11, inf)), \dur, 0.1).play;

// 33. Pstep repeat input value for an amount of time
Pbind(\freq, Pstep(Pwhite(200,400), 4, inf), \dur, 0.05).play;

// 34. Pseg interpolates between values
Pbind( \freq, Pseg(Pwhite(100,500),Pseq([1,5],inf),\linear),\dur, 0.1).play;

// 35. Use env simply within patterns
Pbind(\freq,Env([100,1000], [5]),\dur,Env([0.05,0.01,0.1], [5,10])).play;

// 36. Wrap envelopes inside Pn to loop
Pbind(\freq, Pn(Pif(Ptime(inf) < 2, Env([100,200],[1])),inf), \dur,0.08).play

// 37. Pbindf to bind value patterns to one event stream
a = Pbind(\dur, 0.1); Pbindf(a, \freq, 200).play

// 38. Pchain, chains pbinds together
a = Pbind(\amp, Pexprand(0.01, 1)); b = Pbind(\dur, 0.1, \freq, [150, 200]); Pchain(a,b).play

// 39. Pfsm, state machine
Pbind(\midinote, Pfsm([[0], 67, [0, 1], 50, [2,3], 73, [0, 2], 83, [0]], inf), \dur, 0.1).trace.play

// 40. Markov chains
Pbind(\midinote, MarkovSetN([[[60], [62, 60], [0.7, 0.3]], [[62], [60],[1]]],1).makeSeeds,\dur, 1/8).play;

// 41. Pgeom, geometric series
Pbind(\midinote, Pgeom(40, 1.05, 32), \dur, 0.1).play

// 42. Pwhite with rounding
Pbind(\midinote, Pwhite(40, 80).round(12), \dur, 0.15).play

// 43. Pwrap, wrap values into range
Pbind(\midinote, Pwrap(Pseries(60, 3, inf), 60, 72), \dur, 0.1).play

// 44. Pfold, fold values into range
Pbind(\midinote, Pfold(Pseries(60, 5, inf), 60, 72), \dur, 0.1).play

// 45. Pdup, duplicate each value
Pbind(\midinote, Pdup(3, Pseq([60, 64, 67], inf)), \dur, 0.2).play

// 46. Prand, random choice from list
Pbind(\midinote, Prand([60, 63, 67, 70], inf), \dur, 0.15).play

// 47. Pxrand, no immediate repeats
Pbind(\midinote, Pxrand([60, 63, 67, 70], inf), \dur, 0.15).play

// 48. Pwrand with multiple weights
Pbind(\midinote, Pwrand([60, 64, 67], [0.6, 0.3, 0.1], inf), \dur, 0.2).play

// 49. Pshuf, shuffle list
Pbind(\midinote, Pshuf([60, 63, 65, 67, 70], inf), \dur, 0.2).play

// 50. Ptuple for parallel values
Pbind(\midinote, Ptuple([Pwhite(50,60), Pwhite(70,80)], inf), \dur, 0.3).play

// 51. Pslide, sliding window
Pbind(\midinote, Pslide([60, 62, 64, 65, 67], inf, 3, 1), \dur, 0.2).play

// 52. Place, interlace lists
Pbind(\midinote, Place([60, [63, 65], 67], inf), \dur, 0.2).play

// 53. Ppatlace, interlace patterns
Pbind(\midinote, Ppatlace([Pseq([60,64],2), Pseq([67,70],2)], inf), \dur, 0.15).play

// 54. Pwalk, random walk through list
Pbind(\midinote, Pwalk([60, 62, 64, 65, 67, 69, 71], Pseq([1,-1,2],inf), inf), \dur, 0.2).play

// 55. Tendency mask with changing boundaries
Pbind(\midinote, Pwhite(Pseg([40,80,40],[4,4]), Pseg([60,100,60],[4,4])), \dur, 0.1).play

// 56. Exponential curve envelope
Pbind(\midinote, Penv([40,80,40],[5,5], \exp), \dur, 0.08).play

// 57. Sine curve envelope
Pbind(\midinote, Penv([40,80,40],[3,3], \sine), \dur, 0.08).play

// 58. Welch curve envelope
Pbind(\midinote, Penv([40,80,40],[4,4], \welch), \dur, 0.08).play

// 59. Pkey to reference other parameters
Pbind(\midinote, Pwhite(40,80), \dur, Pkey(\midinote).linlin(40,80,0.05,0.3)).play

// 60. Pfunc for custom logic
Pbind(\midinote, Pfunc({rrand(40,80)}), \dur, 0.15).play

// 61. Pfuncn, limited evaluations
Pbind(\midinote, Pseq([60, Pfuncn({rrand(70,80)},4), 60], inf), \dur, 0.2).play

// 62. Prout, routine as pattern
Pbind(\midinote, Prout({10.do{|i| (60+i).yield}}), \dur, 0.2).play

// 63. Plazy, lazy evaluation
Pbind(\midinote, Pn(Plazy({Pseq([60,64,67].scramble, 1)}), inf), \dur, 0.2).play

// 64. PdegreeToKey with custom scale
Pbind(\degree, Pseq([0,1,2,3,4], inf), \scale, Scale.chromatic).play

// 65. Pindex, index into list
Pbind(\midinote, Pindex([60,63,65,67,70], Pseq([0,2,4,2,1],inf)), \dur, 0.2).play

// 66. Pswitch1, switch between patterns
Pbind(\midinote, Pswitch1([Pseq([60,64],2), Pseq([67,70],2)], Pseq([0,1],inf)), \dur, 0.2).play

// 67. Pgate, gate pattern with boolean
Pbind(\midinote, Pgate(Pwhite(60,80), Pseq([1,1,0,1],inf), inf), \dur, 0.15).play

// 68. Paccum, accumulate values
Pbind(\midinote, Paccum(60, Pwhite(-2,2,24)), \dur, 0.1).play

// 69. Pdiff, differences between values
Pbind(\midinote, 60 + Pdiff(Pseries(0,1,20)), \dur, 0.1).play

// 70. Plag, delayed by number of events
Pbind(\midinote, Pseq([60,Plag(Pseq([67,70],inf),1)],inf), \dur, 0.2).play

// 71. Prorate, proportional timing
Pbind(\midinote, Pseq([60,64,67], inf), \dur, Prorate(1, Pseq([1,2,1],inf))).play

// 72. Rest with duration
Pbind(\midinote, Pseq([60, 64, Rest(0.5), 67], inf), \dur, 0.2).play

// 73. Pn with limited repeats
Pbind(\midinote, Pn(Pseq([60,64,67],1), 3), \dur, 0.15).play

// 74. Pser, like Pseq but with item count
Pbind(\midinote, Pser([60,64,67,70], 10), \dur, 0.2).play

// 75. Pfinval, repeat for specified value duration
Pfinval(2, Pbind(\midinote, Pwhite(60,72), \dur, 0.1)).play

// 76. Collect operation on pattern
Pbind(\midinote, Pwhite(40,60).collect({|x| x.round(5)}), \dur, 0.15).play

// 77. Reject operation on pattern
Pbind(\midinote, Pwhite(40,80).reject({|x| x > 70}), \dur, 0.1).play

// 78. Mod operation on pattern
Pbind(\midinote, Pseries(40,1,inf) % 24 + 60, \dur, 0.1).play

// 79. Quantize pattern values
Pbind(\midinote, Pwhite(40.0, 80.0).round(5), \dur, 0.15).play

// 80. Reciprocal for durations
Pbind(\midinote, 60, \dur, Pwhite(4,10).reciprocal).play

// 81. Log for exponential scaling
Pbind(\midinote, Pexprand(40,80).log2.round * 12 + 40, \dur, 0.15).play

// 82. Multiple Pbinds with Ppar
Ppar([Pbind(\midinote, 60, \dur, 0.4), Pbind(\midinote, 67, \dur, 0.3)], inf).play

// 83. Staggered parallel with Ptpar
Ptpar([0, Pbind(\midinote, 60, \dur, 0.2), 0.5, Pbind(\midinote, 67, \dur, 0.2)]).play

// 84. Pseq with weighted repeats
Pbind(\midinote, Pseq([60,64,67], Pwhite(2,5,inf)), \dur, 0.15).play

// 85. Pdef for live coding
Pdef(\x, Pbind(\midinote, Pwhite(60,72), \dur, 0.1)).play

// 86. PatternProxy hot swap
p = PatternProxy(Pwhite(60,72)); Pbind(\midinote, p, \dur, 0.1).play; p.source = Pseq([60,67],inf)

// 87. Pswitch with index pattern
Pbind(\midinote, Pswitch([Pseq([60,64],2),Pseq([67,70],2)], Pseq([0,0,1,1],inf)), \dur, 0.15).play

// 88. Deviation for gauss
Pbind(\midinote, Pgauss(60, Pwhite(3,12), inf), \dur, 0.1).play

// 89. Nested Pwhite for wider range
Pbind(\midinote, Pwhite(40, Pwhite(70,90)), \dur, 0.15).play

// 90. Pstutter with random repeats
Pbind(\midinote, Pstutter(Pwhite(1,5), Pseq([60,64,67], inf)), \dur, 0.15).play

// 91. Alternating rhythm
Pbind(\midinote, 60, \dur, Pseq([0.1,0.1,0.2],inf)).play

// 92. Polyrhythm with unequal lengths
Pbind(\midinote, Pseq([60,64,67],inf), \dur, Pseq([0.2,0.3],inf)).play

// 93. Mapping range with linlin
Pbind(\midinote, Pwhite(0,1).linlin(0,1,40,80), \dur, 0.1).play

// 94. Exponential mapping with linexp
Pbind(\midinote, Pwhite(0,1).linexp(0,1,40,80), \dur, 0.1).play

// 95. Clip values to range
Pbind(\midinote, Pwhite(30,90).clip(50,70), \dur, 0.1).play

// 96. Blend between two patterns
Pbind(\midinote, Pwhite(60,65).blend(Pwhite(75,80), 0.5), \dur, 0.1).play

// 97. Bitwise operations
Pbind(\midinote, (Pseries(0,1,inf) & 7) * 3 + 60, \dur, 0.15).play

// 98. Conditional with Pif
Pbind(\midinote, Pif(Pwhite(0,1) > 0.5, 60, 72), \dur, 0.2).play

// 99. Switching scales mid-stream
Pbind(\degree, Pseq([0,2,4],inf), \scale, Pseq([Scale.major, Scale.minor],inf), \dur, 0.3).play

// 100. Complex nesting
Pbind(\midinote, Pseq([Pgeom(40,1.05,8), Pseries(70,-1,8)],inf), \dur, Pgeom(0.05,1.05,16)).play
