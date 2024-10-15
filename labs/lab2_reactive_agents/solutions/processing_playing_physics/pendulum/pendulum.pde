AgentPendulum pendulum;
float G=9.8;
int MASS_TO_PIXEL=10;
import oscP5.*;
import netP5.*;
int PORT = 57120;
OscP5 oscP5;
NetAddress ip_port;

void setup(){
  size(1280, 720);
  pendulum=new AgentPendulum(width/2, height/8, height/1.5, 200);
  background(0);  
  
  oscP5 = new OscP5(this,55000);
  ip_port = new NetAddress("127.0.0.1",PORT);
}
float computeForce(AgentPendulum pendulum){
   float force=0;
   force= -G*pendulum.mass * (float)Math.sin(pendulum.angle)/pendulum.r;
   /* your code here*/
   return force;
}

void sendEffect(float cutoff, float vibrato){
    OscMessage effect = new OscMessage("/note_effect");    
    effect.add("effect");       
    effect.add(cutoff);
    effect.add(vibrato);
    
    oscP5.send(effect, ip_port);
}

void draw(){
  rectMode(CORNER);
  fill(0,90);
  rect(0,0,width, height);
  float force=computeForce(pendulum);
  pendulum.applyForce(force);
  pendulum.update();
  pendulum.computeEffect();
  sendEffect(pendulum.cutoff, pendulum.vibrato);
  
  pendulum.draw();
  
}
