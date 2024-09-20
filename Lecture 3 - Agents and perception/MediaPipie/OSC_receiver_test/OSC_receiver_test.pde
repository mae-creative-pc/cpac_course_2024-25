import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
float x, y, z;

void setup() {
  size(400, 400);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,"127.0.0.1",12000,1); //listen for OSC messages
  //dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
}

void draw() {
  background(255);
  rect(x, y, 100, 100);
}


//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  println("received message");
  if (theOscMessage.checkAddrPattern("coord") == true) {
      x = (1-theOscMessage.get(0).floatValue())*width;      // x value shoild be in the range[0:1]
      y = theOscMessage.get(1).floatValue()*height;     // y value shoild be in the range[0:1] 
      //z = theOscMessage.get(2).intValue();  
      print("x: "+x+" - ");
      print("y: "+y+" - ");
      println("z: "+z);
  }
  
}
