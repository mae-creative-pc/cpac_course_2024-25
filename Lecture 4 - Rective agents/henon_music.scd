(
SynthDef(\dubstep, { arg note = 22,dur=2, pan=0;
	var trig, son, out, freq;

	freq = note.midicps;

	trig = CoinGate.kr(0.5, Impulse.kr(2));

	son = Mix.ar(LFSaw.ar(freq * [0.99, 1, 1.01]));
    son = LPF.ar(son, 1500);
    out = son + BPF.ar(son, 2000, 2);

	a = EnvGen.ar(Env.perc(0.01,1),doneAction:2);

	Out.ar(0, Pan2.ar(out*a,pan));
}).add;
)



(
// minor Scale
var scale = [60,62,64,65,67,69,71,72,74,76,77,79,81,83,84,86,88,89,91,93,95],
len = 20,
a = 1.4,
b = 0.3,
x = Array.new(len),
y = Array.new(len);

// staring conditions
x.add(0);
y.add(0);

(len-1).do
{
	arg n;

	x.add(1+y[n]-(a*pow(x[n],2)));
	y.add(b*x[n]);

};

x = x-x.minItem;
x = round((x/x.maxItem)*(scale.size-1));
y = y-y.minItem;
y = round((y/y.maxItem)*(scale.size-1));


x.do{arg item,i;
	x[i] = scale[x[i]];
	y[i] = scale[y[i]];
};


p = Pbind(
        // the name of the SynthDef to use for each note
    \instrument, \dubstep,
        // MIDI note numbers -- converted automatically to Hz
	\note, Pseq(x, 1),
        // rhythmic values
	\dur, 0.5,
	\pan, -0.5,
).play;

p = Pbind(
        // the name of the SynthDef to use for each note
	\instrument, \dubstep,
        // MIDI note numbers -- converted automatically to Hz
	\note, Pseq(y,1),
        // rhythmic values
	\dur, 0.5,
	\pan, 0.5,
).play;
)

