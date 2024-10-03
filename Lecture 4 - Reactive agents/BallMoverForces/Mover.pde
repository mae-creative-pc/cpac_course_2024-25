class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover() {
    location = new PVector(random(0,width),random(0,height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    mass = 10;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);  // Force/Mass
    acceleration.add(f);
  }


  void run(){
    update();
    checkEdges();
    render(); 
  }


  private void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);  // Since the acceleration corresponds to the force, need to be set up to 0 each cycle
  }

  private void render() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x,location.y,48,48);
  }
  
 
  void checkEdges() {

    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;    // bouncing
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }

    if (location.y > height) {
      velocity.y *= -1;    // bouncing
      location.y = height;
    }
  }
}
