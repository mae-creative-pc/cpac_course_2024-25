import processing.video.*;
import netP5.*;
import oscP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;


Movie video;
Capture cam;
color trackColor, avgColor;
float idxMaxColor, maxDist, closestX, closestY, relativeX, relativeY;
boolean usingWebcam;
PImage frame;

void setup() {
  // set this to true if you want to use the webcam insted of the video
  usingWebcam = false;
  colorMode(HSB, 360, 100, 100);

  //osc config
  oscP5 = new OscP5(this, 57121);

  // For myRemoteLocation put the IP address of the device you would like to communicate with
  // if you are local send it to 127.0.0.1 but if it's another PC put the IP address
  // of the other device (also set the correct port). If you want to send to two different locations
  // just make another variable and put another IP address, remember also to update the variable on the
  // sendOscMessage function. Another important thing, all devices must be connected to the same WiFi,
  // and don't use Politecnico's WiFi because there are some protection mechanisms that don't allow the communication,
  // so use your hotspot.
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
  size(800, 800);
  if (!usingWebcam) {
    // define here your video dimensions
    windowResize(1280, 720);
    // choose the video to play
    video = new Movie(this, "pen.mov");
    video.loop();
    smooth();
  } else {
    // Define here your webcam dimensions
    windowResize(640, 480);
    String[] cameras = Capture.list();

    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
    }
    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();
  }

  avgColor = color(0, 0, 0);
  idxMaxColor = 0;
  maxDist = 0;
  closestX = width / 2;
  closestY = height / 2;
  relativeX = 0;
  relativeY = 0;
  trackColor = color(0, 0, 0);
}

void movieEvent(Movie video) {
  video.read();
}

void draw() {
  background(avgColor);
  if (!usingWebcam) {
    frame = video;
    frame.loadPixels();
    image(video, 0, 0);
  } else {
    if (cam.available() == true) {
      cam.read();
    }
    frame = cam;
    image(frame, 0, 0);
  }

  avgColor = avgColorHSB(frame);
  println("Avg color\nHue: " + hue(avgColor) + ", sat: " + saturation(avgColor) + ", bright: " + brightness(avgColor));
  //println(prevDist);

  calculateTrackColor();
  println("Max color\nHue: " + hue(trackColor) + ", sat: " + saturation(trackColor) + ", bright: " + brightness(trackColor));

  //normalize x and y to 0-1 range
  relativeX = closestX/frame.width;
  relativeY = closestY/frame.height;

  // Send the osc message
  sendOscMessage();

  // We are checking the "distance" of the brightest color and the background is higher
  // than a certain value, you can change the value to change the sensitivity
  if (maxDist >= 95) {
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 100, 100);
  }
}

// You can use the X and Y coordinates of the tracked color in the frame to modulate whatever parameter you want
// and also use the traked color to change color to something, here we only send the hue of the color,
// but you could also send the brightness and saturation. You can run this and 'The Big O' program to actually see
// in action the tracking of the color by checking the change of the ellipse's axis.
void sendOscMessage() {
  OscMessage myMessage = new OscMessage("/x");
  myMessage.add(relativeX);
  oscP5.send(myMessage, myRemoteLocation);

  myMessage = new OscMessage("/y");
  myMessage.add(relativeY);
  oscP5.send(myMessage, myRemoteLocation);

  myMessage = new OscMessage("/color");
  myMessage.add(hue(trackColor));
  oscP5.send(myMessage, myRemoteLocation);
}

// this function will not track a specific color but it will track the most different color from the average color
// of the frame, however it must be suffitiently bright and saturated, better to try it with a white background and
// a bright highlighter
void calculateTrackColor() {
  // Resetting the parameter to calculate the maximum colo distance
  maxDist = 0;
  for (int x = 0; x < frame.width; x ++ ) {
    for (int y = 0; y < frame.height; y ++ ) {

      int loc = x + y * frame.width;

      color currentColor = frame.pixels[loc];
      float h1 = hue(currentColor);
      float s1 = saturation(currentColor);
      float b1 = brightness(currentColor);

      float h2 = hue(avgColor);
      float s2 = saturation(avgColor);
      //float b2 = brightness(avgColor);

      // to calculate the most different color from the average color we calculate the distance
      // but only relative to hue and saturation, not brightness
      float d = dist(h1, s1, h2, s2);

      // Also here you can tweak the values that check that the color we want to find is very bright and saturated
      // recall that the maximum value of brightness and saturation is 100.
      if (d > maxDist && b1 > 50 && s1 > 50) {
        maxDist = d;
        closestX = smooth_filter(closestX, (float)x);
        closestY = smooth_filter(closestY, (float)y);
        trackColor = currentColor;
      }
    }
  }
}

// the function will calculate the average color of the frame
color avgColorHSB(PImage media) {
  color hsb;
  float h = 0;
  float s = 0;
  float b = 0;
  for (int x = 0; x < media.width; x ++ ) {
    for (int y = 0; y < media.height; y ++ ) {
      int loc = x + y * media.width;

      color currentColor = media.pixels[loc];
      float h1 = hue(currentColor);
      float s1 = saturation(currentColor);
      float b1 = brightness(currentColor);

      h += h1;
      s += s1;
      b += b1;
    }
  }
  h /= media.width * media.height;
  s /= media.width * media.height;
  b /= media.width * media.height;
  hsb = color(h, s, b);
  return hsb;
}
// tweak the lambda_smooth to make the movement of the tracking smoother, the lower the value the smoother it will be
float smooth_filter(float old_value, float new_value) {
  float lambda_smooth = 0.06f;
  return lambda_smooth * new_value + (1 - lambda_smooth) * old_value;
}
