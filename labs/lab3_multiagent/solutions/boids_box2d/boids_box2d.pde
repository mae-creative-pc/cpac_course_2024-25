boolean DRAW_DEBUG=false;
String filenames[];

Path path;
ArrayList<Boid> boids;
processing.core.PApplet app;


void setup() {
  size(1280, 1024);
  app=this;
  box2d = new Box2DProcessing(this);
  setupBox2d(box2d);
  
  boids=new ArrayList<Boid>();
  boundaries=new Boundaries(width, height);
  path=createPath();
  filenames = getFilenames();
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new boid
    Boid b = new Boid(P2W(mouseX, mouseY));
    boids.add(b);     
  }
  if(mouseButton==RIGHT){ 
    ;
  }
}
 
void keyPressed(){
  if(key=='d'){
    DRAW_DEBUG=!DRAW_DEBUG;
  }
   if(key=='r'){ // reset
     reset(boids);
  }
}
 
void draw() {
  fill(0,50);
  rect(width/2, height/2, width, height);
  
  box2d.step();
  path.draw();
  boundaries.draw();
  for (Boid b : boids) {
    b.steer();
    b.update(boids);
    b.draw();
  }
}
