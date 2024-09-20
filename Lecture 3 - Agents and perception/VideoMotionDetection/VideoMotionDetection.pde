
import processing.video.*;

Movie mov;
// Previous Frame
PImage prevFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 50;
boolean firstFrame = true;

void setup() {
  size(1000, 564);
  noStroke();
  mov = new Movie(this, "video_N.mp4");
  mov.loop();
  // Empty image the same size as the video
  prevFrame = createImage(width, height, RGB);
}

// For each new frame 
void movieEvent(Movie video) {
  if (firstFrame){
    video.read();
    prevFrame.copy(video, 0, 0, width, height, 0, 0, width, height); 
    prevFrame.updatePixels();
  }
  else{
  
    // Save previous frame for motion detection
    prevFrame.copy(video, 0, 0, width, height, 0, 0, width, height); 
    prevFrame.updatePixels();
    video.read();
  }
}

void draw() {
    loadPixels();
    mov.loadPixels();
    prevFrame.loadPixels();
  
    for (int x = 0; x < mov.width; x ++ ) {
      for (int y = 0; y < mov.height; y ++ ) {
  
        int loc = x + y*mov.width;            // Step 1, what is the 1D pixel location
        color current = mov.pixels[loc];      // Step 2, what is the current color
        color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color
  
        // Step 4, compare colors (previous vs. current)
        float r1 = red(current); 
        float g1 = green(current); 
        float b1 = blue(current);
        float r2 = red(previous); 
        float g2 = green(previous); 
        float b2 = blue(previous);
        float diff = dist(r1, g1, b1, r2, g2, b2);
  
        // Step 5, How different are the colors?
        // If the color at that pixel has changed, then there is motion at that pixel.
        if (diff > threshold) { 
          // If motion, display black
          pixels[loc] = color(0);
        } else {
          // If not, display white
          pixels[loc] = color(255);
        }
      }
    }
    updatePixels();
}
