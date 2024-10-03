
// A basic implementation of John Conway's Game of Life CA

GOL gol;

void setup() {
  //size(800, 800);
  fullScreen();
  smooth();
  gol = new GOL();
}

void draw() {
  background(0);

  gol.generate();
  gol.display();
}

// reset board when mouse is pressed
void mousePressed() {
  gol.init();
}
