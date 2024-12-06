
// Start the server

ServerOptions.outDevices;
Server.default.options.outDevice_("Dispositivo con uscite multiple");
s.boot
// Synth definition
(
SynthDef(\SimpleNote,
{
	arg freq=200, mix=0.33,room=0.5;
    var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]),octaveShift,scale, sound,reverb_sound;

	sound = SinOsc.ar(freq)+ (Pulse.ar(freq)*0.05);

	reverb_sound = FreeVerb.ar(sound,mix,room,0.5);
		Out.ar([0,1],reverb_sound*EnvGen.kr(env, doneAction: Done.freeSelf))


}).add;
)

// synth running example just to hear it
(
a=7.rand;
b = Scale.hijaz;
c = 60;
d = Scale.hijaz;
e = (b[a]+ c).midicps ;

Synth(\SimpleNote,[freq:e,mix:1.rand,room:1.rand])

)

//set the server
NetAddr("127.0.0.1",57120);

(
x = OSCFunc( { | msg, time, addr, port |
    var pyIdx, pyRoom,pyMix, scale, offset, freq;
	// Parse message
	pyIdx= msg[1].asFloat; // Idx of note on the scale
	pyMix= msg[2].asFloat; // Reverb mix
	pyRoom= msg[2].asFloat; // Room size (reverb)

	offset = 60; // midi note offset
	scale = Scale.hijaz; // selected scale
	freq = (scale[pyIdx]+ offset).midicps; // frequency corresponding to note

	// Play the synth!!!
	Synth(\SimpleNote,[freq:freq,mix:pyMix,room:pyRoom]);

	// Print some info
	("Message received from Processing").postln
	( "Note idx is " + pyIdx ).postln;
	( "Reverb Mix is " + pyMix).postln;
	( "Room Size is " + pyRoom).postln;
}, '/synth_control' );
)


// quit the server
s.quit()