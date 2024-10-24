float SCALE_STEP = 25; 
    
class Walker {
  PVector position;
  PVector prevPosition;
  float freq, amp, cutoff, vibrato;
  float stepsize=0;
  Walker() {
    this.position=new PVector(width/2, height/2);
    this.prevPosition=this.position.copy();    
    this.amp=0; this.vibrato=0;
    this.freq=0;
    this.cutoff=0;
  }
  
  void draw() {        
    /* Ex 1: your code here to draw*/
    
    /* Ex 3: your code here to draw with colors*/
    ;
  }
  void computeEffect(){
    /* Ex 4: your code here*/
     ;      
  }
  
  void update() {    
    
    PVector step=new PVector(random(-1,1), random(-1,1));
    step.normalize();
    
    /* your code here, remember to:
    - update stepsize
    - update prevPosition
    - constrain position inside the screen
    */
      }
}

float montecarlo() {
  
  if(MONTECARLO_STEPS==2){
    ;/* Your code here: ex. 1*/
  }
  else if(MONTECARLO_STEPS==1){
    /* your code here: ex. 2  */
    ; 
  }
  return 0;
}
