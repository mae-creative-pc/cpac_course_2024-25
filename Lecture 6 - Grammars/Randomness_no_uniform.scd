

// Pwrand - Returns one item from the list at random for each repeat, the probability for each item is determined by a list of weights which should sum to 1.0.

(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)


(
a = Pwrand([60, 61, 63, 65, 72], [8, 5, 10, 1, 10].normalizeSum, inf).asStream;
Routine({
    loop({
        Synth(\help_sinegrain, [\freq, a.next.midicps]);
        0.1.wait;
    })
}).play;
)
