import oscP5.*;

OscP5 oscP5;
Circle circ;

void setup() {
  fullScreen();
  oscP5 = new OscP5(this, 57120);
  background(0);
  circ = new Circle();
  // We will work on HSB color mode and not RGB
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  background(0);
  circ.drawCircle();
}

void oscEvent(OscMessage theOscMessage) {
  searchOscMessage(theOscMessage);
  /*print("### received an osc message.");
   println("Message: " + theOscMessage.addrPattern() + " value: " + theOscMessage.get(0).floatValue());*/
}

// You can configure the OSC message you want and associate it to the parameter of your choice
void searchOscMessage(OscMessage theOscMessage) {
  // We expect to get a float value as an OSC message
  float value = theOscMessage.get(0).floatValue();

  // Be careful what is the float number we are passing with the OSC message, if you see
  // from the function map we are most of the time expecting a value between 0 and 1
  switch (theOscMessage.addrPattern()) {
  case "/LFO1":
    value = map(value, 0, 1, 5, 60);
    circ.s = value;
    break;
  case "/LFO2":
    value = map(value, 0, 1, 50, 150);
    //circ.c = value;
    break;
  case "/LFO3":
    value = map(value, 0, 1, (height/2) - 100, (height/2) + 100);
    //circ.y = value;
    break;
  case "/LFO4":
    value = map(value, 0, 1, (width/2) - 200, (width/2) + 200);
    //circ.x = value;
    break;
  case "/EF1":
    value = map(value, 0, 1, 200, 1000);
    circ.dx = value;
    break;
  case "/EF2":
    value = map(value, 0, 1, 200, 1000);
    circ.dy = value;
    break;
  case "/Shaper1":
    break;
  case "/Shaper2":
    break;
  case "/Auto1":
    value = map(value, 0, 1, 0, PI);
    circ.rot = value;
    break;
  case "/x":
    value = map(value, 0, 1, 200, 1000);
    circ.dx = value;
    break;
  case "/y":
    value = map(value, 0, 1, 1000, 200);
    circ.dy = value;
    break;
  case "/color":
    // Only here we don't get the hue of the color as a number from 0 to 1 but from 0 to 360
    circ.c = smooth_filter(circ.c, value);
    break;
  }
}

// If you want you can apply a smoothing function, for now it's only applied to the color OSC message
float smooth_filter(float old_value, float new_value) {
  float lambda_smooth = 0.3f;
  return lambda_smooth * new_value + (1 - lambda_smooth) * old_value;
}
