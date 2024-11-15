class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  
  ParticleSystem(){
    this.particles = new ArrayList<Particle>();
    this.origin=new PVector(width/2, height/2);
  }
  ParticleSystem(PVector origin){
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy();
  }
  void addParticle(){
    this.particles.add(new Particle(this.origin, 2, random(0,255)));   
  }
  
  void action(){
    Particle p;
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      p.applyForce(new PVector(random(-0.1, 0.1), 
                               random(-0.1,0.1)));
      p.action();
      p.lifespan-=0.5;
      if(p.isDead()){
         particles.remove(i);
         this.addParticle();
      }
    
    }
  }

}
