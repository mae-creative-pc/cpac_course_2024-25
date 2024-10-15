import oscP5.*;
import netP5.*;
int PORT = 57120;
OscP5 oscP5;
NetAddress ip_port;


void setup(){
  oscP5 = new OscP5(this,55000);
  ip_port = new NetAddress("127.0.0.1",PORT);
  
  size(1280, 720);
  background(0);
}

void sendEffect(float cutoff, float vibrato){
    OscMessage effect = 
            new OscMessage("/note_effect");    
    effect.add("effect");       
    effect.add(cutoff);
    effect.add(vibrato);    
    oscP5.send(effect, ip_port);
}

void draw(){
  background(0);
  rectMode(CENTER);
  fill(255);
  ellipse(mouseX, mouseY, 10, 10);
  float cutoff =  map(mouseY, 0, height,0,1); 
  float vibrato = map(mouseX, 0, width, -0.5, 0.5);

  sendEffect(cutoff, vibrato);
}
