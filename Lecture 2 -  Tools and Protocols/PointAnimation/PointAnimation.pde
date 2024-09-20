
float offset = 1;
color c1;
color c2;

MyPoint p1;
MyPoint p2;

void setup(){
  size(800,800);
  background(255,255,255);
  frameRate(60);
  
  c1 = color(255, 204, 0);
  c2 = color(255, 10, 0);
  p1 = new MyPoint(10,10,10, c1);
  p2 = new MyPoint(150,300,20, c2);
  p1.plot();
  p2.plot();
}


void draw(){ 
  background(255,255,255);
  p1.move(offset,offset);
  p1.plot();
  p2.move(offset,offset+1);
  p2.plot();
}
