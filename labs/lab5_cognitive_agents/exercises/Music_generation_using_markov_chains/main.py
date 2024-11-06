# %% Import libraries and data
import numpy as np
import pandas as pd
from collections import Counter
import time
import argparse
from pythonosc import udp_client
import os

dirname = os.path.dirname(__file__)
#np.random.seed(42)

chords_midi_dict={
    'F':[5,9,12],
    'Em7':[4,9,11,14],
    'A7':[9,13,16,21], 
    'Dm':[2,5,9], 
    'Dm7':[2,5,9,12], 
    'Bb':[10,14,17], 
    'C7':[0,4,7], 
    'C':[0,4,7,10], 
    'G7':[7,11,14,17], 
    'A7sus4':[9,14,16,21], 
    'Gm6':[7,10,14,16], 
    'Fsus4':[5,10,12],
    }


#Read Chord Collection file
data = pd.read_csv(dirname+'/data/Beatles_chord_sequence.csv')
data

# %% Generate Bigrams
n = 2
chords = data['chords'].values
ngrams = zip(*[chords[i:] for i in range(n)])
bigrams = [" ".join(ngram) for ngram in ngrams]
bigrams[:5]

# %% Markov Chain prediction function
def predict_next_state(chord:str, data:list=bigrams):
    """Predict next chord based on current state."""
    # create list of bigrams which starts with current chord
    #bigrams_with_current_chord = # FILL CODE
    # count appearance of each bigram
    #count_appearance = # FILL CODE

    # convert appearance into probabilities
    #for ngram in count_appearance.keys(): # FILL CODE
        #count_appearance[ngram] = # FILL CODE
    # create list of possible options for the next chord
    #options = # FILL CODE
    # create  list of probability distribution
    #probabilities = # FILL CODE
    # return random prediction
    return # FILL CODE


# %% Sequence generation function
def generate_sequence(chord:str=None, data:list=bigrams, length:int=30):
    """Generate sequence of defined length."""
    # create list to store future chords
    chords = []
    for n in range(length):
        # append next chord for the list
        # FILL CODE
        # use last chord in sequence to predict next chord
        # FILL CODE
        pass #REMOVE THIS LINE
    return chords  

# %% Generate the sequence and send OSC message
chords = generate_sequence('C')


print('')
print('')
print('Generated Chords Sequence:')
print(chords)
time.sleep(2)
print('')
print('')
print('')
print('Play the sequence with supercollider:')


def start_osc_communication():
    # argparse helps writing user-friendly commandline interfaces
    parser = argparse.ArgumentParser()
    # OSC server ip
    parser.add_argument("--ip", default='127.0.0.1', help="The ip of the OSC server")
    # OSC server port (check on SuperCollider)
    parser.add_argument("--port", type=int, default=57121, help="The port the OSC server is listening on")

    # Parse the arguments
    args = parser.parse_args()

    # Start the UDP Client
    client = udp_client.SimpleUDPClient(args.ip, args.port)

    return client

client = start_osc_communication()

# Send chords
for c in chords:
    print(c)
    if len(chords_midi_dict[c]) == 3:
        client.send_message("/synth_control",['chord3',chords_midi_dict[c][0],chords_midi_dict[c][1],chords_midi_dict[c][2]])
        time.sleep(1)
    else:
        client.send_message("/synth_control",['chord4',chords_midi_dict[c][0],chords_midi_dict[c][1],chords_midi_dict[c][2],chords_midi_dict[c][3]])
        time.sleep(1)
    