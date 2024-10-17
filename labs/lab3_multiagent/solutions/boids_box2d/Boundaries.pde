class Boundaries{
    // these are the walls around the space
    float w;
    float h;
    int WEIGHT=5;
    Body[] bodies;
    Boundaries(float w, float h){
        this.w=w;
        this.h=h;
        BodyDef[] bds=new BodyDef[4]; //left, rigth, top, bottom
        PolygonShape[] pss=new PolygonShape[4];
        this.bodies= new Body[4];
        for(int i=0; i<4; i++){
          bds[i]=new BodyDef();
          pss[i]=new PolygonShape();
          bds[i].type= BodyType.STATIC;
          if(i<2){
            pss[i].setAsBox(P2W(this.WEIGHT),P2W(h));           
            bds[i].position.set(P2W(i*this.w, this.h/2));
          }
          else{
            pss[i].setAsBox(P2W(w),P2W(this.WEIGHT));   
            bds[i].position.set(P2W(this.w/2, this.h*(i-2)));
            
          }
          this.bodies[i] = box2d.createBody(bds[i]);
          this.bodies[i].createFixture(pss[i], 1);
          this.bodies[i].setUserData(null);

        }
    }
    void draw(){
      fill(255);
        stroke(0);
        rectMode(CENTER);        
      for (int i=0; i<4; i++){
        Vec2 pos=box2d.getBodyPixelCoord(this.bodies[i]); 
        if(i<2)        rect(pos.x, pos.y, this.WEIGHT, this.h);
        else           rect(pos.x, pos.y, this.w, this.WEIGHT);
        
      }    
    }
}
