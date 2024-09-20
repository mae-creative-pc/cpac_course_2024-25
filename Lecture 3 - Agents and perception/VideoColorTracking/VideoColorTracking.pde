import processing.video.*;


Movie video;
color trackColor; 

void setup() {
  size(1280, 720);
  video = new Movie(this, "pen.mov");
  video.loop();
  trackColor = color(0, 0, 250);
}

void movieEvent(Movie video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  float worldRecord = 500; 
  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); 

      if (d < worldRecord) {

        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }

  if (worldRecord < 200) { 

    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 100, 100);
  }
}
