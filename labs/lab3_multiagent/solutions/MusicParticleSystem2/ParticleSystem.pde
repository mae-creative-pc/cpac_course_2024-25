class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  float gain =1;
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
  void setForceGain(float gain){
    this.gain=gain;
  
  }
  void draw(){
    Particle p;
    float small_force=0.05;
    PVector random_force=new PVector(0,0);
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      random_force.x=this.gain*random(-small_force, small_force);
      random_force.y=this.gain*random(-small_force, small_force);
      p.applyForce(random_force);
      p.update();
      p.draw();
      p.lifespan-=0.5;
      if(p.isDead()){
         particles.remove(i);
         this.addParticle();
      }
    
    }
  }

}
