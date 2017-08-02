void drawStatus2() {
  translate(0, 600);
  textAlign(LEFT);
  fill(255);
  int lH=20;
  textSize(lH);
  int yDraw=100;
  text("people on camera (userCount): "+userCount, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  text("people in play window (playerCount): "+playerCount, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  text("active player (targetUser): "+targetUser, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  text("active player horizontal (x): "+x, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  text("active player vertical (y): "+y, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  text("active player depth (z): "+z, 100, yDraw);
  yDraw=yDraw+int(1.5*lH);
  translate(0, -600);
}

void drawKinectView() {
  if (kinect) {
    image(depthImage, 100, 100);  // draw trimmed image to screen
  } else {
    fill(127);
    rect(100, 100, 640, 480);
  }
  fill(0, 200);
  noStroke();
  rect(100, 100, xMin, 480);  // left cutoff box
  rect(xMax+100, 100, 640-xMax, 480);  // right cutoff box
  fill(64);
}

void drawCoM() {
  drawPlayerLabel(com2d.x, com2d.y, targetUser);
}

void drawPlayerLabel(float x, float y, int targetUser) {
  x=constrain(x, 5, 634);  
  y=constrain(y, 5, 475);  
  x=x+100;
  y=y+100;
  stroke(255);
  strokeWeight(1);
  beginShape(LINES);  // draw CoM to screen
  vertex(x, y - 5);  
  vertex(x, y + 5);
  vertex(x - 5, y);
  vertex(x + 5, y);
  endShape();
  fill(255);
  float w2=textWidth("PP");
  int xOffLine=60;
  int xOffText=10;
  int yOffLine=60;
  int yOffText=10;
  if ((x+70+w2)>740) {
    xOffLine=xOffLine*-1;
    xOffText=xOffText*-1;
    w2=w2*-1;
    textAlign(RIGHT);
  }
  if (y<200) {
    yOffLine=yOffLine*-1;
  }
  float xLimit=x+xOffLine+xOffText;
  float yLimit=y-yOffLine-yOffText-30;
  text("P"+targetUser, x+xOffLine+xOffText, y-yOffLine-yOffText);  // display userId off CoM
  beginShape(LINES);  // draw annotation line to screen
  vertex(x, y);  
  vertex(x+xOffLine, y-yOffLine);
  vertex(x+xOffLine, y-yOffLine);
  vertex(xLimit+w2, y-yOffLine);
  //  vertex(xLimit, y-60);
  //  vertex(xLimit, yLimit);
  endShape();
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  stroke(userClr[ (userList[targetUser-1] - 1) % userClr.length ] );  // set stroke colour
  stroke(255);
  translate(100, 100);
  // to get the 3d joint data
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  translate(-100, -100);
}

