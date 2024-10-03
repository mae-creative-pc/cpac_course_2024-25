
import processing.sound.*;
Amplitude amp;
AudioIn in;

float intensity; // value in range 0 to 1

void setup()
{
  //size(800,600);
  fullScreen();
  
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  intensity=0;
}



void draw()
{
  background(0);
  
  intensity = amp.analyze();
  
  //intensity = float(mouseX)/float(width);
  
  fill((intensity+0)*10*255,(intensity+0)*10*255,(intensity+0)*10*255);
  rect(0, 0, width, height*intensity*10);
}
