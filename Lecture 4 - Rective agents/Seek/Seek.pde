

Vehicle v;

void setup() {
  size(800, 200);
  v = new Vehicle(width/2, height/2);
  smooth();
}

void draw() {
  if (mousePressed) {

    background(255);

    PVector mouse = new PVector(mouseX, mouseY);

    // Draw an ellipse at the mouse location
    fill(200);
    stroke(0);
    strokeWeight(2);
    ellipse(mouse.x, mouse.y, 48, 48);

    // Call the appropriate steering behaviors for our agents
    v.seek(mouse);
    v.run();
  }
}
