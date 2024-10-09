
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
    imageMode(CENTER);
    tint(255, this.lifespan);
    image(img, this.location.x, this.location.y);
    
  }
  boolean isDead(){
    return this.lifespan<=0;
  }
}
