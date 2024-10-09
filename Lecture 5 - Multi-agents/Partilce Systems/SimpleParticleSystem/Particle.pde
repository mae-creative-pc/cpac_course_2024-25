
class Particle{
  PVector location, velocity, acceleration;
  float radius_circle, lifespan, mass;
  
  Particle(PVector location, float radius_circle, float lifespan){
    this.location= location.copy();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.radius_circle=radius_circle;
    this.lifespan=lifespan;
    this.mass = 1;
  }
  
  void update(){    
    this.velocity.add(this.acceleration);
    this.location.add(this.velocity);
    this.acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);  // Force/Mass
    acceleration.add(f);
  }
  
  void run(){
    this.update();    
    fill(200, this.lifespan);
    noStroke();
    ellipse(this.location.x, this.location.y, this.radius_circle, this.radius_circle);    
  }
  
  boolean isDead(){
    return this.lifespan<=0;
  }
}
