

Vehicle v,v1,v2,v3,v4;


void setup() {
  //size(800, 200);
  fullScreen();
  v = new Vehicle(width/2, height/2);
  v1 = new Vehicle(0, 0);
  v2 = new Vehicle(200, 200);
  v3 = new Vehicle(200, 200);
  v4 = new Vehicle(200, 200);
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
    v.arrive(mouse);
    v.run();
    v1.arrive(mouse);
    v1.run();
    v2.arrive(mouse);
    v2.run();
    v3.arrive(mouse);
    v3.run();
    v4.arrive(mouse);
    v4.run();
    
  }
}
