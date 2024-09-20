


void setup(){
  size(800,800);
}

void draw(){
  /*
  noFill();
  stroke(0, 0, 0);
  fill(255,0,0);
  ellipse(200,200,100,100);
  stroke(255, 102, 0);
  line(85, 20, 10, 10);
  line(90, 90, 15, 80);
   stroke(0, 0, 0);
   noFill();
  bezier(85, 20, 10, 10, 90, 90, 15, 80);
  */
  
  strokeWeight(3);
  fill(255,0,0);
  beginShape();
    vertex(100,100);
    vertex(200,300);
    vertex(240,20);
    vertex(300,50);
    vertex(100,100);
  endShape();
  
  strokeWeight(1);
  fill(0,0,255,100);
  beginShape();
    vertex(150,150);
    vertex(300,300);
    vertex(240,50);
    vertex(300,50);
    vertex(150,150);
  endShape();
  /*
  noFill();
  beginShape();
  for (int i=0; i<20; i++){
    int y = i%2;
    vertex(i*10, 50+y*10);
  }
  endShape();*/
}
