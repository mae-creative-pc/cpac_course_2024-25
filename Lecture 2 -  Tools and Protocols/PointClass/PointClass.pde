
float offset = 5;
color c;
float tempC = 0;

MyPoint p1;
MyPoint p2;

void setup(){
  size(800,800);
  frameRate(60);
  c = color(255, 0, 0);
  p1 = new MyPoint(10,10,40, c);
  p1.plot();
  
  c = color(0, 0, 255);
  p2 = new MyPoint(20,20,60, c);
  p2.plot();
}


void draw(){ 
  background(255,255,255);
  //c = color(255, 0, 0);
  //p1.changeColor(c);
  p1.move(offset,offset+1);
  p1.plot();
  tempC = tempC+offset;
  c = color(0, 0, tempC);
  p2.changeColor(c);
  p2.move(offset,offset+1);
  p2.plot();
}
