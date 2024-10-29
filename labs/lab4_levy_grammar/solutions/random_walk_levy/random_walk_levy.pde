import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress ip_port;
int PORT = 57120;
PVector CENTER_SCREEN;
float ALPHA_BACKGROUND=2;
int MONTECARLO_STEPS=1; // START WITH TWO-STEPS MONTECARLO, THEN WITH ONE-STEP

Walker walker;
void setup() {
  size(1280,720);

  walker=new Walker();  // Create a walker object
  background(0);
  CENTER_SCREEN=new PVector(width/2, height/2);  
  oscP5 = new OscP5(this,12000);
  ip_port = new NetAddress("127.0.0.1",PORT);
}


void sendEffect(Walker w){
    OscMessage msg = new OscMessage("/note_effect");    
    msg.add(w.freq);
    msg.add(w.amp);
    msg.add(w.cutoff);
    msg.add(w.vibrato);
    oscP5.send(msg, ip_port);
}

void draw() {
  // Run the walker object
  fill(0, ALPHA_BACKGROUND);
  strokeWeight(0);
  rect(0,0,width, height);
  walker.update();
  walker.computeEffect();
  walker.draw();  
  sendEffect(walker);
} 
