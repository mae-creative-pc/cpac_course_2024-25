# %% Import libraries
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
from classes import Sonifier, Grammar_Sequence, metronome_grammar

# %%
grammar={
    "S":["M", "SM"],
    "M": [["H","H"], ["Q", "h", "Q"], ["Q", "ph", "Q"], "w"],    
    "H": ["h", "ph", ["Q","Q"]],
    "Q": ["q", "pq"],
}

word_duruation = { "h":0.5, # half-measure
                   "q":0.25, # quarter-measure
                   "w":1,
                   "ph":0.5, 
                   "pq":0.25, 
                   "pw":1,
}

if __name__=="__main__":
    fn_out="ex_4.wav"

    NUM_M=8
    START_SEQUENCE=["M",]*NUM_M
    G=Grammar_Sequence(grammar)        
        
    final_sequence, seqs=G.create_sequence(START_SEQUENCE)
    for seq in seqs:
        print(" ".join(seq))
    print(f"Final sequence: {' '.join(final_sequence)}")    
    
    S= Sonifier("sounds/kick.mp3", BPM=174, word_dur=word_duruation)
    audio_array=S.create_audio(final_sequence, add_metronome=True)
    S.write("out/"+fn_out, audio_sequence=audio_array)

# %%
