import fisica.*;
 
FWorld world;
 
void setup() {
  size(800, 800);
 
  Fisica.init(this);
  world = new FWorld();
  world.setEdges();
  //world.remove(world.bottom);
  //world.setGravity(-10, -30); //x,y 
  //world.setGrabbable(true);
  
  FBox b = new FBox(30, 50);        
  b.setPosition(width/2, 0);
  world.add(b);
  
  FBox b1 = new FBox(30, 50); 
  b1.setPosition(width/2, height/2);
  world.add(b1);
  
  /*FDistanceJoint spring = new FDistanceJoint(b, b1);
  spring.setStroke(0, 255, 0);
  spring.setFrequency(0.1);
  //spring.setDamping(3);
  world.add(spring);*/
  
  
  FRevoluteJoint spring = new FRevoluteJoint(b, b1);
  spring.setStroke(0, 255, 0);
  world.add(spring);
}


void draw() {
  background(0);  
  
  world.step();
  world.draw();
}
