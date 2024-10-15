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
    this.particles.add(new Particle(this.origin, 10, random(0,255)));   
  }
  void draw(){
    Particle p;
    float small_force=0.05;
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      /* your code here*/
      p.draw();
      p.lifespan-=0.5;
      if(p.isDead()){
      }
    
    }
  }

}
