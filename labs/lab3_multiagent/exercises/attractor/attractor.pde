/* Goal: to create a soundscape made of movers orbitating around an attractor
Each mover represents an audio track that is played in loop
The closer the mover to the attractor, the louder the corresponding track

Tasks :
1. Modify the script attractor.pde (first lab) to support multiple mover Agents
2. connect each Agent with an audio player and play it on loop
3. map the Agent’s distance from the attractor to the sound amplitude

 */



/* YOUR CODE HERE: import required libraries for sound (step2) */


AgentMover mover;
/* YOUR CODE HERE: place many movers instead of one (step 1) */

int MASS_TO_PIXEL=10;
float mass_mover = 10;
float mass_attractor;
PVector pos_attractor;
float radius_attractor;
float area;
float dist=0;


// Function that get wav files from folder "sounds" 
String[] getFilenames(){
  String path=sketchPath()+"/sounds";
  File dir = new File(path);
  String all_filenames[] = dir.list();
  int N_wavs=0;
  for(int i=0; i<all_filenames.length; i++){
    if (all_filenames[i].endsWith(".wav")){ N_wavs++;}
  }
  
  if(N_wavs==0){
    println("No wav files found in the sound Folder!");
  }
  String[] wav_filenames= new String[N_wavs];
  int j=0;
  for(int i=0; i<all_filenames.length; i++){
    if (all_filenames[i].endsWith(".wav")){ 
       wav_filenames[j]=sketchPath()+"/sounds/" + all_filenames[i];
       j++;}
  }
  return wav_filenames; 
}


void setup(){
  /* YOUR CODE HERE: initialize many movers instead of just one (step 1) */

  
  mover=new AgentMover(10);
  mass_attractor=random(800, 1200);
  pos_attractor = new PVector(width/2., height/2.);  
  radius_attractor = sqrt(mass_attractor/PI)*MASS_TO_PIXEL;
  
  size(1280, 720);
  background(0);  
}

PVector computeGravityForce(AgentMover mover){
  PVector attr_force = mover.position.copy();

  attr_force.sub(pos_attractor);
  dist= attr_force.mag();
  dist=constrain(dist, dist_min,dist_max);
  attr_force.normalize();
  attr_force.mult(-1*mass_attractor*mover.mass/(dist*dist));
  return attr_force;
}

    
void draw(){
  rectMode(CORNER);
  fill(0,20);
  rect(0,0,width, height);
  fill(200, 0, 200, 40);
  /* YOUR CODE HERE: modify thsi function to draw multiple movers (step 1) */
 
  ellipse(pos_attractor.x, pos_attractor.y, 
          radius_attractor, radius_attractor);
  /* YOUR CODE HERE: map the Agent's distance from the attractor to Sound's amplitude (step 3) */

  PVector force = computeGravityForce(mover);
  mover.applyForce(force);
  mover.update();
  mover.draw();
}
