import controlP5.*;

float separationDistance = 100;
float alignDistance = 20; // 20,100
float cohesionDistance = 50;
float cohesionAttractorDistance = 39;

float separationStrength = 0;
float alignStrength = 0;
float cohesionStrength = 0;
float cohesionAttractorStrength = 0;

float randomness = 0; 
Boolean drawTrace = true;

outLine outl;
Flock flock;
int Initial_num = 0;   // Initial number of flocks

ControlP5 cp5;

void setup() {
  //size(800,600);
  fullScreen();
  background(0);
  
  outl = new outLine();

  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < Initial_num; i++) {
    Boid b = new Boid(width/2,height/2);
    flock.addBoid(b);
  }
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("separationStrength")
     .setPosition(50,30)
     .setRange(0,5)
     .setValue(0)
     ;
     
  cp5.addSlider("alignStrength")
     .setPosition(50,40)
     .setRange(0,3)
     .setValue(0)
     ;
  cp5.addSlider("cohesionStrength")
     .setPosition(50,50)
     .setRange(0,3)
     .setValue(0)
     ;
  
  smooth();
}

void draw() {
  if (!drawTrace){
    background(0);
  }
  flock.run();
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}
