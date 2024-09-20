import processing.video.*;

Capture cam;
PImage img;
color c;

char effectNum;

void setup() {
  size(640, 480,P3D);
  
  c = color(255, 204, 0);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}


void draw() {
  
  background(255);
    
  if (cam.available() == true) {
    cam.read();
  }
  
  switch(effectNum) {
    case '1':   // FLIP
      scale(0.5,0.5);
      image(cam,0,0);
      print("1");
      break;
    case '2':   // ROTATE
      scale(0.5,0.5);
      rotate(radians(30));
      image(cam,width/2,height/2);
      break;
    case '3':   // ROTATE
      imageMode(CENTER);
      translate(width/2,height/2);
      scale(0.5,0.5);
      rotateZ(radians(60));
      image(cam,0,0);
      break;
    case '4':   // ROTATE
      imageMode(CENTER);
      translate(mouseX, mouseY);
      image(cam,0,0);
      break;
    case '5':   // ROTATE
      imageMode(CORNER);
      tint(255,0,0);
      image(cam,0,0,width/2,height/2);
      tint(0,255,0);
      image(cam,width/2,0,width/2,height/2);
      tint(0,0,255);
      image(cam,0,height/2,width/2,height/2);
      tint(255,0,255);
      image(cam,width/2,height/2,width/2,height/2);
      break;
      
    default:             // Default executes if the case names
      image(cam,0,0);
      break;
  }
}


void keyPressed(){
  effectNum = key;
}
