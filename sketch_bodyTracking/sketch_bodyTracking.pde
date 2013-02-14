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

float bodyAlpha = 0; // originally 100



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




// remember the last 2D point
PVector lastScreenPosLeftHand = new PVector(); 
PVector lastScreenPosRightHand = new PVector(); 
PVector lastScreenPosHead = new PVector();
PVector lastScreenPosNeck = new PVector();
PVector lastScreenPosLeftShoulder = new PVector();
PVector lastScreenPosRightShoulder = new PVector();
PVector lastScreenPosLeftElbow = new PVector();
PVector lastScreenPosRightElbow = new PVector();
PVector lastScreenPosTorso = new PVector();
PVector lastScreenPosLeftHip = new PVector();
PVector lastScreenPosRightHip = new PVector();
PVector lastScreenPosLeftKnee = new PVector();
PVector lastScreenPosRightKnee = new PVector();
PVector lastScreenPosLeftFoot = new PVector();
PVector lastScreenPosRightFoot = new PVector();




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
  fill(255, 0, 0, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftHand.x, screenPosLeftHand.y, jointPosLeftHand.z/100.0, jointPosLeftHand.z/100.0);
  
  addForce(screenPosLeftHand.x, screenPosLeftHand.y, screenPosLeftHand.x-lastScreenPosLeftHand.x, screenPosLeftHand.y-lastScreenPosLeftHand.y, 0);
  lastScreenPosLeftHand = screenPosLeftHand; // saving current value for next time (to remember the last point)

  // RIGHT HAND 
  PVector jointPosRightHand = new PVector();  // 3D point
  PVector screenPosRightHand = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointPosRightHand);
  context.convertRealWorldToProjective(jointPosRightHand, screenPosRightHand);
  //println(jointPos);
  fill(0, 255, 0, bodyAlpha);
  noStroke();
  ellipse(screenPosRightHand.x, screenPosRightHand.y, jointPosRightHand.z/100.0, jointPosRightHand.z/100.0);
 
  addForce(screenPosRightHand.x, screenPosRightHand.y, screenPosRightHand.x-lastScreenPosRightHand.x, screenPosRightHand.y-lastScreenPosRightHand.y, 24);
  lastScreenPosRightHand = screenPosRightHand; // saving current value for next time (to remember the last point)
 
  // HEAD
  PVector jointPosHead = new PVector();  // 3D point
  PVector screenPosHead = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, jointPosHead);
  context.convertRealWorldToProjective(jointPosHead, screenPosHead);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosHead.x, screenPosHead.y, jointPosHead.z/100.0, jointPosHead.z/100.0);
  
  addForce(screenPosHead.x, screenPosHead.y, screenPosHead.x-lastScreenPosHead.x, screenPosHead.y-lastScreenPosHead.y, 48);
  lastScreenPosHead = screenPosHead; // saving current value for next time (to remember the last point)
  
  // NECK (more like chest)
  PVector jointPosNeck = new PVector();  // 3D point
  PVector screenPosNeck = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, jointPosNeck);
  context.convertRealWorldToProjective(jointPosNeck, screenPosNeck);
  //println(jointPos);
  fill(0, 0, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosNeck.x, screenPosNeck.y, jointPosNeck.z/100.0, jointPosNeck.z/100.0);
  
  addForce(screenPosNeck.x, screenPosNeck.y, screenPosNeck.x-lastScreenPosNeck.x, screenPosNeck.y-lastScreenPosNeck.y, 72);
  lastScreenPosNeck = screenPosNeck; // saving current value for next time (to remember the last point)
  
  // LEFT SHOULDER 
  PVector jointPosLeftShoulder = new PVector();  // 3D point
  PVector screenPosLeftShoulder = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, jointPosLeftShoulder);
  context.convertRealWorldToProjective(jointPosLeftShoulder, screenPosLeftShoulder);
  //println(jointPos);
  fill(255, 0, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftShoulder.x, screenPosLeftShoulder.y, jointPosLeftShoulder.z/100.0, jointPosLeftShoulder.z/100.0);
  
  addForce(screenPosLeftShoulder.x, screenPosLeftShoulder.y, screenPosLeftShoulder.x-lastScreenPosLeftShoulder.x, screenPosLeftShoulder.y-lastScreenPosLeftShoulder.y, 336);
  lastScreenPosLeftShoulder = screenPosLeftShoulder; // saving current value for next time (to remember the last point)
  
  // RIGHT SHOULDER 
  PVector jointPosRightShoulder = new PVector();  // 3D point
  PVector screenPosRightShoulder = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, jointPosRightShoulder);
  context.convertRealWorldToProjective(jointPosRightShoulder, screenPosRightShoulder);
  //println(jointPos);
  fill(0, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosRightShoulder.x, screenPosRightShoulder.y, jointPosRightShoulder.z/100.0, jointPosRightShoulder.z/100.0);
  
  addForce(screenPosRightShoulder.x, screenPosRightShoulder.y, screenPosRightShoulder.x-lastScreenPosRightShoulder.x, screenPosRightShoulder.y-lastScreenPosRightShoulder.y, 312);
  lastScreenPosRightShoulder = screenPosRightShoulder; // saving current value for next time (to remember the last point)
  
  // LEFT ELBOW 
  PVector jointPosLeftElbow = new PVector();  // 3D point
  PVector screenPosLeftElbow = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, jointPosLeftElbow);
  context.convertRealWorldToProjective(jointPosLeftElbow, screenPosLeftElbow);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftElbow.x, screenPosLeftElbow.y, jointPosLeftElbow.z/100.0, jointPosLeftElbow.z/100.0);
  
  addForce(screenPosLeftElbow.x, screenPosLeftElbow.y, screenPosLeftElbow.x-lastScreenPosLeftElbow.x, screenPosLeftElbow.y-lastScreenPosLeftElbow.y, 288);
  lastScreenPosLeftElbow = screenPosLeftElbow; // saving current value for next time (to remember the last point)
  
  // RIGHT ELBOW 
  PVector jointPosRightElbow = new PVector();  // 3D point
  PVector screenPosRightElbow = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, jointPosRightElbow);
  context.convertRealWorldToProjective(jointPosRightElbow, screenPosRightElbow);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosRightElbow.x, screenPosRightElbow.y, jointPosRightElbow.z/100.0, jointPosRightElbow.z/100.0);
  
  addForce(screenPosRightElbow.x, screenPosRightElbow.y, screenPosRightElbow.x-lastScreenPosRightElbow.x, screenPosRightElbow.y-lastScreenPosRightElbow.y, 264);
  lastScreenPosRightElbow = screenPosRightElbow; // saving current value for next time (to remember the last point)
  
  // TORSO 
  PVector jointPosTorso = new PVector();  // 3D point
  PVector screenPosTorso = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, jointPosTorso);
  context.convertRealWorldToProjective(jointPosTorso, screenPosTorso);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosTorso.x, screenPosTorso.y, jointPosTorso.z/100.0, jointPosTorso.z/100.0);
  
  addForce(screenPosTorso.x, screenPosTorso.y, screenPosTorso.x-lastScreenPosTorso.x, screenPosTorso.y-lastScreenPosTorso.y, 240);
  lastScreenPosTorso = screenPosTorso; // saving current value for next time (to remember the last point)
  
  // LEFT HIP 
  PVector jointPosLeftHip = new PVector();  // 3D point
  PVector screenPosLeftHip = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, jointPosLeftHip);
  context.convertRealWorldToProjective(jointPosLeftHip, screenPosLeftHip);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftHip.x, screenPosLeftHip.y, jointPosLeftHip.z/100.0, jointPosLeftHip.z/100.0);
  
  addForce(screenPosLeftHip.x, screenPosLeftHip.y, screenPosLeftHip.x-lastScreenPosLeftHip.x, screenPosLeftHip.y-lastScreenPosLeftHip.y, 96);
  lastScreenPosLeftHip = screenPosLeftHip; // saving current value for next time (to remember the last point)
  
  // RIGHT HIP 
  PVector jointPosRightHip = new PVector();  // 3D point
  PVector screenPosRightHip = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, jointPosRightHip);
  context.convertRealWorldToProjective(jointPosRightHip, screenPosRightHip);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosRightHip.x, screenPosRightHip.y, jointPosRightHip.z/100.0, jointPosRightHip.z/100.0);
  
  addForce(screenPosRightHip.x, screenPosRightHip.y, screenPosRightHip.x-lastScreenPosRightHip.x, screenPosRightHip.y-lastScreenPosRightHip.y, 120);
  lastScreenPosRightHip = screenPosRightHip; // saving current value for next time (to remember the last point)
  
  // LEFT KNEE 
  PVector jointPosLeftKnee = new PVector();  // 3D point
  PVector screenPosLeftKnee = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, jointPosLeftKnee);
  context.convertRealWorldToProjective(jointPosLeftKnee, screenPosLeftKnee);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftKnee.x, screenPosLeftKnee.y, jointPosLeftKnee.z/100.0, jointPosLeftKnee.z/100.0);
  
  addForce(screenPosLeftKnee.x, screenPosLeftKnee.y, screenPosLeftKnee.x-lastScreenPosLeftKnee.x, screenPosLeftKnee.y-lastScreenPosLeftKnee.y, 144);
  lastScreenPosLeftKnee = screenPosLeftKnee; // saving current value for next time (to remember the last point)
  
  // RIGHT KNEE 
  PVector jointPosRightKnee = new PVector();  // 3D point
  PVector screenPosRightKnee = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, jointPosRightKnee);
  context.convertRealWorldToProjective(jointPosRightKnee, screenPosRightKnee);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosRightKnee.x, screenPosRightKnee.y, jointPosRightKnee.z/100.0, jointPosRightKnee.z/100.0);
  
  addForce(screenPosRightKnee.x, screenPosRightKnee.y, screenPosRightKnee.x-lastScreenPosRightKnee.x, screenPosRightKnee.y-lastScreenPosRightKnee.y, 168);
  lastScreenPosRightKnee = screenPosRightKnee; // saving current value for next time (to remember the last point)
  
  // LEFT FOOT 
  PVector jointPosLeftFoot = new PVector();  // 3D point
  PVector screenPosLeftFoot = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, jointPosLeftFoot);
  context.convertRealWorldToProjective(jointPosLeftFoot, screenPosLeftFoot);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosLeftFoot.x, screenPosLeftFoot.y, jointPosLeftFoot.z/100.0, jointPosLeftFoot.z/100.0);
  
  addForce(screenPosLeftFoot.x, screenPosLeftFoot.y, screenPosLeftFoot.x-lastScreenPosLeftFoot.x, screenPosLeftFoot.y-lastScreenPosLeftFoot.y, 192);
  lastScreenPosLeftFoot = screenPosLeftFoot; // saving current value for next time (to remember the last point)
  
  // RIGHT FOOT 
  PVector jointPosRightFoot = new PVector();  // 3D point
  PVector screenPosRightFoot = new PVector();  // 2D point
  context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, jointPosRightFoot);
  context.convertRealWorldToProjective(jointPosRightFoot, screenPosRightFoot);
  //println(jointPos);
  fill(255, 255, 255, bodyAlpha);
  noStroke();
  ellipse(screenPosRightFoot.x, screenPosRightFoot.y, jointPosRightFoot.z/100.0, jointPosRightFoot.z/100.0);
  
  addForce(screenPosRightFoot.x, screenPosRightFoot.y, screenPosRightFoot.x-lastScreenPosRightFoot.x, screenPosRightFoot.y-lastScreenPosRightFoot.y, 216);
  lastScreenPosRightFoot = screenPosRightFoot; // saving current value for next time (to remember the last point)
  
}




// add force and dye to fluid, and create particles
// x & y are position
// d = derivative of the position
// dx & dy = velocity
void addForce(float x, float y, float dx, float dy, float hue) {
  addForceAbs(x/float(width), y/float(height), dx/float(width), dy/float(height), hue);
}

void addForceAbs(float x, float y, float dx, float dy, float hue) {
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
        hue = (hue + frameCount/30) % 360;
        //float hue = ((x + y) * 180 + frameCount) % 360;
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
