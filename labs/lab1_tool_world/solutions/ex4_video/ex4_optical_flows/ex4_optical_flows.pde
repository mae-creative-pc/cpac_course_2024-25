import gab.opencv.*; 
import processing.video.*;

Capture cam;
OpenCV opencv=null;

int index_cam=1;
void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    cam = new Capture(this, cameras[index_cam]);
    cam.start();
  }
}

void copy2img(Capture camera, PImage img) {
  img.loadPixels();
  for (int i=0; i<camera.width*camera.height; i++) {
    img.pixels[i]=camera.pixels[i];
  }
  img.updatePixels();
}


void opticalFlow(PImage img){
  opencv.loadImage(img);  // load the current image and compute Optical Flow
  opencv.calculateOpticalFlow();
  
  // we will divide the image in a grid of size:
  int grid_size=10; 
  int half_grid=5;  
  
  // center of each cell of the grid
  int c_x=0;   
  int c_y=0;   
  PVector aveFlow;  // here we will store the optical flow
  image(img,0,0);   // we plot the image
  stroke(255,0,0);
  
  for (int w=0; w<img.width; w+=grid_size){ 
    for (int h=0; h<img.height; h+=grid_size){
      // compute the average Flow over the region from w, h to w+grid_size, h+grid_size
       aveFlow = opencv.getAverageFlowInRegion(w, h, grid_size, grid_size);
       
       // update the center position
       c_x=w+half_grid; 
       c_y=h+half_grid;
       // draw a line from each center of the cell toward the direction of the average flow
       line(c_x, c_y, c_x+min(aveFlow.x*half_grid, half_grid), c_y+min(aveFlow.y*half_grid, half_grid));
    }
  }
}

void draw() {
  if (! cam.available()) {return;}
  cam.read();
  background(0);
  if(opencv ==null){// not initialized
    opencv = new OpenCV(this, cam.width, cam.height);
  }
  PImage img=createImage(cam.width,cam.height,RGB);
  copy2img(cam, img);
  opticalFlow(img);
    

}
