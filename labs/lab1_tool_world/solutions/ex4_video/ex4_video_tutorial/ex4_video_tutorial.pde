import processing.video.*;

/* Global variable */
Capture cam;
int index_cam=1;
boolean camera_found=false;

boolean find_camera(){
  /*
  Find a camera, 
    return true if it is found (cam is initialized), 
    return false otherwise
  */
  
  // if camera was already found, it returns true
  if(camera_found){return camera_found;}
  
  // else tries to get the list of cameras
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) { // no camera available THIS TIME
    println("There are no cameras available for capture.");
    //exit();
  } else {   // camera availables, print the list and initialize cam
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i, cameras[i]);
    }
    cam = new Capture(this, cameras[index_cam]);
    cam.start();    
    camera_found=true;
  }
  return camera_found;
}

void setup() {
  size(640, 480);
  /*Let's try to check cameras in the setup */
  find_camera();
}

void draw() {  
  /* We check cameras at every frame: if it is not present, we skip the frame*/
  if (! find_camera()){return;}
    
  if (! cam.available()) {return;}
  cam.read();
  if(cam.width>0){
    image(cam, 0, 0);
  }  

}
