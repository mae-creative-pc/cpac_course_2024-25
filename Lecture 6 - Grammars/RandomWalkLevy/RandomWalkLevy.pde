

import oscP5.*;
import netP5.*;

Walker w;
OscP5 oscP5;
NetAddress myRemoteLocation;


void setup() {
  size(640,480);
  // Create a walker object
  w = new Walker();
  background(0);
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
}

void draw() {
  // Run the walker object
  w.step();
  w.render();
  
  OscMessage myMessage = new OscMessage("/position");
  myMessage.add(w.x/(width/2));
  myMessage.add(map((w.y+w.x),0,height+width,60,200));
  oscP5.send(myMessage, myRemoteLocation); 
  myMessage.print();
}
