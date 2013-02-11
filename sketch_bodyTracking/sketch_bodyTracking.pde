/*  Resources  */
//  SimpleOpenNI User Test
//  https://github.com/acm-uiuc/FallingBlocks/blob/master/PhsyicsKinect/PhsyicsKinect.pde
//  http://www.memo.tv/msafluid/




/* variables */

import SimpleOpenNI.*;

SimpleOpenNI context;
boolean autoCalib=true;




void setup() {
  context = new SimpleOpenNI(this);
  
  // enable depthMap generation 
  context.enableDepth();
  context.setMirror(true);  // mirrors the image
 
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
 
  size(context.depthWidth(), context.depthHeight());
  
  
}




void draw() {
 // update the cam
  context.update();
  
  // draw depthImageMap
  image(context.depthImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
      drawSkeleton(userList[i]);
  }  
  
}




// draw the skeleton with the selected joints
void drawSkeleton(int userId) {
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  // from https://github.com/acm-uiuc/FallingBlocks/blob/master/PhsyicsKinect/PhsyicsKinect.pde
  
  // LEFT HAND 
  PVector jointPosLeftHand = new PVector();  // 3D point
  PVector screenPosLeftHand = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointPosLeftHand);
  context.convertRealWorldToProjective(jointPosLeftHand, screenPosLeftHand);
  //println(jointPos);
  fill(255, 0, 0, 100);
  noStroke();
  ellipse(screenPosLeftHand.x, screenPosLeftHand.y, jointPosLeftHand.z/100.0, jointPosLeftHand.z/100.0);

  // RIGHT HAND 
  PVector jointPosRightHand = new PVector();  // 3D point
  PVector screenPosRightHand = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointPosRightHand);
  context.convertRealWorldToProjective(jointPosRightHand, screenPosRightHand);
  //println(jointPos);
  fill(0, 255, 0, 100);
  noStroke();
  ellipse(screenPosRightHand.x, screenPosRightHand.y, jointPosRightHand.z/100.0, jointPosRightHand.z/100.0);
 
  // HEAD
  PVector jointPosHead = new PVector();  // 3D point
  PVector screenPosHead = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPosHead);
  context.convertRealWorldToProjective(jointPosHead, screenPosHead);
  //println(jointPos);
  fill(0, 255, 255, 100);
  noStroke();
  ellipse(screenPosHead.x, screenPosHead.y, jointPosHead.z/100.0, jointPosHead.z/100.0);
  
  // NECK (more like chest)
  PVector jointPosNeck = new PVector();  // 3D point
  PVector screenPosNeck = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, jointPosNeck);
  context.convertRealWorldToProjective(jointPosNeck, screenPosNeck);
  //println(jointPos);
  fill(0, 0, 255, 100);
  noStroke();
  ellipse(screenPosNeck.x, screenPosNeck.y, jointPosNeck.z/100.0, jointPosNeck.z/100.0);
  
  // LEFT SHOULDER 
  PVector jointPosLeftShoulder = new PVector();  // 3D point
  PVector screenPosLeftShoulder = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, jointPosLeftShoulder);
  context.convertRealWorldToProjective(jointPosLeftShoulder, screenPosLeftShoulder);
  //println(jointPos);
  fill(255, 0, 255, 100);
  noStroke();
  ellipse(screenPosLeftShoulder.x, screenPosLeftShoulder.y, jointPosLeftShoulder.z/100.0, jointPosLeftShoulder.z/100.0);
  
}




// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    context.requestCalibrationSkeleton(userId,true);
  else    
    context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onExitUser(int userId)
{
  println("onExitUser - userId: " + userId);
}

void onReEnterUser(int userId)
{
  println("onReEnterUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}
