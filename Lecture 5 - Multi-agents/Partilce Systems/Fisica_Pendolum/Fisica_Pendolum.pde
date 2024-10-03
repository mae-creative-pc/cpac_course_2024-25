/**
 *  Anchors and the bridge
 *
 *  by Ricard Marxer
 *
 *  This example shows the use of anchors and distance joints in order
 *  to create a bridge.
 */

import fisica.*;

float frequency = 7;
float damping = 0.1;
float puenteY;

FBody[] steps = new FBody[20];
FWorld world;

int ballWidth = 3;

void setup() {
  size(400, 400);
  smooth();

  puenteY = height/3;

  Fisica.init(this);

  world = new FWorld();

  FCircle bola = new FCircle(40);
  bola.setPosition(width/2, 0);
  bola.setDensity(0.1);
  bola.setFill(120, 120, 190);
  bola.setNoStroke();
  world.add(bola);

  for (int i=0; i<steps.length; i++) {
    steps[i] = new FCircle(ballWidth);
    steps[i].setPosition(map(i, 0, steps.length-1, 0, width), puenteY);
    steps[i].setStroke(120, 200, 190);
    world.add(steps[i]);
  }
  
  
  for (int i=1; i<steps.length; i++) {
    FDistanceJoint junta = new FDistanceJoint(steps[i-1], steps[i]);
    junta.setFrequency(frequency);
    junta.setDamping(damping);
    junta.setFill(0);
    junta.calculateLength();
    world.add(junta);
  }
  
  
  FCircle left = new FCircle(10);
  left.setStatic(true);
  left.setPosition(0, puenteY);
  left.setDrawable(false);
  world.add(left);

  FCircle right = new FCircle(10);
  right.setStatic(true);
  right.setPosition(width, puenteY);
  right.setDrawable(false);
  world.add(right);

  FDistanceJoint juntaPrincipio = new FDistanceJoint(steps[0], left);
  juntaPrincipio.setFrequency(frequency);
  juntaPrincipio.setDamping(damping);
  juntaPrincipio.calculateLength();
  juntaPrincipio.setFill(0);
  world.add(juntaPrincipio);

  FDistanceJoint juntaFinal = new FDistanceJoint(steps[steps.length-1], right);
  juntaFinal.setFrequency(frequency);
  juntaFinal.setDamping(damping);
  juntaFinal.calculateLength();
  juntaFinal.setFill(0);
  world.add(juntaFinal);
}

void draw() {
  background(255);

  world.step();
  world.draw();
}


void mousePressed() {
  float radius = random(10, 40);
  FCircle bola = new FCircle(radius);
  bola.setPosition(mouseX, mouseY);
  bola.setDensity(0.2);
  bola.setFill(120, 120, 190);
  bola.setNoStroke();
  world.add(bola);  
}
