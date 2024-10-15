    
import sys
import time

import numpy as np

    
from classes import Agent, Composition, ID_START

class Random_Next(Composition):
    def __init__(self, BPM=60):
        Composition.__init__(self,BPM=BPM)
            
    def next(self):
        if self.id ==ID_START: 
            self.id=0
        self.midinote=int(np.random.randint(60,84))
        self.dur =float(2**np.random.randint(-3, 0))
        self.amp = float(np.random.choice([0,1,1,1]))
        self.id+=1
        if self.id==10:
            self.BPM=np.random.randint(60, 120)
            self.id = 0
            

if __name__=="__main__":
    n_agents=1
    composer=Random_Next()
    agents=[_ for _ in range(n_agents)]
    agents[0] = Agent(57120, "/note_effect", composer)

    input("Press any key to start \n")
    for agent in agents:
        agent.start()
    try: # USE CTRL+C to exit     
        while True:
            time.sleep(10)
    except:         
        for agent in agents:              
            agent.kill()
            agent.join()
        sys.exit()

# %%