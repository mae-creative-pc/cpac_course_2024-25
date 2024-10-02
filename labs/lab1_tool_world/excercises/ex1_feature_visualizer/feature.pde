import ddf.minim.*;
import ddf.minim.analysis.*;




float compute_energy() {    
  return random(3);
}

float compute_centroid(){
    return random(3);
}

float compute_flatness(){
  return random(3);
}

float compute_spread(){
  return random(3);
}

float compute_skewness(){
  return random(3);  
}

float compute_entropy(){
  return random(3);
}


class AgentFeature { 
  float sampleRate;
  int K;
  FFT fft;
  BeatDetect beat;
  
  float[] freqs;
  float sum_of_bands;
  float centroid;
  float spread;
  float energy;
  float skewness;
  float entropy;
  float flatness;
  boolean isBeat;
  float lambda_smooth;
  AgentFeature(int bufferSize, float sampleRate){    
    this.fft = new FFT(bufferSize, sampleRate);
    this.fft.window(FFT.HAMMING);
    this.K=this.fft.specSize();
    this.beat = new BeatDetect();
    
    this.lambda_smooth = 0.5;
    this.freqs=new float[this.K];
    for(int k=0; k<this.K; k++){
      this.freqs[k]= (0.5*k/this.K)*sampleRate;
    }
    
    this.isBeat=false;
    this.centroid=0;
    this.spread=0;
    this.sum_of_bands = 0;
    this.skewness=0;    
    this.entropy=0;
    this.energy=0;
  }
  float smooth_filter(float old_value, float new_value){
    /* Try to implement a smoothing filter using this.lambda_smooth*/
    return new_value;
    
  }
  void reasoning(AudioBuffer mix){
     this.fft.forward(mix);
     this.beat.detect(mix);
     
     float energy = compute_energy();
     float centroid = compute_centroid();
     float flatness = compute_flatness();
     float spread = compute_spread();                                  
     float skewness= compute_skewness();
     float entropy = compute_entropy();     
     
     this.energy = energy;
     this.centroid = centroid;    
     this.flatness = flatness;
     this.spread = spread;
     this.skewness = skewness;
     this.entropy = entropy;  }   
} 
