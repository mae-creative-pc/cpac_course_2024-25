

(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.1;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)


//Pwalk - A one-dimensional random walk over a list of values that are embedded

(
a = Pwalk(
    [60, 64, 67, 72, 76, 79, 84].midicps,    // C major
    //Pseq([1], inf),
	Pwrand([-1, 0, 1], [0.1, 0.8, 0.1].normalizeSum, inf),
    Pseq([1, -1], inf),    // turn around at either end
    0);
x = a.asStream;

SynthDef(\help_walk, { |out, freq|
    Out.ar(out, Saw.ar([freq, freq+1], 0.5) * EnvGen.kr(Env.perc(0.01, 0.1), doneAction: Done.freeSelf))
}).add;
)

(
r = Task({
    {
        Synth.new(\help_walk, [\freq, x.next]);
        0.1.wait;
    }.loop;
}).play(SystemClock);
)

r.stop;