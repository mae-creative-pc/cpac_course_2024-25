# %% Import libraries

import numpy as np
import os
import librosa
from librosa import  load
import soundfile as sf
import matplotlib.pyplot as plt

os.chdir(os.path.abspath(os.path.dirname(__file__)))
# This is useful to change the current directory to the one where there is the file
import your_code

DATA_DIR="../../../data"
assert os.path.exists(DATA_DIR), "wrong data dir"
# %% Define filenames
filename_in=os.path.join(DATA_DIR, "tire_swings.wav") # put whatever you like
filename_kick=os.path.join(DATA_DIR, "kick.wav") # put whatever you like
filename_out=os.path.join(DATA_DIR, "tire_disco.wav") # 

# %% 1) Load a song

SR=16000
y, sr = load(filename_in, sr=SR)
 #your code here
# %% 2) Find the beats
beats=your_code.compute_beats(y, sr=SR)

# %% See if beats are correct
t=np.arange(y.size)/SR
plt.figure()
plt.plot(t, y, label="y")
plt.vlines(t[beats], -1,1, label="beats", color="red")
plt.xlim([0, 5])
plt.xlabel("Time [s]")
plt.legend()
plt.show()
# %% 3) Load a heavy kick
# your code here
kick, sr = load(filename_kick, sr=SR)
# %% 4 ) Put the kick on song at the correct beats

y_out = your_code.add_samples(y, kick, beats)

# %% show the difference
plt.figure()
plt.subplot(2,1,1)
plt.plot(t, y)
plt.xlim([0, 5])
plt.xlabel("Time [s]")
plt.title("$y(n)$")
plt.subplot(2,1,2)
plt.plot(t, y_out)
plt.title("$\\tilde{y}(n)$")
plt.xlim([0, 5])
plt.xlabel("Time [s]")
plt.show()

# %% 5) Write the final song 

sf.write(filename_out, y_out, SR)
