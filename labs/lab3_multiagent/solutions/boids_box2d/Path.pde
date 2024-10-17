class Path{
    Vec2[] pointsP, pointsW; // points with position in Pixel and World coordinates
    int num_points; // how many anchor points
    float alpha=0.4; //smoothing factor
    Vec2 center;  // center of the world
    Path(int num_points, float min_fact, float max_fact){
      this.num_points=num_points; 
      this.pointsW = new Vec2[this.num_points]; 
      this.pointsP = new Vec2[this.num_points];
      float angle;
      this.center = new Vec2(0, 0);
      float fact=0.5*(min_fact+max_fact);
      for(int i=0; i<this.num_points; i++){  // create num_points points at equal angle and slight difference from the centrum
        angle=map(i, 0, this.num_points, 0, 2*PI);
        fact=this.alpha*random(min_fact, max_fact)+(1-alpha)*fact;
        this.pointsP[i]=new Vec2(width*(0.5+fact*cos(angle)), height*(0.5-fact*sin(angle)));
        this.pointsW[i]=P2W(this.pointsP[i]);        
      } 
    }
    
    
    void draw(){ // draw all the path
      if (!DRAW_DEBUG) { return;}
      stroke(255);
      for(int i=1; i<this.num_points; i++){        
        line(this.pointsP[i-1].x, this.pointsP[i-1].y, this.pointsP[i].x, this.pointsP[i].y);
      }
      line(this.pointsP[this.num_points-1].x, this.pointsP[this.num_points-1].y, 
           this.pointsP[0].x, this.pointsP[0].y);
      for(int i=0; i<path.num_points; i++){
        this.draw(i);
      }
           
    }
    void draw(int i){  // draw each point
      fill(0,0);//128+(128.0 * i)/this.num_points);
      ellipse(this.pointsP[i].x, this.pointsP[i].y, W2P(DIST_TO_NEXT),W2P(DIST_TO_NEXT));
    }
   
    int closestTarget(Vec2 posW){ 
      //utility function: finds the anchor  point for a given position
      float angle;
      if (posW.x>0){ angle = (float) Math.atan(posW.y/posW.x);}
      else if (posW.x<0){ angle = PI+(float) Math.atan(posW.y/posW.x);}
      else if (posW.y>0){angle=PI/2;}
      else {angle = -PI/2;}
      angle=(2*PI+angle)%(2*PI);
      
      float angle_fraction=2*PI/this.num_points;
      
      return nextPoint(floor(angle/angle_fraction));  
      
    }
    int nextPoint(int i){
      return (i+1)%this.num_points;
    }
    Vec2 getPoint(int i){
      return this.pointsW[i];
    }
    Vec2 getDirection(Vec2 posW, int i){
       return this.pointsW[i].sub(posW);               
    }
}

Path createPath(){
     return new Path(12, 0.35, 0.36);
}
