// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Evolution EcoSystem

// The World we live in
// Has bloops and food

class World {

  ArrayList<Bloop> bloops;    // An arraylist for all the creatures
  Food food; 

  // Constructor
  World(int num) {
    // Start with initial food and creatures
    food = new Food(num); 
    bloops = new ArrayList<Bloop>();              // Initialize the arraylist
    for (int i = 0; i < num; i++) {
      PVector l = new PVector(random(width),random(height));
      // FILL THE CODE --> instantiate DNA object
      bloops.add(new Bloop(l));
    }
  }

  // FILL THE CODE
  // Run the world
  void run() {
    // Deal with food
    //food.run();
    
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = bloops.size()-1; i >= 0; i--) {
      // All bloops run and eat
      Bloop b = bloops.get(i);
      b.run();
      
      /* UNCOMMENT FILL THE CODE */
      
      /*
       b.eat(food);
      // If it's dead, kill it and make food FILL THE CODE
      if (// FILL THE CODE: check bloop is dead) {
        // FILL THE CODE: remove bloop
        // FILL THE CODE: add food in the same position where the bloop died
      }
      */
    

      // Perhaps this bloop would like to make a baby?
      //Bloop child = // FILL THE CODE perform reproduction
      // FILL THE CODE --> if reproduction is successful add bloop to the ecosystem
      
    }
  }
   
}
