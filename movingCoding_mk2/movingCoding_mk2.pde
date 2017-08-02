/*
Moving & Coding - a workshop about using your body as a
controller, using Kinects and Processing.
This is base code to give a starting point for the workshop.

Input data from the kinect is shown on the left of the canvas,
output visuals are shown on the right.
Key commands: 
'i' - toggle input canvas visibility
'o' - toggle output canvas visibility
's' - toggle skeleton visibility (when input is visible)

The kinect camera view is masked in horizontal
and depth dimensions to create a 'play area',
and adjusted using the sliders:
xWindow - adjusts the horizontal masking of the kinect camera
zMin - adjusts the near-camera depth limit
zMax - adjusts the far-from-camera depth limit

Two examples are provided for the output canvas:
painter() - draws a dot positioned relative to
the target user's x and z positions.
sounder() - makes a tone with pitch and volume
relative to the target user's x and z positions.
You need to choose which of these you want to use
and call them from the place shown in the draw() loop.

Useful variables for using in output coding:
userCount (no. people on camera),
playerCount (no. people in play area),
targetUser (closest player),
x, y, z, (targetUser's position)

Written for Windows, Kinect SDK 1.8, Kinect Sensor v1
and the SimpleOpenNI, minim and controlP5 libraries.
Based on code written by Roy Shearer for
Be The Goalie - www.cargocollective.com/bethegoalie
as well as example code by Andreas Schlegel and Max Rheiner.
*/

// default start values for kinect masking:
int zMax = 1000; //2000
int zMin = 500;  //200
int xMin = 220;  //120
int xMax = 390;  //520

// useful variables for creating output beahviour from, and starting values:
int x=0;
int y=0;
int z=255;  // 255 stops sounder from initially sounding
int userCount=0;
int playerCount=0;
int targetUser=0;

int kickThreshold=220;
int zMaxCP5 = zMax; 
int zMinCP5 = zMin;  
boolean kick=false;
boolean kinect=false;  // kinect detection flag
boolean skeleton=false;  // show skeleton flag
boolean output=true;  // show output flag
boolean input=true;  // show input info flag

void setup()
{
  size(displayWidth, displayHeight); // 1920,1080
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

// CHOOSE EITHER sounder or painter lines below:

    painter(w, h);  // execute output routine
//    sounder(w, h);  // execute output routine
    
    translate(-790, 0);  // move origin back
  }
}

void keyPressed() {
  if (key=='s'||key=='S') {
    skeleton=!skeleton; // toggle skeleton flag
    println("SKELETON TOGGLE");
  }
  if (key=='o'||key=='O') {
    if (output) {  // if already in output mode
      background(0);  // clear canvas
      wave.setAmplitude( 0 );  // mute audio
    }
    output=!output; // toggle output flag
    println("OUTPUT TOGGLE");
  }
  if (key=='i'||key=='I') {
    if (input) {   // if already in input mode
      cp5.hide();  // hide the controls
    } else {   // otherwise
      cp5.show();  // show the controls
    }
    input=!input;  // toggle input flag
    println("INPUT TOGGLE");
  }
}

