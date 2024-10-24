
(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)


(
var a;
a = Pwhite(0.0, 1.0, inf).asStream;
{
    loop {
        Synth(\help_sinegrain, [\freq, a.next * 600 + 300, \sustain, a.next]);
        0.02.wait;
    }
}.fork;
)




(
var a;
a = Pbrown(0.0, 1.0, 0.1, inf).asStream;
{
    loop {
        Synth(\help_sinegrain, [\freq, a.next * 600 + 300, \sustain, a.next]);
        0.02.wait;
    }
}.fork;
)



(
var a;
a = Pwhite(0.0, 1.0, inf).asStream;
b = Pbrown(0.0, 0.05, 0.1, inf).asStream;
{
    loop {
        Synth(\help_sinegrain, [\freq, a.next * 600 + 300, \sustain, b.next]);
        0.02.wait;
    }
}.fork;
)

