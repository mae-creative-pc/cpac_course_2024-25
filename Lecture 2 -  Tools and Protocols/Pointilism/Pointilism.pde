PImage img;
int smallPoint, largePoint;
MyPoint p;

void setup() {
  size(1024, 576);
  frameRate(60);
  
  img = loadImage("40704.jpg");
  
  smallPoint = 20;
  largePoint = 80;
  color c = color(0, 0, 0);
  p = new MyPoint(10,10,20, c);
  
  imageMode(CENTER);
  noStroke();
  background(255);
}

void draw() { 
  //image(img,0,0);
  float pointillize = map(mouseX, 0, width, smallPoint, largePoint);
  int x = int(random(img.width));
  int y = int(random(img.height));
  color pix = img.get(x, y);
  //fill(pix, 128);
  p.move(x,y);
  p.plot(pointillize,pix);
  
  //ellipse(x, y, pointillize, pointillize);
}
