// Run command to check SC OSC listening port
NetAddr.langPort

//Load Server
s.boot

// Following two lines to change supercollider
ServerOptions.outDevices;
s.options.outDevice_('Scarlett 2i2 USB');



// Synth Example
(
SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: Done.freeSelf) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    // see below for more on .add
)



// OSC

(
x = OSCFunc( { | msg, time, addr, port |
    var chord,note1,note2,note3,note4,pyFreq,pyAmp,pyDetune,pyLfo;

	// Handle end of sound
	if (msg[1] =='stop'){
		h.free
	}
	{
	// handle class A message (freq and amplitude)
		if (msg[1]=='chord3'){
			// Parse message
			note1 = msg[2].asFloat;
			note2  = msg[3].asFloat;
			note3  = msg[4].asFloat;
			chord=[note1,note2, note3];
			chord.postln();
		};
		if (msg[1]=='chord4'){
			// Parse message
			note1 = msg[2].asFloat;
			note2  = msg[3].asFloat;
			note3  = msg[4].asFloat;
			note4  = msg[5].asFloat;
			chord=[note1,note2, note3,note4];
			chord.postln();
		};


		(
			p=Pbind(
				\instrument, \harpsi,
				\note, Pseq([chord],1),
				\dur, 1,
				\legato, 0.4,
				//\strum, 0.1 // try 0, 0.1, 0.2, etc
			).play;
		)


	};

}, '/synth_control' );
)


// Close OSC function
x.free;

// Close server
s.quit;

