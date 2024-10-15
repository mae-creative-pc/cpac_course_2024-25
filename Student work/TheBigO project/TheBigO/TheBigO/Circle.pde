public class Circle {
  public float x, y, dx, dy, rot, s, c;
  // Constructor with defined parameters
  public Circle(float x, float y, float dx, float dy, float s, float c, float rot) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.s = s;
    this.c = c;
    this.rot = rot;
  }
  // Constructor with default parameters
  public Circle() {
    defaultCircle();
  }

  public void drawCircle() {
    color colore = color(this.c, 255, 255);
    pushMatrix();
    translate(width/2, height/2);
    rotate(this.rot);
    noFill();
    strokeWeight(this.s);
    stroke(colore);
    ellipse(this.x, this.y, this.dx, this.dy);
    popMatrix();
  }
  public void defaultCircle() {
    this.x = 0;
    this.y = 0;
    this.dx = 400;
    this.dy = 400;
    this.s = 10;
    this.c = 255;
    this.rot = 0;
    drawCircle();
  }
}
