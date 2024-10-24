
(
SynthDef("moog", {
	arg vibr=0, cutoff=0.5, freq=60, amp=0;
	var osc1, osc2, osc3, f0, vib_int, cutoff_freq, fil_osc;

	//freq=midicps(midinote);
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
~instr.set(\freq, 300, \amp, 1, \vibr, 0);
)

//setting the cutoff
(
~instr.set(\cutoff, 3);
)

(
~instr.set(\amp, 0)
)

// Use this command to start the server
NetAddr("127.0.0.1",57120);



(
OSCdef('OSCreceiver',
	{
		arg msg;
		var freq, amp, cutoff, vibr;

		msg.postln;
		freq=msg[1];
		amp=msg[2];
		cutoff=msg[3];
		vibr=msg[4];

		~instr.set(\freq,freq, \amp,amp, \cutoff, cutoff, \vibr, vibr);

	},
	"/note_effect",);
)

