/*  RESOURCES  */

//  SimpleOpenNI User Test
//  https://github.com/acm-uiuc/FallingBlocks/blob/master/PhsyicsKinect/PhsyicsKinect.pde
//  http://www.memo.tv/msafluid/




/*  IMPORTS  */

import SimpleOpenNI.*;
import msafluid.*;




/*  VARIABLES  */

SimpleOpenNI context;
boolean autoCalib=true;
final float FLUID_WIDTH = 120;

MSAFluidSolver2D fluidSolver;
PImage imgFluid;


void setup() {
  context = new SimpleOpenNI(this);
  
  // enable depthMap generation 
  context.enableDepth();
  context.setMirror(true);  // mirrors the image
 
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
 
  size(context.depthWidth(), context.depthHeight());
  
  // create fluid and set options
  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    fluidSolver.enableRGB(true).setFadeSpeed(0.003).setDeltaT(0.5).setVisc(0.0001);

  // create image to hold fluid picture
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
}




void draw() {
  // update the cam
  context.update();
  
  // update the fluid simulation
  fluidSolver.update();
  
  // draw depthImageMap
  image(context.depthImage(),0,0);
  
   // draw the fluid
   for(int i=0; i<fluidSolver.getNumCells(); i++) {
       int d = 2;
       imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
   }  
   imgFluid.updatePixels();//  fastblur(imgFluid, 2);
   image(imgFluid, 0, 0, width, height);

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
  fill(255, 255, 255, 100);
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
  
  // RIGHT SHOULDER 
  PVector jointPosRightShoulder = new PVector();  // 3D point
  PVector screenPosRightShoulder = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, jointPosRightShoulder);
  context.convertRealWorldToProjective(jointPosRightShoulder, screenPosRightShoulder);
  //println(jointPos);
  fill(0, 255, 255, 100);
  noStroke();
  ellipse(screenPosRightShoulder.x, screenPosRightShoulder.y, jointPosRightShoulder.z/100.0, jointPosRightShoulder.z/100.0);
  
  // LEFT ELBOW 
  PVector jointPosLeftElbow = new PVector();  // 3D point
  PVector screenPosLeftElbow = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, jointPosLeftElbow);
  context.convertRealWorldToProjective(jointPosLeftElbow, screenPosLeftElbow);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosLeftElbow.x, screenPosLeftElbow.y, jointPosLeftElbow.z/100.0, jointPosLeftElbow.z/100.0);
  
  // RIGHT ELBOW 
  PVector jointPosRightElbow = new PVector();  // 3D point
  PVector screenPosRightElbow = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, jointPosRightElbow);
  context.convertRealWorldToProjective(jointPosRightElbow, screenPosRightElbow);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosRightElbow.x, screenPosRightElbow.y, jointPosRightElbow.z/100.0, jointPosRightElbow.z/100.0);
  
  // TORSO 
  PVector jointPosTorso = new PVector();  // 3D point
  PVector screenPosTorso = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, jointPosTorso);
  context.convertRealWorldToProjective(jointPosTorso, screenPosTorso);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosTorso.x, screenPosTorso.y, jointPosTorso.z/100.0, jointPosTorso.z/100.0);
  
  // LEFT HIP 
  PVector jointPosLeftHip = new PVector();  // 3D point
  PVector screenPosLeftHip = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, jointPosLeftHip);
  context.convertRealWorldToProjective(jointPosLeftHip, screenPosLeftHip);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosLeftHip.x, screenPosLeftHip.y, jointPosLeftHip.z/100.0, jointPosLeftHip.z/100.0);
  
  // RIGHT HIP 
  PVector jointPosRightHip = new PVector();  // 3D point
  PVector screenPosRightHip = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, jointPosRightHip);
  context.convertRealWorldToProjective(jointPosRightHip, screenPosRightHip);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosRightHip.x, screenPosRightHip.y, jointPosRightHip.z/100.0, jointPosRightHip.z/100.0);
  
  // LEFT KNEE 
  PVector jointPosLeftKnee = new PVector();  // 3D point
  PVector screenPosLeftKnee = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, jointPosLeftKnee);
  context.convertRealWorldToProjective(jointPosLeftKnee, screenPosLeftKnee);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosLeftKnee.x, screenPosLeftKnee.y, jointPosLeftKnee.z/100.0, jointPosLeftKnee.z/100.0);
  
  // RIGHT KNEE 
  PVector jointPosRightKnee = new PVector();  // 3D point
  PVector screenPosRightKnee = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, jointPosRightKnee);
  context.convertRealWorldToProjective(jointPosRightKnee, screenPosRightKnee);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosRightKnee.x, screenPosRightKnee.y, jointPosRightKnee.z/100.0, jointPosRightKnee.z/100.0);
  
  // LEFT FOOT 
  PVector jointPosLeftFoot = new PVector();  // 3D point
  PVector screenPosLeftFoot = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, jointPosLeftFoot);
  context.convertRealWorldToProjective(jointPosLeftFoot, screenPosLeftFoot);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosLeftFoot.x, screenPosLeftFoot.y, jointPosLeftFoot.z/100.0, jointPosLeftFoot.z/100.0);
  
  // RIGHT FOOT 
  PVector jointPosRightFoot = new PVector();  // 3D point
  PVector screenPosRightFoot = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, jointPosRightFoot);
  context.convertRealWorldToProjective(jointPosRightFoot, screenPosRightFoot);
  //println(jointPos);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(screenPosRightFoot.x, screenPosRightFoot.y, jointPosRightFoot.z/100.0, jointPosRightFoot.z/100.0);
  
}




// add force and dye to fluid, and create particles
// x & y are position, where 0 is the left & top, and 1 is the right & bottom.
// d = derivative of the position
// dx & dy = velocity
void addForce(float x, float y, float dx, float dy) {
    float speed = dx * dx  + dy * dy * float(height)/float(width);    // balance the x and y components of speed with the screen aspect ratio

    if(speed > 0) {
        if(x<0) x = 0; 
        else if(x>1) x = 1;
        if(y<0) y = 0; 
        else if(y>1) y = 1;

        float colorMult = 5;
        float velocityMult = 30.0f;

        int index = fluidSolver.getIndexForNormalizedPosition(x, y);

        color drawColor;

        colorMode(HSB, 360, 1, 1);
        float hue = ((x + y) * 180 + frameCount) % 360;
        drawColor = color(hue, 1, 1);
        colorMode(RGB, 1);  

        fluidSolver.rOld[index]  += red(drawColor) * colorMult;
        fluidSolver.gOld[index]  += green(drawColor) * colorMult;
        fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

        fluidSolver.uOld[index] += dx * velocityMult;
        fluidSolver.vOld[index] += dy * velocityMult;
    }
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
