

import ddf.minim.*;
import ddf.minim.analysis.*;
import javax.swing.*; 

Minim minim;
AudioPlayer song;
//AudioInput song;
FFT fft;
featureExtractor feat;

int canvasWidth = 1012;
int canvasHeight = 812;
int frameLength = 1024;

int[][] sgram = new int[canvasWidth][frameLength/2];
int col=0;
int leftedge = 0;
int count = 0;
float flatMean = 0;
float centrMean = 0;
String myInputFile;
//final JFileChooser fc = new JFileChooser();
//int returnVal = fc.showOpenDialog();

void setup()
{
  size(800,800);
  //fullScreen();
  background(0);
  smooth();

  minim = new Minim(this);

/*
  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    myInputFile = file.getAbsolutePath();
  } 
  else { 
    println("Cancelled.");
  }*/


  // Load Audio
  //song = minim.loadFile("./data/sweeplin.mp3",frameLength);
  //song = minim.loadFile("./data/distort.mp3",frameLength);
  //song = minim.loadFile("./data/noise.mp3",frameLength);
  //song = minim.loadFile("./data/violin.mp3",frameLength);
  song = minim.loadFile("./data/003.mp3",frameLength);
  //song = minim.loadFile(myInputFile,frameLength);
  song.play();
  
  // Audio input
  //song = minim.getLineIn(Minim.MONO, frameLength);

  // FFT
   fft = new FFT(song.bufferSize(), song.sampleRate());
   fft.window(FFT.HAMMING);
  
  // Features
   feat = new featureExtractor();
}

void draw() {
 
  // screen division
  stroke(170);
  line(0,frameLength/2,canvasWidth,frameLength/2);
  line(500,frameLength/2,500,canvasHeight);
  
  fft.forward(song.mix);
  
  
  // -------- Spectrum --------
  
  fill(0);
  rect(500,frameLength/2, frameLength/2,500);
  
  colorMode(HSB, 255);
  int svalSpect = 0;
  
  for(int i = 0; i < fft.specSize(); i++)
  {
     int val = (int)Math.round(Math.max(0,52*Math.log10(1000 * fft.getBand(i))));
     svalSpect = Math.min(255, val);
     stroke(255 - svalSpect, svalSpect, svalSpect);
     //point(col,i);
     line(i+500, canvasHeight, i+500, canvasHeight - svalSpect);
  }
  
 
  // --------- Spectrogram --------
  
    colorMode(HSB, 255);
    int sval = 0;
    
    int rowmax = frameLength/2;
    int colmax = canvasWidth;

    for (int i = 0; i < rowmax /* fft.specSize() */; ++i) {
        // fill in the new column of spectral values (and scale)
        //sgram[col][i] = (int)Math.round(Math.max(0, 52 * Math.log10(1000 * fft.getBand(i))));
        int val = (int)Math.round(Math.max(0, 52 * Math.log10(1000 * fft.getBand(i))));
        sval = Math.min(255, val);
        stroke(255 - sval, sval, sval);
        point(col,i);
    }
    // next time will be the next column
    col = col + 1;
   
    // wrap back to the first column when we get to the end
    if (col == colmax) {
      col = 0;
      fill(0);
      rect(0,0,colmax,rowmax);
    }



  // --------- Features --------
  flatMean = flatMean + feat.flatness(fft);
  centrMean = centrMean + feat.centroid(fft);
  
  int featWin = 5;
  if (count == featWin)
  {
    // clean
    fill(0);
    rect(0,frameLength/2+2, 500-2,500);
         
    // Display Flatness     
    flatMean = flatMean/featWin;
    flatMean = (flatMean/0.6)*270;
    
    colorMode(HSB, 255);
    fill(100,255, flatMean+100);
    
    if (flatMean > 270)
    {
      flatMean = 270;
    }
    
    rect(20,canvasHeight, 50,-flatMean);
    text("FLAT", 20, canvasHeight-flatMean-10);
    
    // Display Centroid  
    centrMean = centrMean/featWin;
    centrMean = (centrMean/512)*270;
    colorMode(HSB, 255);
    fill(150,255, ((centrMean/300)*255)+100);
    
    if (centrMean > 270)
    {
      centrMean = 270;
    }
    rect(73,canvasHeight, 50,-centrMean);
    fill(150,255, 255);
    text("CENTR", 73, canvasHeight-centrMean-10);
    
    println(flatMean);
    println(centrMean);
    
    count = 0;
    flatMean = 0;
    centrMean = 0;
  }
  else
    count = count+1;
  
}






 
