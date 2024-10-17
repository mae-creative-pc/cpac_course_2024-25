import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;  
// Frame length
int frameLength = 1024; //--> when this is low, it may take more to compute

AgentFeature feat;


ParticleSystem ps;
int Nparticles=1000;
PImage img;


void setup(){
  size(1280,720, P2D);
  ps=new ParticleSystem();
  for(int p=0; p<Nparticles; p++){
    ps.addParticle();
  }
  img=loadImage("texture.png");
    minim = new Minim(this);
  /* put any file you like here*/
  song = minim.loadFile("../../../../data/mashup.mp3",frameLength);  
  feat = new AgentFeature(song.bufferSize(), song.sampleRate());
  song.play();     
  
  background(0);
}

void draw(){
  blendMode(ADD);
  background(0);
  feat.reasoning(song.mix);  
  
  // YOUR CODE HERE: use the energy to make some harlem shake of the track
  ps.followMusic(feat);
  ps.draw();
  
}
