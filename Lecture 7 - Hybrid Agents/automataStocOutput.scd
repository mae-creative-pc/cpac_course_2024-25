ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices;

Server.default.options.inDevice_("Built-in Microph");
Server.default.options.outDevice_("HDMI");
s.boot();


(
SynthDef(\risset, { arg out= 0, pan= 0, note= 44, amp= 0.1, dur= 2, t_trig=1;
	var amps= [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
	var durs = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
	var frqs = [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
	var dets = [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];    // Detune
	var src,freq;

	freq = note.midicps;

	src = Mix.fill(11, {|i|
		var env= EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5),t_trig);
		SinOsc.ar(freq*frqs[i]+dets[i], 0, amp*env);
	});
	Out.ar(out, Pan2.ar(src, pan));
}).add;
)



(

// minor Scale
var scale = [60,62,64,65,67,69,71,72,74,76,77,79,81,83,84,86,88,89,91,93,95],
pattern = [1,3,-2,4],
noteIdx,
halt = 5,
state = 1,
count = 0,
composition = Array.new(50),
nextState,
currentOutput;

// ---- Next State Function ----
nextState = {arg st,cnt;
	var res = switch (st)
	    {1} {2}
	    {2} {3}
	    {3} {y = switch(cnt)
		     {1} {4}
		     {2} {4}
		     {3} {5};
	        }
	    {4} {1};
	res;
};


// ---- Current State Function ----
currentOutput = { arg st,no,cnt,pat;
	var res = switch (st)
	{1} {no = no+pat[rrand(0,3)]; cnt=cnt;}
	{2} {no = no+pat[rrand(0,3)]; cnt=cnt;}
	{3} {no = no+pat[rrand(0,3)]; cnt=cnt+1;}
	{4} {no = no+pat[rrand(0,3)]; cnt=cnt;};

	[no,cnt];
};


// ---- Main ----

// staring conditions
noteIdx = 7;
composition.add(scale[noteIdx]);

while ( { state != 5 },
	{
		("before -->"+"state"+state+"-count"+count+"noteIdx"+noteIdx).postln;
		o = currentOutput.value(state,noteIdx,count,pattern);
		count = o[1];
		noteIdx = o[0];
		state = nextState.value(state,count);
		("after -->"+"state"+state+"-count"+count+"noteIdx"+noteIdx).postln;
		composition.add(scale[noteIdx]);
});
composition.postln;


p = Pbind(
        // the name of the SynthDef to use for each note
    \instrument, \risset,
        // MIDI note numbers -- converted automatically to Hz
	\note, Pseq(composition, 1),
        // rhythmic values
	\dur, 0.5,
	\pan, 0,
).play;

)

