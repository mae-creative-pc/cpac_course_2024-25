int MARGIN;

class AgentDrawer{
  AgentFeature feat;
  int numFeatures;
  float heightFeatures;
  float maxWidth;
  int textSpace;
  boolean first_frame=true;
  int wait_frames=10;
  int marginLeft;
  float maxFeatures[];
  float minFeatures[];
  String[] labels={"ENERGY","CENTR", "SPREAD", "SKEW", "ENTR", "FLAT"};
  color[] colors={color(255,255,0), color(255,0,255), color(0,255,255),
                  color(255,0,0), color(0,255,0), color(255,128,0)};
  AgentDrawer(AgentFeature feat, int numFeatures){
    this.feat=feat;
    MARGIN=int(0.05*height);
    
    this.numFeatures=numFeatures;
    this.heightFeatures= 1.0*(height-2*MARGIN)-((this.numFeatures-1)*MARGIN);
    this.heightFeatures/=numFeatures;
    this.textSpace= int(this.heightFeatures*4);
    this.marginLeft= MARGIN+this.textSpace;
    this.maxWidth= width-MARGIN-this.marginLeft;
    this.maxFeatures = new float[numFeatures];
    this.minFeatures = new float[numFeatures];
    for(int i=0; i<this.numFeatures; i++){
      /*
      Since we don't know the value of the features in advance, 
      we will keep estimating the minimum and maximum values for 
      each of them
      */
      this.maxFeatures[i]=0; 
      this.minFeatures[i]=0;
    }
  }
  void action(){
    float[] values=new float[this.numFeatures];
    values[0]=this.feat.energy;
    values[1]=this.feat.centroid;
    values[2]=this.feat.spread;
    values[3]=this.feat.skewness;
    values[4]=this.feat.entropy;
    values[5]=this.feat.flatness;
    int aboveSpace=MARGIN;    
    float x=0;
    textSize((int)this.heightFeatures);
    for (int i=0; i<this.numFeatures; i++){
        aboveSpace=MARGIN+i*((int)this.heightFeatures+MARGIN);    
        fill(this.colors[i]);
        text(this.labels[i], MARGIN, aboveSpace+this.heightFeatures);
        if(this.first_frame){
          /*
          If this is the first frame, we don't estimate min and max but
          just copy the value (we cannot compare them)
          */
          this.maxFeatures[i]=values[i];
          this.minFeatures[i]=values[i];
        }
        else{
          if (values[i]>this.maxFeatures[i]){
               this.maxFeatures[i]=values[i];}
          if (values[i]<this.minFeatures[i]){
              this.minFeatures[i]=values[i];}
        }
        if(this.wait_frames<=0){            
          /*
          We wait for some frames before actually starting drawing, so
          we have a better estimate of the range.
          We start initializing wait_frames at 10, then each frame we 
          decrease this number until we have 0, then we start drawing.
          The map function is:
          value_out=map(value_in, range_in_min, range_in_max, range_out_min, range_out_max)
          and it maps a value in an input range to a value in an output range.
          E.g., map(0.3, 0, 1, 0, 100)=>30
          */
            x=map(values[i], this.minFeatures[i], this.maxFeatures[i], 0, this.maxWidth);
        }     
        /* this actually draws the value */
        rect(this.marginLeft, aboveSpace,  x, this.heightFeatures); 
        
    }
    if(this.wait_frames>0){
      this.wait_frames--;
    }
    if(this.first_frame){
      this.first_frame=false;
    }
  }

}  
