ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices;

Server.default.options.inDevice_("Built-in Microph");
Server.default.options.outDevice_("HDMI");
s.boot();

(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)


// Prand - Embed one item from the list at random for each repeat
(
a = Prand(#[60, 61, 63, 65, 72], inf).asStream;
Routine({
    loop({
        Synth(\help_sinegrain, [\freq, a.next.midicps]);
        0.2.wait;
    })
}).play;
)


// Pxrand - Like Prand, returns one item from the list at random for each repeat, but Pxrand never repeats the same element twice in a row.
(
a = Pxrand(#[60, 61, 63, 65, 72], inf).asStream;
Routine({
    loop({
        Synth(\help_sinegrain, [\freq, a.next.midicps]);
        0.2.wait;
    })
}).play;
)