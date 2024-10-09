ParticleSystem ps;
int Nparticles=10000;
PImage img;

AudioIn audio;

boolean song_mic=false;
void setup(){
  size(1280,720, P2D);
  PVector origin=new PVector(0.75*width, height);
  ps=new ParticleSystem(origin);
  for(int p=0; p<Nparticles; p++){
    ps.addParticle();
  }
  img=loadImage("texture.png");
  audio=new AudioIn(song_mic, this);
  
  background(0);
}

PVector computeWind(){
  float energy= audio.getEnergy();
  PVector wind=new PVector(-energy, -2); 
  return wind;
}

void draw(){
  blendMode(ADD);
  background(0);
  PVector wind= computeWind();
  ps.action(wind);
}
