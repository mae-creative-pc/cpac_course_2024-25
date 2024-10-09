import ddf.minim.*;
import ddf.minim.analysis.*;

int frameLength = 1024; //--> when this is low, it may take more to compute


class AudioIn{
   AudioInput mic;
   AudioPlayer song;

   FFT fft;
   Minim minim;
   float maxEnergy=1;
   boolean song_mic=true;
   float energy=1;
   AudioIn(boolean song_mic, Particle_System_wind app){
     this.minim= new Minim(app);
     this.song_mic=song_mic;
     if(this.song_mic){
       this.song = minim.loadFile("../data/wind.mp3",frameLength);
       this.song.loop();  
       this.fft = new FFT(song.bufferSize(), song.sampleRate());
       this.fft.window(FFT.HAMMING);      
     }
     else{this.mic = minim.getLineIn(Minim.MONO, frameLength);
          this.fft = new FFT(mic.bufferSize(), mic.sampleRate());
          this.fft.window(FFT.HAMMING);}
          this.energy=0;
      }
      
  float getEnergy(){    
    if(this.song_mic){this.fft.forward(this.song.mix);}
    else{this.fft.forward(this.mic.mix);}
    float energy = 0;
    for(int i = 0; i < this.fft.specSize(); i++){
       energy+=pow(this.fft.getBand(i),2);      
    }
    this.maxEnergy=max(this.maxEnergy, energy);
    energy=map(energy,0, this.fft.specSize(), 0, 1);
    this.energy= this.energy*0.1+energy*0.9;
    
    return this.energy;
  }
}
