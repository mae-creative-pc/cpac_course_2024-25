
/* PARAMETERS */
String API_URL="https://cpac.pythonanywhere.com";
// time constants in seconds
float TIME_FADEIN=5; // time after which a new text is shown
float TIME_FADEOUT=5; // time after which a new text is shown
float TIME_FIXED=10; // time after which a new text is shown
float TIME_RELOAD=3; // period to try to reaload
boolean VERBOSE=true;
float TEXTSIZE=200;

/* GLOBAL VARIABLES */ 
API_Client client;
float text_eta=0;
float reload_eta=0;
float time_index=0;
String[] msgs;

int msgN=0;
int msgI=0;
float msgAlpha=0;
int msgStatus=0;
void setup(){
  size(1280, 720);
  background(0);
  println(frameRate);
  client=new API_Client(API_URL);
  msgs= client.get_msgs();
  msgN= msgs.length;
  msgI=msgN-1;
  msgStatus=-1;  
  if(VERBOSE){
    println("Found ", msgN, "new messages");
  }
  TIME_FADEIN*=frameRate; // time after which a new text is shown
  TIME_FADEOUT*=frameRate; // time after which a new text is shown
  TIME_FIXED*=frameRate; // time after which a new text is shown
  TIME_RELOAD*=frameRate; // period to try to reaload
  if(msgN==0){reload_eta=TIME_RELOAD;}
  else{reload_eta=0;}
}


void draw(){
      
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);

  if(msgI>=0){    // drawMessage
    String msg=msgs[msgI];
    time_index++;
    if(msgStatus==-1){
      msgStatus=0;
      time_index=0;
      if(VERBOSE){
        println("Starting to show message ", msg);
      }
    }
    if(msgStatus==0){
      msgAlpha=map(time_index, 0, TIME_FADEIN, 0, 255);      
      if(time_index==TIME_FADEIN){
        msgStatus=1;
        time_index=0;
        if(VERBOSE){
          println("Fadein over for message ", msg);
        }
      }
    }    
    else if(msgStatus==1){
      msgAlpha=255;      
      if(time_index==TIME_FIXED){
        msgStatus=2;
        time_index=0;
        if(VERBOSE){
          println("Beginning Fadeout for message ", msg);
        }
      }
    }
    else if(msgStatus==2){
      msgAlpha=map(time_index, 0, TIME_FADEOUT, 255, 0);      
      if(time_index==TIME_FADEOUT){
        msgStatus=0;
        time_index=0;
        msgI--;
        if(VERBOSE){
           println("A new message is on its way...");
        }
      }
    }      
    rectMode(CENTER);
    fill(255, msgAlpha);
    textSize(TEXTSIZE);
    textAlign(CENTER);
    text(msg, width/2, height/2);
  }
  else{    // reload and get new messages
    reload_eta--;
    if(reload_eta<=0){
      msgs= client.get_msgs();
      msgN= msgs.length;
      msgI=msgN-1;
      if(msgN==0){
        reload_eta=TIME_RELOAD;}
      else{reload_eta=0;}
      if(VERBOSE){
        println("Found ", msgN, "new messages");
      }
    }
  }
}
