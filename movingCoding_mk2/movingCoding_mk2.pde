int zMax = 1000; //2000
int zMin = 500;  //200
int xMin = 220;  //120
int xMax = 390;  //520

int x=0;
int y=0;
int z=255;
int userCount=0;
int playerCount=0;
int targetUser=0;

int kickThreshold=220;
int zMaxCP5 = zMax; 
int zMinCP5 = zMin;  
boolean kick=false;
boolean kinect=false;
boolean skeleton=false;  // show skeleton flag
boolean output=true;  // show output flag
boolean input=true;  // show input info flag

void setup()
{
  size(displayWidth, displayHeight); //1920,1080
  controlP5Setup();
  kinectSetup();
  soundSetup();
}

void draw()
{
  fill(0);
  stroke(0);
  rect(0, 0, 790, height);
  if (kinect) {
    kinectData(); // get the data from the kinect and manipulate it
  }
  if (input) {
    drawKinectView(); // draw results to screen
  }
  filterUsers(); // filter out users out of window and pick target user
  targetUser(); // get the data from the target user and send to serial
  if (input) {
    drawStatus2(); // draw results to screen
  }
  if (output) {
    translate(790, 0); // move origin to right of kinect view canvas
    int w=displayWidth-790; // output canvas width
    int h=displayHeight; // output canvas height
    
    //    painter(w, h);  // execute output routine
    sounder(w, h);  // execute output routine
    
    translate(-790, 0);  // move origin back
  }
}

void keyPressed() {
  if (key=='s') {
    skeleton=!skeleton; // toggle skeleton flag
    println("SKELETON TOGGLE");
  }
  if (key=='o') {
    if (output) {  // if already in output mode
      background(0);  // clear canvas
      wave.setAmplitude( 0 );  // mute audio
    }
    output=!output; // toggle output flag
    println("OUTPUT TOGGLE");
  }
  if (key=='i') {
    if (input) {   // if already in input mode
      cp5.hide();  // hide the controls
    } else {   // otherwise
      cp5.show();  // show the controls
    }
    input=!input;  // toggle input flag
    println("INPUT TOGGLE");
  }
}

