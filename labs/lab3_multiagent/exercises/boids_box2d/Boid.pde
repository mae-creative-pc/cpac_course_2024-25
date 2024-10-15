
float AVOID_DIST=6;
float ALIGN_DIST=25;


class Boid{
    Body body;
    int id;
    color defColor = color(200, 200, 200);
    int nextPoint;
    SoundFile sample;
    
    Boid(Vec2 position){
      this.createBody(position);
      int nextPoint=path.closestTarget(position);
      this.nextPoint=nextPoint;
      
        int i= int(min(random(0, filenames.length), filenames.length-1));    
        this.sample=new SoundFile(app, "sounds/"+filenames[i]);
        
        colorMode(RGB, 255);
    }
    void createBody(Vec2 position){
        bd.position.set(position);
        this.body = box2d.createBody(bd);
        this.body.m_mass=1;
        this.body.createFixture(cs, 1);
        this.body.getFixtureList().setRestitution(0.8);
        this.body.setUserData(this);  // this is required to         
    }
    void steer(){  
      Vec2 posW= this.body.getPosition();
      int i=path.closestTarget(posW);
      Vec2 direction = path.getDirection(posW, i);
      this.nextPoint=i;
      
      Vec2 velocity = this.body.getLinearVelocity();
    
      Vec2 steering = direction.sub(velocity);  
      if(DRAW_DEBUG){ 
        strokeWeight(1);
        stroke(255);
        Vec2 posP= W2P(posW);
        line(posP.x, posP.y, path.pointsP[this.nextPoint].x, path.pointsP[this.nextPoint].y);        
      }
      
      this.applyForce(steering);
    }
    
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());      
    }
    void contact(){    
      this.play();
      /*
      Ex2: add some effect to react to collisions
      */
    }
    void draw(){
        Vec2 posPixel=box2d.getBodyPixelCoord(this.body);
       
        fill(this.defColor);
        stroke(0);
        strokeWeight(0);        
        ellipse(posPixel.x, posPixel.y, RADIUS_BOID, RADIUS_BOID);
    }
    Vec2 getPosition(){
      return this.body.getPosition();
    }
    
    Vec2 getLinearVelocity(){
      return this.body.getLinearVelocity();
    }
    

    void play(){
     if(! this.sample.isPlaying())      this.sample.play();    
    }
    void update(ArrayList<Boid> boids){
      /*
      Function to change foe ex 1. It is called for each boid
      */
      Vec2 myPosW = this.getPosition(); // Position in box2d coordinates
      Vec2 myVel=this.getLinearVelocity(); // Velocity in box2d coordinates

      // here the other boid's position and velocity will be stored
      Vec2 otherPosW; 
      Vec2 otherVel;
      
      // this vector will store the direction to other boid
      Vec2 direction;
      
      // where to store align and avoid force
      Vec2 align_force = new Vec2(0,0);
      Vec2 avoid_force = new Vec2(0,0);
      
      for(Boid other: boids){        
        if(this.body==other.body){continue;} // avoid self-computation
        
        otherPosW=other.getPosition();
        direction=otherPosW.sub(myPosW);
        
        if(direction.length()<AVOID_DIST){
           /*YOUR CODE HERE: compute contribution to avoid force */           
        }
        else if(direction.length()<ALIGN_DIST){
           /*YOUR CODE HERE: compute contribution to align force */                     
        }
      } // end of the loop
      if(DRAW_DEBUG){ 
        Vec2 myPosP= W2P(myPosW);
        Vec2 avoid_forceP=W2P(myPosW.add(avoid_force));
        Vec2 align_forceP=W2P(myPosW.add(align_force));
        Vec2 myVelP=W2P(myPosW.add(myVel));

        strokeWeight(1);
        stroke(255,0,0);
        line(myPosP.x, myPosP.y, avoid_forceP.x, avoid_forceP.y);
        fill(0,0);        
        ellipse(myPosP.x, myPosP.y,W2P(AVOID_DIST),W2P(AVOID_DIST));
        stroke(0,255,0);
        line(myPosP.x, myPosP.y, align_forceP.x, align_forceP.y);        
        fill(0,0);        
        ellipse(myPosP.x, myPosP.y,W2P(ALIGN_DIST),W2P(ALIGN_DIST));
        strokeWeight(5);
        stroke(255,255,0);
        line(myPosP.x, myPosP.y, myVelP.x, myVelP.y);        
        
       }
      
      if(avoid_force.length()>0){this.applyForce(avoid_force);}
      if(align_force.length()>0){this.applyForce(align_force);}
    }
    
    void kill(){
        box2d.destroyBody(this.body);
    }

   
}
