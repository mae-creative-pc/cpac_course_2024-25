import processing.video.*;

Capture cam;
PImage old_frame;
PImage cur_frame;
boolean first_frame=true;
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
      println(i, cameras[i]);
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

void copy_img(PImage src, PImage dst) {
  dst.set(0,0,src);
}
void effectDiffFrames(PImage img){
  // your code here
  copy2img(cam, img);
  if(first_frame){
    copy2img(cam, old_frame);
    first_frame=false;
    return;    
  }
  img.loadPixels();
  copy2img(cam, cur_frame);
  colorMode(HSB, 255);
  float normdiff=0;
  for(int loc=0; loc<cam.width*cam.height; loc++){
     normdiff=map(abs(cur_frame.pixels[loc]-old_frame.pixels[loc]), 0, 255*255*255, 0, 1);
    img.pixels[loc]= color(
            hue(img.pixels[loc]),
            saturation(img.pixels[loc]),
            brightness(img.pixels[loc])*normdiff);
      
      
  }
  img.updatePixels();
  copy2img(cam, old_frame);
  
  return;
}
void draw() {
  if (! cam.available()) {return;}
  cam.read();
  if(first_frame){
    cur_frame=createImage(cam.width,cam.height,RGB);
    old_frame=createImage(cam.width,cam.height,RGB);  
  }
  PImage img=createImage(cam.width,cam.height,RGB);
  
  effectDiffFrames(img);
  
  if(img.width>0){
    image(img, 0, 0);
  }

}
