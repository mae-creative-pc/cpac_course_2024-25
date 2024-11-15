
class Particle{
  PVector location, velocity, acceleration;
  float radius_circle, lifespan;
  Particle(PVector location, float radius_circle, float lifespan){
    this.location= location.copy();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.radius_circle=radius_circle;
    this.lifespan=lifespan;
  }
  void planning(){    
    this.velocity.add(this.acceleration);
    this.location.add(this.velocity);
    this.acceleration.mult(0);
  }
  
  void applyForce(PVector force){    
    this.acceleration.add(force);
    
  }
  void action(){
    this.planning();    
    fill(200, this.lifespan);
    noStroke();
    ellipse(this.location.x, this.location.y, this.radius_circle, this.radius_circle);    
  }
  boolean isDead(){
    return this.lifespan<=0;
  }
}
