ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices;

Server.default.options.inDevice_("Built-in Microph");
Server.default.options.outDevice_("HDMI");
s.boot();

(
SynthDef(\dubstep, { arg freq = 56,gate = 1,dur=2,cutoff = 2000, amp = 0.5, pan = 0;
	var trig, son, sweep, out;

	//freq = note.midicps;

	trig = CoinGate.kr(0.5, Impulse.kr(2));
	//trig = Impulse.kr(2);

	sweep = LFSaw.ar(Demand.kr(trig, 0, Drand([1, 2, 2, 3, 4, 5, 6, 8, 16], inf))).exprange(40, 5000);   /// Inf: number of different values to produce

	son = Mix.ar(LFSaw.ar(freq * [0.99, 1, 1.01]));
    son = LPF.ar(son, sweep);
	out = son + BPF.ar(son, cutoff, 2);

	Out.ar(0, Pan2.ar(FreeVerb.ar(out*amp,mix:0.33,room:0.3),pan));
}).add;
)


x = Synth(\dubstep,[\freq,22]);
x.set(\freq,880);
x.set(\freq,60);
x.set(\cutoff,440);
x.set(\gate,0);

y = Synth(\dubstep,[\freq,22]);
y.set(\freq,200);
y.set(\freq,40);
x.set(\cutoff,300);
