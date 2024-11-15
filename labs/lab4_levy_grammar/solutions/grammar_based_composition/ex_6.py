# %% Import libraries
import os
import numpy as np

os.chdir(os.path.dirname(os.path.abspath(__file__)))
from classes import Sonifier, Grammar_Sequence, metronome_grammar

# %%
grammar_cymbal={
    "S":["M", "SM"],
    "M": [["Q", "H", "Q"], ["TH","TH","TH"]],    
    "H": ["h", "ph", ["O","Q","O"], ["TQ","TQ","TQ"]],
    "Q": ["q", "pq", ["TO","TO","TO"] ],
    "TH": [ "th",  "pth"],
    "TQ": [ "tq",  "ptq"],
    "TO": [ "to",  "pto"],
    "O": ["o","po"]
}

word_duruation_cymbal = { "h":0.5, # half-measure
                   "q":0.25, # quarter-measure
                   "o":1/8,
                   "ph":0.5, 
                   "pq":0.25,
                   "po":1/8,
                   "th":1/3, 
                   "tq":0.5/3, 
                   "to":0.25/3,
                   "pth":1/3, 
                   "ptq":0.5/3, 
                   "pto":0.25/3,
}

grammar_kick={
    "S":["M", "SM"],
    "M": [["H","H"], ["Q", "h", "Q"], ["Q", "ph", "Q"], "w"],    
    "H": ["h", "ph", ["Q","Q"]],
    "Q": ["q", "pq"],
}

word_duruation_kick = { "h":0.5, # half-measure
                   "q":0.25, # quarter-measure
                   "w":1,
                   "ph":0.5, 
                   "pq":0.25, 
                   "pw":1,
}

if __name__=="__main__":
    fn_out="ex_6.wav"

    NUM_M=8
    START_SEQUENCE=["M",]*NUM_M

    #generate cymbal track
    G=Grammar_Sequence(grammar_cymbal)        
        
    final_sequence, seqs=G.create_sequence(START_SEQUENCE)
    for seq in seqs:
        print(" ".join(seq))
    print(f"Final sequence: {' '.join(final_sequence)}")    
    
    S= Sonifier("sounds/cymb.wav", BPM=174, word_dur=word_duruation_cymbal)
    audio_array_c=S.create_audio(final_sequence, add_metronome=False)
    
    #generate kick track
    G=Grammar_Sequence(grammar_kick)        
        
    final_sequence, seqs=G.create_sequence(START_SEQUENCE)
    for seq in seqs:
        print(" ".join(seq))
    print(f"Final sequence: {' '.join(final_sequence)}")    
    
    S= Sonifier("sounds/kick.mp3", BPM=174, word_dur=word_duruation_kick)
    audio_array_k=S.create_audio(final_sequence, add_metronome=False)
    
    # zero padding
    len_c = len(audio_array_c)
    len_k = len(audio_array_k)

    if(len_c>len_k):
        audio_array_k = np.pad(audio_array_k, (0,len_c))
    elif(len_c<len_k):
        audio_array_c = np.pad(audio_array_c, (0,len_k))

    result = 1*audio_array_c + 1*audio_array_k
    
    S.write("out/"+fn_out, audio_sequence=result)

# %%
