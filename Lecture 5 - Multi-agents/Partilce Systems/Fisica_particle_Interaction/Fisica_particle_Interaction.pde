import fisica.*;
 
FWorld world;
 
void setup() {
  size(800, 800);
 
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  //world.remove(world.bottom);
  //world.setGravity(-10, -30); //x,y 
  //world.setGrabbable(false);
  
  FBox b = new FBox(30, 50);        
  b.setPosition(width/2, 0);
  world.add(b);
  
  
  FBox b1 = new FBox(30, 50); 
  b1.setPosition(width/2, height/2);
  world.add(b1);
}


void draw() {
  background(0);  
  
  world.step();
  world.draw();
}
