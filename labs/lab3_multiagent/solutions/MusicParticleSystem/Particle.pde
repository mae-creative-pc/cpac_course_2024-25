
class Particle{
  PVector pos, vel, acc;
  float radius, lifespan;
  float hue;
  Particle(PVector pos, float radius, float lifespan){
    this.pos= pos.copy();
    this.vel = new PVector();
    this.acc = new PVector();
    this.radius=radius;
    this.lifespan=lifespan;
    this.hue=random(0,255);
  }
  void update(){    
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void applyForce(PVector force){    
    this.acc.add(force);    
  }
  
  void draw(int hue){
    colorMode(HSB, 255);
    fill(hue, 255, 255, this.lifespan);
    noStroke();
    ellipse(this.pos.x, this.pos.y, this.radius, this.radius);    
  }
  boolean isDead(){
    return this.lifespan<=0;
  }
}
