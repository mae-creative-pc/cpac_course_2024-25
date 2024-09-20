
PImage img;


void setup(){
  size(500,418); 
  img = loadImage("lamp.jpg");
}



void draw(){
    background(0);
    //tint(255,mouseX,mouseY);
    image(img,0,0,width,height);    
 
    /*
    // This works on the original image but do not affects the original image since it is relates to what is displaied rather than the image object 
    for (int y=0;y<height/2;y++){
      for (int x=0;x<width;x++){
        color c = get(x, y); 
        set(x,y,c+100);
      }
    }*/
    
    //Loads the pixel data of the current display window into the pixels[] array
    //From Matrix to 1D-array
    // This works on the displayed screeen
    
    
    img.loadPixels();       //Loads the pixel data of the current display window into the img.pixels[]
    //The way to access to pixels[] is pixels[y*width+x];
    for (int i = 0; i < ((height/2)*width); i++) {
    //for (int i = 0; i < (height*width); i++) {
      color c = img.pixels[i];
      img.pixels[i] = c+100; 
    }
    img.updatePixels();
}
