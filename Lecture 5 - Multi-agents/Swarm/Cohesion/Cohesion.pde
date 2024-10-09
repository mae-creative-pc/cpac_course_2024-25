

// Click mouse to add boids into the system

Flock flock;
int Initial_num = 0;   // Initial number of flocks

void setup() {
  //size(800,600);
  fullScreen();
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < Initial_num; i++) {
    Boid b = new Boid(width/2,height/2);
    flock.addBoid(b);
  }
  smooth();
}

void draw() {
  background(255);
  flock.run();
  
    // Instructions
  fill(0);
  text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}
