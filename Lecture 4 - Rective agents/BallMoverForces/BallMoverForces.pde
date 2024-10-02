Mover m;
Mover m2;

void setup() {
  size(800,200);
  smooth();
  m = new Mover();
  m2 = new Mover();
}

void draw() {
  background(255);

  PVector wind = new PVector(random(-4,4),0);
  PVector gravity = new PVector(0,0.9);
  m.applyForce(wind);
  m.applyForce(gravity);
  
  m2.applyForce(wind);
  m2.applyForce(gravity);

  m.run();
  m2.run();

}
