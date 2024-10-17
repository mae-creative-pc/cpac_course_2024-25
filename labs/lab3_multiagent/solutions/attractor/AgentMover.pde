
float alpha=0.1;  
float dist_min=1;
float dist_max=30;
float velocity_max=9;
  
class AgentMover{
  PVector position, velocity, acceleration;
  float mass, radius;
  float vibrato=0;
  float cutoff=0.5;
  AgentMover(float mass){
    float margin=0.3;
    this.position = new PVector(random(0, width), random(0, height));
    while(this.position.x>margin*width && this.position.x<(1-margin)*width){
      this.position.x=random(0, width);      
    }
    while(this.position.y>margin*height && this.position.y<(1-margin)*height){
      this.position.y=random(0, height);
    }
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.acceleration = new PVector(random(2), random(2));
    this.mass=mass;
    this.radius=sqrt(this.mass/PI)*MASS_TO_PIXEL;    
  }
  void update(){    
    this.velocity.add(this.acceleration);
    this.velocity.limit(velocity_max);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }
  void computeEffect(float dist){
    float vibrato= constrain(this.position.x/width -0.5, -0.5, 0.5);
    this.vibrato=alpha* vibrato + (1-alpha)*this.vibrato;
    float cutoff=map(dist, dist_min, dist_max, 0, 1.);
    this.cutoff= alpha* cutoff +(1-alpha)*this.cutoff;
  }
  void applyForce(PVector force){    
    PVector f = force.copy();
    f.div(this.mass);
    this.acceleration.add(f);
    
  }
  void draw(color c){
    fill(c);
    noStroke();
    ellipse(this.position.x, this.position.y, this.radius, this.radius);    
  }
}
