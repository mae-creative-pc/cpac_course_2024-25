float alpha=0.1;  
float dist_min=50;
float dist_max=100;

class AgentMover{
  PVector position, velocity, acceleration;
  float mass, radius;
  float vibrato=0;
  float cutoff=0.5;
  AgentMover(float mass){
    this.position = new PVector(random(0, width), random(0, height));
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.acceleration = new PVector(random(2), random(2));
    this.mass=mass;
    this.radius=sqrt(this.mass/PI)*MASS_TO_PIXEL;    
  }
  void update(){    
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }
  void computeEffect(float dist){
    this.cutoff=map(dist,dist_min,dist_max,0,1);
  }
  void applyForce(PVector force){    
    PVector f = force.copy();
    f.div(this.mass);
    this.acceleration.add(f);
    
  }
  void draw(){
    fill(200);
    noStroke();
    ellipse(this.position.x, this.position.y, this.radius, this.radius);    
  }
}
