import time
from threading import Thread, Event
from pythonosc import udp_client

ID_START=-1
class Composition:
    def __init__(self, id=ID_START, midinote=ID_START, dur=0, amp=0, BPM=120):
        self.id=id
        self.midinote=midinote
        self.dur=dur
        self.amp=amp
        self.BPM=BPM        
    def __str__(self):
        return "\n\t".join(["Id: %d"%self.id, 
                                "midinote: %d"%self.midinote, 
                                "duration: %s beats"%str(self.dur),
                                "amplitude: %.1f"%self.amp,
                                "BPM: %d"%self.BPM])
    def next(self):
        """ not created"""
        pass   
class InstrOSC():
    def __init__(self,ip="127.0.0.1",  port=57121, name="/note"):
        self.name=name
        self.client = udp_client.SimpleUDPClient(ip, port)

    def send(self, *data):        
        print("sending %s"%str(data))
        self.client.send_message(self.name, data)


def note_sleep(BPM, beats):
    time.sleep(beats*60./BPM)
def beats_to_seconds(BPM, beats):
    return beats*60./BPM

class Agent(Thread):
    def __init__(self, port, name, composer):
        self.composer=composer
        super().__init__(daemon=True, target=self.action)
        self.instrument=InstrOSC(port=port, name=name)                        
        self.stop=Event()
        self.stop.clear()
    
    def kill(self):
        # before killing it, I set the amplitude to 0            
        self.stop.set()

    def action(self):
        while not self.stop.is_set():
            self.composer.next()                    
            print(str(self.composer))            
            self.instrument.send("note", self.composer.midinote,                            
                            self.composer.amp)
            note_sleep(self.composer.BPM, self.composer.dur)
        # silence        
        self.instrument.send("note", self.composer.midinote, 0)

