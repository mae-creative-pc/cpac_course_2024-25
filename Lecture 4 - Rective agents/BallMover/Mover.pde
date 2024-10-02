class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  
  Mover() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector(0.1,-0.3);
  }
  
  void run(){
    update();
    checkEdges();
    render(); 
  }

  private void update() {
    acceleration = new PVector(random(-2, 2), random(-2, 2));
    location.add(velocity);
    velocity.add(acceleration); 
  }

  private void render() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }

  private void checkEdges() {

    if (location.x > width) {
      location.x = 0;
    } 
    else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = 0;
    } 
    else if (location.y < 0) {
      location.y = height;
    }
  }
}
