

class Walker {
  float x, y;
  float prevX, prevY;

  Walker() {
    x = width/2;
    y = height/2;
  }

  void render() {
    color c = color(255*(x/width),255*(y/height),100);
    stroke(c);
    strokeWeight(3);
    line(prevX,prevY,x, y);
  }

  // Randomly move according to floating point values
  void step() {
    prevX = x;
    prevY = y;
    
    float stepx = random(-1, 1);
    float stepy = random(-1, 1);
    
    float stepsize = montecarlo()*100;
    stepx *= stepsize;
    stepy *= stepsize;
    
    x += stepx;
    y += stepy;
    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
  }
}


float montecarlo() {
  while (true) {	

    float r1 = random(1);	
    float probability = pow(1.0-r1, 8);	

    float r2 = random(1);	
    if (r2 < probability) {	
      return r1;
    }
  }
}
