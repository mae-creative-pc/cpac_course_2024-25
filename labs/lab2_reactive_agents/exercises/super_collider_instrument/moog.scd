// definition of the instrument
(
SynthDef("moog", {
	arg vibr=0, cutoff=0.5, midinote=60, amp=0;
	var osc1, osc2, osc3, f0, vib_int, cutoff_freq, fil_osc, freq;

	freq=midicps(midinote);
	f0=exp(vibr*0.035)*freq;

	osc1=Saw.ar(f0*1.0013);
	osc2=Saw.ar(f0*0.998);
	osc3=Saw.ar(f0*0.5);

	cutoff_freq=((cutoff+0.5)*6)*freq;

	fil_osc=BLowPass.ar(in:osc1+osc2+osc3, freq:cutoff_freq.min(20000));
	Out.ar([0,1], amp*fil_osc);}).add;
)

// SETTING the instrument as a global variable
(
~instr=Synth(\moog);
)

// setting the note
(
~instr.set(\midinote, 62, \amp, 1);
)

//setting the cutoff
(
~instr.set(\cutoff, 9);
)

(
~instr.set(\amp, 0);
)

// Use this command to start the server
NetAddr("127.0.0.1",57120);



( // RECEIVER 1: PYTHON ONLY
OSCdef('OSCreceiver',
	{
		arg msg;
		var note, amp, cutoff, vibr;

		msg.postln;
		note=msg[2];
		amp=msg[3];

		~instr.set(\midinote,note, \amp,amp);

	},
	"/note_effect",);
)
(// RECEIVER 2: PYTHON + PROCESSING
OSCdef('OSCreceiver',
	{
		arg msg;
		var note, amp, cutoff, vibr;

		msg.postln;
		if(msg[1].asString()=="note"){
			"note".postln;
			note=msg[2];
			amp=msg[3];

			~instr.set(\midinote,note, \amp,amp);
			}{};
		if(msg[1].asString()=="effect"){
			"effect".postln;
			cutoff=msg[2];
			vibr=msg[3];
			~instr.set(\vibr,vibr, \cutoff,cutoff);
			}{};

	},
	"/note_effect",);
)
( // RECEIVER 3: PROCESSING ONLY
OSCdef('OSCreceiver',
	{
		arg msg;
		var vibr, cutoff;

		msg.postln;
		cutoff=msg[2];
		vibr=msg[3];
		~instr.set(\cutoff,cutoff, \vibr, vibr);
	},
	"/note_effect");
)









