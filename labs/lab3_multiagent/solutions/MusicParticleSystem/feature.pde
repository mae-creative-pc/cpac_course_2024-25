import ddf.minim.*;
import ddf.minim.analysis.*;

float compute_flatness(FFT fft, float sum_of_spectrum){   
   // using several products will get overflow;
   // so instead of computing the harmonic mean, 
   // compute the exponential of the average of the logarithms
   float sum_of_logs = 0;    
   float flatness;
   for(int i = 0; i < fft.specSize(); i++)
   {
     sum_of_logs += log(fft.getBand(i));      
   }
   flatness = exp(sum_of_logs/fft.specSize()) / 
                 (0.000001+sum_of_spectrum/fft.specSize());
   return flatness;
}

float compute_centroid(FFT fft, float sum_of_spectrum, 
                                        float[] freqs){
   float centroid=0;
    for(int i = 0; i < fft.specSize(); i++){
      centroid += freqs[i]*fft.getBand(i);
    }
    return centroid/(0.00001+sum_of_spectrum);
}

float compute_spread(FFT fft, float centroid, float sum_of_bands, float[] freqs){
  float spread=0;
  for (int i=0; i<fft.specSize(); i++){
     spread+= pow(freqs[i]-centroid,2)*fft.getBand(i);
  }
  return sqrt(spread/(0.000001+sum_of_bands));
}

float compute_skewness(FFT fft, float centroid, float spread, float[] freqs){
  float skewness=0;
  for (int i=0; i<fft.specSize(); i++){
     skewness+= pow(freqs[i]-centroid,3)*fft.getBand(i);
  }
  return skewness/(0.00001+fft.specSize()*pow(spread,3));
}

float compute_entropy(FFT fft){
  float entropy =0;
  for (int i=1; i<fft.specSize(); i++){
     entropy+= fft.getBand(i)*log(0.00001+fft.getBand(i));
  }
  return entropy/log(fft.specSize());
}

float compute_sum_of_spectrum(FFT fft){
  float sum_of=0;
  for(int i = 0; i < fft.specSize(); i++)
   {
     sum_of += fft.getBand(i);      
   }
  return sum_of+1e-15; // adding a little displacement to avoid division by zero
}

float[] compute_peak_band_and_freq(FFT fft, float[] freqs){
  float val=0;
  float maxPeakVal=0;
  float maxFreqVal=0;
  float[] peak_band_freq= new float[2];
  peak_band_freq[0]=0.; // peak band
  peak_band_freq[1]=0.; // peak freq
  
  for(int i = 0; i < fft.specSize(); i++){
    val=fft.getBand(i);
    if(val>maxPeakVal){ 
      maxPeakVal=val;
      peak_band_freq[0]=1.0*i;
    }
    if(val>maxFreqVal && freqs[i]>20.){ 
      // if new max in the audible spectrum
      peak_band_freq[1]=freqs[i];
      maxFreqVal=val;
    }
  }     
  return peak_band_freq;
}

float get_average(float[] buffer){
  float average=0;
  for(int i=0; i<buffer.length; i++){
      average+=buffer[i];
  }
  return average/buffer.length;
}
float compute_energy(FFT fft) {    
  float energy = 0;
  for(int i = 0; i < fft.specSize(); i++){
    energy+=pow(fft.getBand(i),2);      
  }   
  return energy;
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
    
    this.lambda_smooth = 0.9;
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
    return this.lambda_smooth*new_value+(1-this.lambda_smooth)*old_value;
  }
  void reasoning(AudioBuffer mix){
     this.fft.forward(mix);
     this.beat.detect(mix);
     float sum_of_bands = compute_sum_of_spectrum(this.fft);
     float centroid = compute_centroid(this.fft,sum_of_bands,this.freqs);
     float flatness = compute_flatness(this.fft, sum_of_bands);
     float spread = compute_spread(this.fft, centroid, sum_of_bands, this.freqs);                                  
     float skewness= compute_skewness(this.fft, centroid, spread, this.freqs);
     float entropy = compute_entropy(this.fft);     
     float energy = compute_energy(this.fft);
     
     this.centroid = this.smooth_filter(this.centroid, centroid);    
     this.energy = this.smooth_filter(this.energy, energy);
     this.flatness = this.smooth_filter(this.flatness, flatness);
     this.spread = this.smooth_filter(this.spread, spread);
     this.skewness = this.smooth_filter(this.skewness, skewness);
     this.entropy = this.smooth_filter(this.entropy, entropy);
     this.isBeat = this.beat.isOnset();
  }   
} 
