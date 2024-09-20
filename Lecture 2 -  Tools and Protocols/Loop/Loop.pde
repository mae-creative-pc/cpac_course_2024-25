

boolean blocked = false; 
float xc=0;
float yc=0;
float xr=0;
float yr=0;

void setup(){
  size(1500,1000);
  println(width);
  background(255,255,255);
  frameRate(60);
}


void draw(){  
  fill(random(0,255),random(0,255),random(0,255), random(0,255));
  stroke(255,0,0,255);
  strokeWeight(3);
  circle(mouseX,mouseY,2);
  //fill(0,255,0,100);
  //stroke(0,255,0,255);
  //rect(xr,yr,70,70);
  
  //xc=random(0,width/2-70);
  //xr=random(width/2, width);
  //yc=random(0,height);
  //yr=random(0,height);
  
}

/*
float randomVal()
{
  float val = random(0,width);
  return val;
}*/


void mousePressed(){
  
  if (blocked==true){
    blocked = false;
    loop();
  }
  else if (blocked==false){
    blocked = true;
    noLoop();
  }
}
