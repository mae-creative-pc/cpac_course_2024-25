// Evolution EcoSystem
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// A World of creatures that eat food
// The more they eat, the longer they survive
// The longer they survive, the more likely they are to reproduce
// The bigger they are, the easier it is to land on food
// The bigger they are, the slower they are to find food
// When the creatures die, food is left behind

 
//import oscP5.*;
//import netP5.*;

//OscP5 oscP5;

//int port = 57120;
//NetAddress location;


World world;

void setup() {
  size(700, 400);
  // World starts with 20 creatures
  // and 20 pieces of food
  //location = new NetAddress("127.0.0.1",port);
  //oscP5 = new OscP5(this,5500);
  world = new World(20);
  smooth();
}

void draw() {
  background(255);
  world.run();
}
