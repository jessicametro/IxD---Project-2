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

float velScale = 0.0001;

float kinectWidth, kinectHeight;
float scaleWidth, scaleHeight;

ParticleSystem particles;



void setup() {
  //size(context.depthWidth(), context.depthHeight());
  size(displayWidth, displayHeight, OPENGL);
  
  context = new SimpleOpenNI(this);
  
  // enable depthMap generation 
  context.enableDepth();
  context.enableScene();
  context.setMirror(true);  // mirrors the image
  kinectWidth = context.depthWidth();
  kinectHeight = context.depthHeight();
  scaleWidth = width/kinectWidth;
  scaleHeight = height/kinectHeight;
 
 
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
 
  
  // create fluid and set options
  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    fluidSolver.enableRGB(true).setFadeSpeed(0.02).setDeltaT(0.5).setVisc(0.0001);

  // create image to hold fluid picture
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
  
  // create particles
  particles = new ParticleSystem();
  
}




void draw() {
  fill(0, 10);
  rect(0, 0, width, height);
  
  // update the cam
  context.update();
  
  // update the fluid simulation
  fluidSolver.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  
   // draw the fluid
   for(int i=0; i<fluidSolver.getNumCells(); i++) {
       int d = 2;
       imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
   }  
   imgFluid.updatePixels();//  fastblur(imgFluid, 2);
   image(imgFluid, 0, 0, width, height);
   fill(0, 0.5);
   rect(0, 0, width, height);

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
      drawSkeleton(userList[i]);
  } 
  
  // draw particles
  createParticles();
  particles.updateAndDraw();
}



// look through the scene to create particles
void createParticles() {
  int[] map = context.sceneMap();
  int[] depth = context.depthMap();
  if (frameCount % 1 == 0) {
    for (int i=0; i<1000; i++) {
      int x = int(random(0, kinectWidth));
      int y = int(random(0, kinectHeight));
      int loc = int(x+y*kinectWidth);
      if (map[loc] != 0) {
        float radius = ((5-(float(depth[loc])/1000))*2);   // originally : ((5-(float(depth[loc])/1000))*2)
        particles.addParticle(x/kinectWidth*width, y/kinectHeight*height, radius);
        
        // read fluid info and add to velocity
        int fluidIndex = fluidSolver.getIndexForNormalizedPosition(x/kinectWidth, y/kinectHeight);
        float fluidVX = fluidSolver.u[fluidIndex];
        float fluidVY = fluidSolver.v[fluidIndex];
        
        addColor(x/kinectWidth, y/kinectHeight, lerp(250, -20, ((dist(0,0,fluidVX, fluidVY)*20000)/360)));
        //addforce
      }
    }
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




// ARRAYS


PVector[] lastScreenPos = new PVector[15];

int[] jointColor = {
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
  216,
};


// draw the skeleton with the selected joints
void drawSkeleton(int userId) {

  // to get the 3d joint data
  // from https://github.com/acm-uiuc/FallingBlocks/blob/master/PhsyicsKinect/PhsyicsKinect.pde
  
  // this array goes inside for some reason....
  int[] jointID = {
    SimpleOpenNI.SKEL_LEFT_HAND, 
    SimpleOpenNI.SKEL_RIGHT_HAND,
    SimpleOpenNI.SKEL_HEAD,
    SimpleOpenNI.SKEL_NECK,
    SimpleOpenNI.SKEL_LEFT_SHOULDER,
    SimpleOpenNI.SKEL_RIGHT_SHOULDER,
    SimpleOpenNI.SKEL_LEFT_ELBOW,
    SimpleOpenNI.SKEL_RIGHT_ELBOW,
    SimpleOpenNI.SKEL_TORSO,
    SimpleOpenNI.SKEL_LEFT_HIP,
    SimpleOpenNI.SKEL_RIGHT_HIP,
    SimpleOpenNI.SKEL_LEFT_KNEE,
    SimpleOpenNI.SKEL_RIGHT_KNEE,
    SimpleOpenNI.SKEL_LEFT_FOOT,
    SimpleOpenNI.SKEL_RIGHT_FOOT,
  };

  for (int i=0; i<jointID.length; i++) {

    PVector jointPos = new PVector();  // 3D point
    PVector screenPos = new PVector();  // 2D point
    context.getJointPositionSkeleton(userId, jointID[i], jointPos);
    context.convertRealWorldToProjective(jointPos, screenPos);
    //println(jointPos);
    fill(255, 255, 255, bodyAlpha);
    noStroke();
    ellipse(screenPos.x*scaleWidth, screenPos.y*scaleHeight, jointPos.z/100.0, jointPos.z/100.0);

    if (lastScreenPos[i] == null) {    // if there's nothing in there   
      lastScreenPos[i] = screenPos;    // use the initial position
    }
    
    addForce(screenPos.x, screenPos.y, screenPos.x-lastScreenPos[i].x, screenPos.y-lastScreenPos[i].y, jointColor[i]);
    lastScreenPos[i] = screenPos; // saving current value for next time (to remember the last point)
  }
  
}




// add force and dye to fluid, and create particles
// x & y are position
// d = derivative of the position
// dx & dy = velocity
void addForce(float x, float y, float dx, float dy, float hue) {
  addForceAbs(x/(kinectWidth), y/(kinectHeight), dx/(kinectWidth), dy/(kinectHeight), hue);
}

void addForceAbs(float x, float y, float dx, float dy, float hue) {
    float speed = dx * dx  + dy * dy * (kinectHeight)/(kinectWidth);    // balance the x and y components of speed with the screen aspect ratio

    if(speed > 0) {
        if(x<0) x = 0; 
        else if(x>1) x = 1;
        if(y<0) y = 0; 
        else if(y>1) y = 1;

        float velocityMult = 30.0f;

        int index = fluidSolver.getIndexForNormalizedPosition(x, y);

        fluidSolver.uOld[index] += dx * velocityMult;
        fluidSolver.vOld[index] += dy * velocityMult;
        
        //particles.addParticle(x*width, y*height);
    }  
}


void addColor(float x, float y, float hue) {
  if(x<0) x = 0; 
  else if(x>1) x = 1;
  if(y<0) y = 0; 
  else if(y>1) y = 1;

  float colorMult = 1;

  int index = fluidSolver.getIndexForNormalizedPosition(x, y);

  color drawColor;

  colorMode(HSB, 360, 1, 0.05);
  //hue = (hue + frameCount/60) % 360;
  //float hue = ((x + y) * 180 + frameCount) % 360;
  drawColor = color(hue, 1, 0.1);
  colorMode(RGB, 1);  

  fluidSolver.rOld[index]  += red(drawColor) * colorMult;
  fluidSolver.gOld[index]  += green(drawColor) * colorMult;
  fluidSolver.bOld[index]  += blue(drawColor) * colorMult;
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
