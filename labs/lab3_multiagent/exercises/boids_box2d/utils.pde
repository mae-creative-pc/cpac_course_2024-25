import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

int RADIUS_BOID=30;
float SCALEFORCE=100000;
float DIST_TO_NEXT=50;
BodyDef bd;
Box2DProcessing box2d;
Boundaries boundaries;
CircleShape cs;

/* This convert coordinates */ 
Vec2 P2W(Vec2 in_value){
  return box2d.coordPixelsToWorld(in_value);
}

Vec2 P2W(float pixelX, float pixelY){
  return box2d.coordPixelsToWorld(pixelX, pixelY);
}


Vec2 W2P(Vec2 in_value){
  return box2d.coordWorldToPixels(in_value);
}

Vec2 W2P(float worldX, float worldY){
  return box2d.coordWorldToPixels(worldX, worldY);
}

/* this converts scalars*/
float P2W(float in_value){
  return box2d.scalarPixelsToWorld(in_value);
}
float W2P(float in_value){
  return box2d.scalarWorldToPixels(in_value);
}

void setupBox2d(Box2DProcessing box2d){
  // initialize everything

  box2d.createWorld();
  box2d.setGravity(0, 0); // gravity 0 since we don't have gravity here
  box2d.listenForCollisions(); // every time a new collision occurs, the function beginContact will be called
  
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC; // dynamic bodyshapes for boids
  cs  = new CircleShape(); 
  cs.m_radius = P2W(RADIUS_BOID/2); // circle shape for boids
  bd.linearDamping=0;  // remove damping
}

String[] getFilenames(){
  // finds all the wavfiles in the folder Sound
  
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
  String[] all_filenames=dir.list();
  int N =0;
  for(int i=0; i<all_filenames.length; i++){
    if(all_filenames[i].endsWith(".wav")){N++;}
  }
  String[] wav_filenames=new String[N];
  int j=0;
  for(int i=0; i<all_filenames.length; i++){
    if(all_filenames[i].endsWith(".wav")){
        wav_filenames[j]=all_filenames[i];
        j++;
    }  
  }
  
  return wav_filenames;
  
}
void reset(ArrayList<Boid> boids){
   for(int i=boids.size()-1; i>=0; i--){
     box2d.destroyBody(boids.get(i).body);
     boids.remove(i);
   }
}
void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body body1 = f1.getBody();
  Body body2 = f2.getBody();
  Boid b1 = (Boid) body1.getUserData();
  Boid b2 = (Boid) body2.getUserData();
  // we found the possible boids, but this can also be  boundaries
  
  if (b1!=null) {b1.contact();}
  if (b2!=null) {b2.contact();}
}

void endContact(Contact cp) {
  ;
}
