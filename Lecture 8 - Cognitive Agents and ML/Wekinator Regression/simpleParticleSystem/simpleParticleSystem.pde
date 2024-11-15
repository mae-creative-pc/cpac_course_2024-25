import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

float x=0;
float y=0;

ParticleSystem ps;
int Nparticles=10000;
void setup(){
  size(1280,720);
  ps=new ParticleSystem();
  for(int p=0; p<Nparticles; p++){
    ps.addParticle();
  }
  background(0);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
}

void draw(){
  background(0);
  ps.origin=new PVector(x*width, y*height);
  ps.action();
}



//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      x = theOscMessage.get(0).floatValue();
      y = theOscMessage.get(1).floatValue();
  }
  
}
