////////////////////////////////////////////////////////////////
//
//                        Randomness
//
////////////////////////////////////////////////////////////////


( // LFNoise0 generates step noise
{
	Impulse.ar(LFNoise0.ar([4,8], 200, 220), 0, 0.2)
}.play;
)



( // LFNoise1 generates ramp noise
{
	Impulse.ar(LFNoise1.ar([4,8], 200, 220), 0, 0.2)
}.play;
)



( // One random number with exponential distribution
{
	Impulse.ar(ExpRand(10,100), 0, 0.2)
}.play;
)



( // One random number with uniform distribution
{
	thisThread.randSeed = 7;
	Impulse.ar(NRand(100,200,1), 0, 0.2)
}.play;
)


( // TRand for triggering random number
{
	var trig = Dust.kr(10);
    Saw.ar(TRand.kr(20, 150, trig), 0.2)

}.play
)


( // Use seed for repeated randomness
{
RandSeed.kr(Impulse.kr(4), 1980);
PinkNoise.ar;
}.play
)


// Useful help file:
Tour of ugens

PinkNoise
WhiteNoise
GrayNoise
BrownNoise
ClipNoise
LFNoise0
LFNoise1
LFNoise2
LFClipNoise
LFDNoise0
LFDNoise1
LFDNoise3
LFDClipNoise
Dust
Dust2
Crackle
TWChoose
