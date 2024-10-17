# %%
import os
import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf
#freqs_base = 2*np.array([130.81, 146.83,164.81, 196.00, 220.00])
# C3, D3, E3, G3, A3
freqs_base = 2*np.array([130.81,164.81, 196.00])
# C3, D3, E3, G3, A3

sr=16000 # samplerate

open_close_time=0.1

DUR = 0.2 # seconds
Osc="saw"

def create_env_cos():
    
    dur=max(DUR,1.01*open_close_time)
    env=np.zeros((int(dur*sr),)) #envelope
    N=int(sr*open_close_time)
    
    env[:N]=np.sin(np.linspace(0, np.pi, N))
    return env

if __name__=="__main__":
    freqs=[]
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    if not (os.path.exists("sounds")):
        os.makedirs("sounds")
    for octave in range(1,4):
        freqs.extend((freqs_base*octave).tolist())
    
    env=create_env_cos()
    t= np.arange(0, env.size)/sr    
    
    #plt.plot(t, env)
    
    
    for f, freq in enumerate(freqs):
        fn_out="sounds/%.2fHz.wav"%(freq)               
        if Osc=="square":
            T=int(sr/freq)
            square=np.zeros((T,))-1
            square[int(T/4):int(-T/4)]=1
            sample=np.tile(square, (int(np.ceil(sr*DUR/T)),))
            sample=sample[:int(sr*DUR)]
            
        elif Osc=="saw":
            T=int(sr/freq)
            saw=np.zeros((T,))
            saw[:int(T/2)]=np.linspace(-1,1,int(T/2))
            saw[int(T/2):]=np.linspace(1,-1,T-int(T/2))            
            sample=np.tile(saw, (int(np.ceil(sr*DUR/T)),))
            sample=sample[:int(sr*DUR)]
            
        sample*=env
        sf.write(fn_out, 0.707*sample/np.max(np.abs(sample)), sr)
    
# %%
