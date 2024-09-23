import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;  
// Frame length
int frameLength = 1024; //--> when this is low, it may take more to compute

AgentFeature feat;
AgentDrawer drawer;

void setup()
{
  size(1280, 720);
  background(0);
  smooth();
  minim = new Minim(this);
  /* put any file you like here*/
  song = minim.loadFile("../../../../data/mashup.mp3",frameLength);  
  feat = new AgentFeature(song.bufferSize(), song.sampleRate());
  song.play();     
  
  drawer=new AgentDrawer(feat, 6);
}


void draw(){
  fill(0);
  rect(0,0,width, height);
  feat.reasoning(song.mix);  
  drawer.action();
}


 
