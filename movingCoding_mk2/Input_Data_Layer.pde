
import SimpleOpenNI.*;
SimpleOpenNI  context;
PImage depthImage;
PImage rgbImage;
int [] userList;
int [] blackList;
color[]       userClr = new color[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};
PVector com = new PVector();                                   
PVector com2d = new PVector();      

void kinectSetup() {
  println("Initializing Kinect library...");
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't initialise SimpleOpenNI, maybe the kinect is not connected. \nContinuing without kinect. \n-----------"); 
    //    exit();
    return;
  } else {
    kinect=true;
    println("Kinect found. \n-----------"); 
    // enable depthMap generation 
    context.enableDepth();
    // enable skeleton generation for all joints
    context.enableUser();
    context.enableRGB();
  }
}

void kinectData() {
  context.update();
  rgbImage = context.rgbImage();  // get depth image in grey values, with coloured users
  //  int[] rgbValues = rgbImage.loadPixels();
  int[] depthValues = context.depthMap();  //get depths as integers
  depthImage = context.userImage();  // get depth image in grey values, with coloured users
  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {
      int i = x + y * 640;  // calculate index for current pixel
      int currentDepthValue = depthValues[i]; // get depth for current pixel
      if (currentDepthValue < zMin || currentDepthValue > zMax) {  // test for depth window
        depthImage.pixels[i] = 0;  // blackout if out of range
      }
      if (x ==xMin || x ==xMax) {  // test for cusp of width window
        depthImage.pixels[i] = 0;  // blackout if on cusp of range
      }
      int[] userMap = context.userMap();

      if (userMap[i]!=0) {
        depthImage.pixels[i] = rgbImage.pixels[i];
      }
    }
  }
}

void filterUsers() {
  userList = context.getUsers();  // get list of detected users
  userCount = userList.length;
  blackList = new int[userCount];  // set up blackList as the same length
  targetUser=0;  // assume no target user by default
  playerCount=0;
  for (int i=0; i<userList.length; i++)  // scan user list
  {
    if (context.getCoM(userList[i], com))  // test to see if Centre of Mass is available
    {
      int currentZ=int(com.z);
      context.convertRealWorldToProjective(com, com2d);  // convert to 2D
      int currentX=int(com2d.x);
      blackList[i]=currentZ;  // save depth of CoM into user's place in the blackList
      if (currentZ>zMax || currentZ<zMin) {  // test for depth window
        blackList[i]=0;  // clear depth for that user in blackList
      }
      if (currentX>(xMax) || currentX<(xMin)) {  // test for width window
        blackList[i]=0;  // clear depth for that user in blackList
      }
      if (i==0) {  // test for first user in list
        if (blackList[i]>0) {  // test for non-blacklisted
          targetUser=1;  // set them as target
          playerCount++;
        }
      } else {  // if not first user
        if (targetUser>0) { // test for whether there is currently a target
          if (blackList[i]>0) { // test for non-blacklisted
            playerCount++;
            if (blackList[i]<blackList[targetUser-1]) {  // test whether user's CoM is closer (less) than the target
              targetUser=i+1;  // set them as new target
            }
          }
        } else if (blackList[i]>0)  // if there isn't currently a target, test for non-blacklisted
        {
          targetUser=i+1;  // set them as new target
          playerCount++;
        }
      }
    }
  }
}

void targetUser() {
  if (userList.length>0) {  // test for whether any users are currently detected, hidden or otherwise
    //    print(targetUser);  // target user number
    //    print(":");
    if (targetUser==0) {  // test for no target
      //      println("none");
    } else {  // if there is a target
      //      println(blackList[targetUser-1]);  // target user's CoM depth
      context.getCoM(userList[targetUser-1], com);  // get full CoM vector for target user

      float zFloat=map(com.z, zMin, zMax, 0, 255);
      z=int(zFloat);

      context.convertRealWorldToProjective(com, com2d);  // convert to 2D

      float xFloat=map(com2d.x, xMin, xMax, 0, 255);
      x=int(xFloat);
      float yFloat=map(com2d.y, 0, 640, 255, 0);
      y=int(yFloat);
      if (input) {
        drawCoM();

        if (skeleton) {
          if (context.isTrackingSkeleton(userList[targetUser-1]))  // test for skeleton available for target user
          {
            drawSkeleton(userList[targetUser-1]);  // draw target skeleton
          }
        }
      }
      PVector rHandPos = new PVector();  // vector for right hand point
      context.getJointPositionSkeleton(targetUser, SimpleOpenNI.SKEL_RIGHT_HAND, rHandPos);  // get right hand vector
      PVector lHandPos = new PVector();  // vector for left hand point
      context.getJointPositionSkeleton(targetUser, SimpleOpenNI.SKEL_LEFT_HAND, lHandPos);  // get left hand vector
      if (int(rHandPos.z)!=0 || int(lHandPos.z)!=0) {
        int rHandDiff = blackList[targetUser-1]-int(rHandPos.z);  // measure difference between CoM depth and right hand depth
        int lHandDiff = blackList[targetUser-1]-int(lHandPos.z);  // measure difference between CoM depth and left hand depth
        if (rHandDiff > kickThreshold || lHandDiff > kickThreshold) {  // test for hand/CoM depth diff
          if (kick==false) {
          }
          kick=true;
        } else {
          kick=false;
        }
      }
    }
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  targetUser=0;
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
