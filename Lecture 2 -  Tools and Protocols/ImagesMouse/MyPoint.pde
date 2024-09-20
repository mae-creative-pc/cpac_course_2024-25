
class MyPoint{
  
  float x,y;
  float size; 
  color c;
  
  //Constructor
  public MyPoint(float x, float y, float size, color c){
    this.x = x;
    this.y = y;
    this.size = size;
    this.c = c;
  }
  
  // ---- Methods
  public void plot(float size, color c){
    noStroke();
    fill(c);
    ellipse(x,y,size,size);
  }
  
  public void move(float newX, float newY){
    x = newX; 
    y = newY;
  }
}
