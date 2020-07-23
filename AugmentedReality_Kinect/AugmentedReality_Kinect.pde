// Drivers, Libraries and Processing code are available to download - link below the video

// 1st step. Install provided drivers - KinectSDK-v1.7-Setup
// 2nd step: Add SimpleOpenNI and Objloader libraries
// 3rd step: ENJOY! (press "play")

import SimpleOpenNI.*;
import saito.objloader.*;

OBJModel model ;

SimpleOpenNI  context;

PVector com = new PVector();                                   
PVector com2d = new PVector();

float[] xyz; 
float i =  0;

int xx=0, yy=0, zz=0;
void setup()
{
  size(640, 480, OPENGL); // this is max RGB resolution using first Microsoft Kinect for Xbox 360
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableRGB(); 
 // size(context.depthWidth(), context.depthHeight()); 
  context.enableUser();
  
  stroke(0,0,255);
  strokeWeight(3);
  smooth();
 
  // you can comment/uncomment either Iron Man Mask or Skull !
  
  //model = new OBJModel(this, "iron.obj", "absolute", TRIANGLES);
  //model.enableDebug();
  //model.scale(0.9);
  //model = new OBJModel(this, "skull.obj", "absolute", TRIANGLES);
 // model.enableDebug();
 // model.translateToCenter();
  
  //model = new OBJModel(this, "untitled.obj", "absolute", TRIANGLES);
//model = new OBJModel(this, "skirt1.obj", "absolute", TRIANGLES);
model = new OBJModel(this, "skirt1.obj", "absolute", TRIANGLES);

  //model.scale(0.9); Tee
  //model.scale(0.4); //Dress
  model.scale(0.9); //skirt1
  
  model.enableDebug();
  model.translateToCenter();

  //stroke(255);
  noStroke();
}

void draw()
{
 context.update();  
 image(context.rgbImage(),0,0); 
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(color(0,0,255));
      drawSkeleton(userList[i]);
    }      
      
    // draw the center of mass
    if(context.getCoM(userList[i],com))
    {
      context.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(1);
      beginShape(LINES);
      
       vertex(com2d.x - 15,com2d.y,com2d.z);
        vertex(com2d.x + 15,com2d.y,com2d.z);
        
        vertex(com2d.x,com2d.y - 15,com2d.z);
        vertex(com2d.x,com2d.y + 15,com2d.z);

        vertex(com2d.x,com2d.y,com2d.z - 15);
        vertex(com2d.x,com2d.y,com2d.z + 15);

      endShape();
      
      fill(0,255,100);
      text(Integer.toString(userList[i]),com2d.x,com2d.y);
    }
  }    
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{  
   strokeWeight(3);
  PVector jointPos = new PVector();
  // SKEL_RIGHT_HAND
  //context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos); // SKEL_HEAD
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,jointPos); // SKEL_HEAD
  PVector convertedJointPos = new PVector();
  context.convertRealWorldToProjective(jointPos, convertedJointPos);
  
 // float newImageWidth = map(convertedJointPos.y, 500, 2000, img.width/6, img.width/12);
 // float newImageHeight = map(convertedJointPos.y, 500, 2000, img.height/6, img.height/12);
  
//  newImageWidth = constrain(newImageWidth, 75, 100);

  PMatrix3D  orientation = new PMatrix3D();
  //int jointType = SimpleOpenNI.SKEL_NECK; // SKEL_HEAD
  int jointType = SimpleOpenNI.SKEL_TORSO; // SKEL_HEAD
  context.getJointOrientationSkeleton(userId,jointType,orientation);
  
  // modeliu pride
  float mapScale = map(convertedJointPos.z, 500, 4000, 1.75, 0.35);
 // print(mapScale); print(" "); println(convertedJointPos.z);
  
  pushMatrix();
  //translate(convertedJointPos.x+20,convertedJointPos.y+50, 0); // 20 vietoj z  // dress
  translate(convertedJointPos.x,convertedJointPos.y, 0); // 20 vietoj z  // skirt
  //translate(0,0, 0); // 20 vietoj z
   // applyMatrix(orientation);
 float phi = atan(orientation.m12/orientation.m22);
 float theta = - asin(orientation.m02);
 float psi = atan(orientation.m01/orientation.m00);
 //print(degrees(phi)); print(", "); print(degrees(theta)); print(", "); println(degrees(psi));
    //print(m00); print(", "); print(m10); print(", "); println(m20);8522222222222222222222222222222222
  //  printMatrix();
  // image(img, -1 * (newImageWidth/2), 0 - (newImageHeight/2),64,64);
   int length = 50;
   translate(xx,yy,zz);
   //translate(0,0,0);
   println(xx + ", " + yy + ", " + zz); 
   pushMatrix();
     rotateX(-phi);
     rotateY(theta);
     rotateZ(psi);
     //image(img, -1 * (newImageWidth/2), 0 - (newImageHeight/2),64,64);
   stroke(255,0,0); line(0,0,0,length,0,0); // x - r
   stroke(0,255,0); line(0,0,0,0,length,0); // y - g
   stroke(0,0,255); line(0,0,0,0,0,length); // z - b 
     lights();
     noStroke();
     scale(mapScale);
     model.draw();
     //model.draw();
   popMatrix();
  popMatrix();
  
  //context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  context.drawLimb(userId,SimpleOpenNI.SKEL_NECK,SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  
  context.update(); 
  // mygtuku atvaizdavimas - red-green buttons
   // end
   // teskto atvaizdavimas
    if (convertedJointPos.z<1800) {
      fill(255,0,0);
    //  textSize(20); // neveikia?
    //  textAlign(CENTER);
    //  text("Per arti!",600,420);
    }
     if (convertedJointPos.z>=1800) {
      fill(79,152,12);
    //  textSize(20); // neveikia?
    //  textAlign(CENTER);
    //  text("OK!",610,420);
    }
    //end
}

// -----------------------------------------------------------------
// SimpleOpenNI events
void drawLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;
  
  // draw the joint position
  confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);

  stroke(255,0,0,confidence * 200 + 55);
  line(jointPos1.x,jointPos1.y,jointPos1.z,
       jointPos2.x,jointPos2.y,jointPos2.z);
  
 // drawJointOrientation(userId,jointType1,jointPos1,50);
}
/*
void drawJointOrientation(int userId,int jointType,PVector pos,float length)
{
  // draw the joint orientation  
  PMatrix3D  orientation = new PMatrix3D();
  float confidence = context.getJointOrientationSkeleton(userId,jointType,orientation);
  if(confidence < 0.001f) 
    // nothing to draw, orientation data is useless
    return;
    
  pushMatrix();
    translate(pos.x,pos.y,pos.z);
    
    // set the local coordsys
    applyMatrix(orientation);
    
    // coordsys lines are 100mm long
    // x - r
    stroke(255,0,0,confidence * 200 + 55);
    line(0,0,0,
         length,0,0);
    // y - g
    stroke(0,255,0,confidence * 200 + 55);
    line(0,0,0,
         0,length,0);
    // z - b    
    stroke(0,0,255,confidence * 200 + 55);
    line(0,0,0,
         0,0,length);
  popMatrix();
}
*/
void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;
  }
}  

