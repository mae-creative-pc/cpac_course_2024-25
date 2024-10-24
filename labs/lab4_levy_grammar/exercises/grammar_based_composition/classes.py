

import re
import random
import soundfile as sf
import librosa
import numpy as np

default_word_dur={"h":0.5, # half-measure
          "q":0.25, # quarter-measure
}
metronome_grammar={
    "M":["q","q","q","q"]
}
metronome_fn="sounds/metronome.wav"
def random_elem_in_list(list_of_elems):
    return list_of_elems[random.randint(0,len(list_of_elems)-1)]

# %% Grammar Sequence
class Grammar_Sequence:
    def __init__(self, grammar):
        self.grammar=grammar
        self.grammar_keys=list(grammar.keys())
        self.N=len(self.grammar_keys)
        self.sequence=[]
    def replace(self, index, convert_to):
        """Replace symbol in index with symbol(s) in convert_to

        Parameters
        ----------
        index : int
            index of the sequence to replace
        convert_to : str, list of str
            symbol(s) to convert to
        """
        convert_to = [convert_to,] if type(convert_to)==str else convert_to
        begin_seq=self.sequence[:index]
        end_seq=self.sequence[index+1:] if (index+1)<len(self.sequence) else []
        self.sequence=begin_seq+convert_to+end_seq
    def convert_sequence(self, idxs):        
        """Convert a non-terminal symbol in the sequence

        Parameters
        ----------
        idxs : list of integers
            integers where non-terminal symbols are 
        """

        index=random_elem_in_list(idxs)
        symbol=self.sequence[index]
        convert_to = random_elem_in_list(self.grammar[symbol])
        self.replace(index, convert_to)
        
    def find_nonterminal_symbols(self, sequence):
        """Checks if there are still nonterminal symbols in a sequence
        and where they are

        Parameters
        ----------
        sequence : list of str
            sequence

        Returns
        -------
        list
            list of indices where nonterminal symbols are
        boolean
            True if there are nonterminal symbols
        """
        idxs=[]
        for s, symbol in enumerate(sequence):
            if symbol in self.grammar_keys:
                idxs.append(s) 
        return idxs, len(idxs)>0
    def create_sequence(self, start_sequence):
        """Create a sequence of terminal symbols 
        starting from a sequence of non-terminal symbols.
        While this could be done with recursive function, we use iterative approach

        Parameters
        ----------
        start_sequence : list of str
            the sequence of non-terminal symbols

        Returns
        -------
        list of str
            the final sequence of terminal symbols
        list of list of str
            the history of sequence modification from non-terminal to terminal symbols
        """
        self.sequence=start_sequence
        sequence_transformation=[start_sequence]
        while True:
            idxs, to_convert=self.find_nonterminal_symbols(self.sequence)
            if not to_convert:
                break
            self.convert_sequence(idxs)
            sequence_transformation.append(self.sequence.copy())
        return self.sequence, sequence_transformation
# %% Sonifier
class Sonifier():
    """From grammar to soundfile
    """
    def __init__(self, fn="sounds/metronome.wav", word_dur=default_word_dur, sr=-1, BPM=120):
        """Init

        Parameters
        ----------
        fn : str, optional
            path of the sample to use, by default 'sounds/metronome.wav' 
        word_dur : dict, optional
            dictionary from word to duration in notes, by default default_word_dur
        sr : int, optional
            samplerate; if -1 the sample's samplerate will be used, by default -1
        BPM : int, optional
            Beat per minute of the sound, by default 120
        """
        if sr==-1:
            self.sample, self.sr =  librosa.load(fn)     
        else:
            self.sample, self.sr =  librosa.load(fn,sr=sr)         
        self.sampleN=self.sample.size
        self.BPM=BPM
        self.q_bpm=60/self.BPM
        self.m_bpm=4*self.q_bpm
        self.sequence=[]
        self.word_dur=word_dur
    def compute_duration(self, sequence):
        """Given a sequence, return the corresponding duration in notes
        and the total duration
        
        Parameters
        ----------
        sequence : list of str
            sequence as list of terminal symbols

        Returns
        -------
        list of float
            list of duration in notes for each terminal symbol
        float
            total durations
        """
        duration_in_notes=0
        dur_seq=[]
        for sym in sequence:
            dur_note=self.word_dur[sym]
            dur_seq.append(dur_note)
            duration_in_notes+=dur_note
        return dur_seq, duration_in_notes        
    def create_audio(self, sequence, add_metronome=False):
        """Create an audio from a  sequence of non-terminal symbols

        Parameters
        ----------
        sequence : list of str
            the list of non-terminal symbols
        add_mmetronome: boolean
            whether to add a metronome track to see the difference, by default is False
        Returns
        -------
        np.ndarray
            the audio sequence

        """
        duration_sequence, duration_in_notes=self.compute_duration(sequence)
        
        duration_in_seconds=duration_in_notes*self.m_bpm
        self.audio_sequence=np.zeros((int(duration_in_seconds*self.sr),))
        idx=0
        for note, symbol in zip(duration_sequence, sequence):
            if not symbol.startswith("p"):
                if self.audio_sequence.size > idx+self.sampleN: 
                    self.audio_sequence[idx:idx+self.sampleN]+=self.sample
                else:
                    K=self.audio_sequence.size-idx
                    self.audio_sequence[idx:]+=self.sample[:K]
                    self.audio_sequence[:self.sampleN-K]+=self.sample[K:]
            idx+=int(note*self.sr*self.m_bpm)
        if not add_metronome:            
            return self.audio_sequence
        sample_metronome, _=librosa.load("sounds/metronome.wav", sr=self.sr)
        dur_quarter=self.q_bpm
        N_quarter = int(self.q_bpm*self.sr)
        sample_metronome=np.pad(sample_metronome,(0, N_quarter-sample_metronome.size))
        num_quarters=int(1+np.ceil(duration_in_seconds/dur_quarter))
        audio_metronome=np.tile(sample_metronome, (num_quarters,))[:self.audio_sequence.size]
        return self.audio_sequence+audio_metronome

        
    def write(self, fn_out="out.wav", audio_sequence=None, repeat=1):
        """Write the audio sequence on a wav file

        Parameters
        ----------
        fn_out : str, optional
            filepath of the output file, by default "out.wav"
        audio_sequence : np.ndarray, optional
            the audio to write; if None, the last sequence is used, by default None
        repeat : int, optional
            number of times the sequence should be repeated, by default 1
        
        Returns
        -------
        np.ndarray
            the written sequence
        """
        if audio_sequence is None:
            audio_sequence = self.audio_sequence
        sequence_to_write=np.repeat(audio_sequence, (repeat,))
        sf.write(fn_out, sequence_to_write/np.max(np.abs(sequence_to_write)), self.sr)
        return sequence_to_write