/* Goal: to create a soundscape made of movers orbitating around an attractor
Each mover represents an audio track that is played in loop
The closer the mover to the attractor, the louder the corresponding track

Tasks :
1. Modify the script attractor.pde (second lab) to support multiple mover Agents
2. connect each Agent with an audio player and play it on loop
3. map the Agent’s distance from the attractor to the sound amplitude

 */

import processing.sound.*;
import java.util.Date;

int N_AGENTS=7;
AgentMover[] movers;
SoundFile[] samples;
float MASS_TO_PIXEL=0.1;
float mass_attractor;
float radius_attractor=100;
PVector pos_attractor;

float Amin=0.02;
float alpha_amp=0.01;

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
  String[] filenames= getFilenames();
  N_AGENTS=filenames.length;
  
  movers=new AgentMover[N_AGENTS];
  samples=new SoundFile[N_AGENTS];
  
  for(int i=0; i<N_AGENTS; i++){
     movers[i]=new AgentMover(random(100000,200000));
     samples[i] = new SoundFile(this, filenames[i]);
     println(filenames[i]);
     samples[i].amp(0);
     samples[i].loop();
  }
  mass_attractor=random(100, 200);
  pos_attractor = new PVector(0.5*width, 0.5*height);  
  //radius_attractor = sqrt(mass_attractor/PI)*MASS_TO_PIXEL;
  
  size(1280, 720);
  background(0);
  
}

PVector computeGravityForce(AgentMover mover){
  PVector attr_force=pos_attractor.copy();
  attr_force.sub(mover.position);
  float dist=attr_force.mag();
  dist=constrain(dist, dist_min, dist_max);
  attr_force.normalize(); 
  attr_force.mult(mover.mass*mass_attractor/(dist*dist));
  return attr_force;
}


int changeAmp(int i){
  PVector dist_vect=pos_attractor.copy();
  dist_vect.sub(movers[i].position);

  float dist_i=dist_vect.mag();
  
  float amp=max(1/(1+alpha_amp * dist_i), Amin);
  samples[i].amp(amp);
  
  return int(amp*255);
  
}
void draw(){
  rectMode(CORNER);
  fill(0,20);
  rect(0,0,width, height);
  fill(200, 0, 200, 40);
  ellipse(pos_attractor.x, pos_attractor.y, 
          radius_attractor, radius_attractor);
  
  PVector force_a;
  println(N_AGENTS);
  for(int i=0; i<N_AGENTS; i++){
    println(i);
    force_a = computeGravityForce(movers[i]);
    movers[i].applyForce(force_a);
    int c=changeAmp(i);
    movers[i].update();
    movers[i].draw(c); 
  }
}
