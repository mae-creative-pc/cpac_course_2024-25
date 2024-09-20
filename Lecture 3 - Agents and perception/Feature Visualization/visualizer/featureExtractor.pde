
import ddf.minim.*;
import ddf.minim.analysis.*;


class featureExtractor { 
  
  featureExtractor () {  
  } 
  
  // --- Spectral Flatness ------
  float flatness(FFT fft) { 

    float sln = 0; 
    float s = 0;
    float flat;

    for(int i = 0; i < fft.specSize(); i++)
    {
      sln = sln+log(fft.getBand(i));
      s = s+fft.getBand(i);
    }
    
    flat = exp(sln/fft.specSize())/(s/fft.specSize());

    return flat;
  } 
  
  // --- Spectral Centroid ------
  float centroid(FFT fft) {
    
    float s = 0;
    float c = 0;
    float centr;

    for(int i = 0; i < fft.specSize(); i++)
    {
      s = s+fft.getBand(i); 
      c = c+i*fft.getBand(i);
    }
    
    centr = c/s;
    return centr;
  } 
} 
