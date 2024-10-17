float clip(float val, float min_val, float max_val){
  return max(min(val, max_val), min_val);

}

class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  float forceScale=1;
  int particleHue=255;
  ParticleSystem(){
    this.particles = new ArrayList<Particle>();
    this.origin=new PVector(width/2, height/2);
  }
  ParticleSystem(PVector origin){
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy();
  }
  void addParticle(){
    this.particles.add(new Particle(this.origin, 10, random(0,255)));   
  }
  void followMusic(AgentFeature features){
    forceScale = features.energy/1000;
    
    particleHue = (int)clip(features.centroid/100, 0., 255.);
    println(features.centroid/100, particleHue);
    // your code here: make the particle movement, or color, or size, follow music's features
    // hint: start mapping  features.energy/1000  on small_force
  }
  void draw(){
    Particle p;
    float small_force=0.05;
    PVector random_force=new PVector(0,0);
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      random_force.x=this.forceScale*random(-small_force, small_force);
      random_force.y=this.forceScale*random(-small_force, small_force);
      p.applyForce(random_force);
      p.update();
      p.draw(particleHue);
      p.lifespan-=0.5;
      if(p.isDead()){
         particles.remove(i);
         this.addParticle();
      }
    
    }
  }

}
