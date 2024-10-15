float alpha=0.1;
class AgentPendulum{
  PVector pivotPos, massPos;
  float angle, aVel, aAcc;
  float r, mass, radius;
  float vibrato=0; float cutoff=0;
  float initAngle, minVel, maxVel;
  AgentPendulum(float x, float y, float r, float mass){
    this.pivotPos = new PVector(x, y);
    this.angle=random( -PI/2, -PI/4);
    this.initAngle=angle;
    this.r=r;
    this.mass=mass;
    this.aVel=0;
    this.aAcc=0;
    this.massPos = new PVector(0, 0);
    this.radius=sqrt(this.mass/PI)*MASS_TO_PIXEL; 
    this.minVel = -1;
    this.maxVel = -1;
  }
  void update(){    
    this.aVel+=this.aAcc;
    this.angle+=this.aVel;
    this.aAcc=0;
    this.massPos.set(this.r*sin(this.angle), this.r*cos(this.angle));
    this.massPos.add(this.pivotPos);
  }
  void computeEffect(){
 
    this.vibrato = map((float)this.angle, -PI/2, PI/2, -0.5, 0.5);
    /*your code here*/
    if(this.minVel==-1){
      this.minVel = abs(this.aVel);
      this.maxVel = abs(this.aVel);
      this.cutoff = 0.5;
      return;
    }
    this.minVel = min(this.minVel,abs(this.aVel));
    this.maxVel = max(this.maxVel,abs(this.aVel));
    
    this.cutoff = map(abs(this.aVel),this.minVel,this.maxVel,0,1);
  }
  void applyForce(float force){    
    /* your code here */
    this.aAcc = this.aAcc + (force / this.mass);
  }
  void draw(){
    fill(200);

    /* your code below */
    // 1) draw pivot
    ellipse(this.pivotPos.x,this.pivotPos.y,10,10);
    
    // 2) draw arm
    stroke(255,10,100);
    strokeWeight(5);
    line(this.pivotPos.x,this.pivotPos.y,this.massPos.x,this.massPos.y);
    noStroke();
    
    // 3) draw mass
    ellipse(this.massPos.x,this.massPos.y,this.radius,this.radius);
    
  }
}
