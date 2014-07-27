/*   File    : EAC Columbus Corridor Detector-Sender
 *   Version : 1.0.0
 *   Update  : 02/07/2014
 *   Authors : Alexandros M. Cardaris (alexandros@cardaris.gr)
 *             Nelson Steinmetz (nelsonsteinmetz@gmail.com)
 *   Company : European Space Agency - EAC
 *   Credits : Max Rheiner (DepthMap3d SimpleOpenNI) (http://iad.zhdk.ch/)
 *             Andreas Schlegel (oscP5sendreceive)
 */

// IMPORTANT NOTE: Run DisplayerReceiver First!


import SimpleOpenNI.*;

private SimpleOpenNI kinect;
private PVector realWorldPoint;
private int side = 1;

/* Define detection rectangles */
private DetectBox rectangle0 = new DetectBox(-160, 5720, 1000);      //  Debug rectangle        Scene 3
private DetectBox rectangle1 = new DetectBox(-350, 1800, 1001);      //  EDR, Front side        Scene 1
private DetectBox rectangle2 = new DetectBox(600, 1900, 1002);       //  Glovebox, Front side   Scene 1
private DetectBox rectangle3 = new DetectBox(-160, 51100, 1003);     //  MARES, Front side      Scene 2
private DetectBox rectangle4 = new DetectBox(-550, 5910, 1004);      //  Plate, Front side      Scene 2
private DetectBox rectangle5 = new DetectBox(-280, 51190, 1005);     //  Storage, Aft Side      Scene 4
private DetectBox rectangle6 = new DetectBox(-330, 51190, 1006);     //  EPM, Aft Side          Scene 4
private DetectBox rectangle7 = new DetectBox(-380, 51190, 1007);     //  BIOLAB, Aft Side       Scene 5
private DetectBox rectangle8 = new DetectBox(-430, 51190, 1008);     //  Express 2, Aft Side    Scene 5

private DetectBox rectangle10 = new DetectBox(-6, 51030, 1010);      //  Gallery, Aft Side      Scene 5

private DetectBox rectangle51 = new DetectBox(-1000, 2000, 1051);    //  GoTo Right Button       Scene x
private DetectBox rectangle52 = new DetectBox(1000, 2000, 1052);     //  GoTo Left Button      Scene x

void setup()
{
  size(1024, 768, P3D);
  frameRate(30);
  
  kinect = new SimpleOpenNI(this);
  if (kinect.isInit() == false)
  {
    println("Can't initialize SimpleOpenNI, maybe the sensor is not connected!"); 
    exit();
  }
  else
  {
    println("SimpleOpenNI initialized and sensor is connected!");
  }

  kinect.setMirror(false);
  kinect.enableDepth();
  println("Kinect Depth Max Width:", kinect.depthWidth());
  println("Kinect Depth Max Height:", kinect.depthHeight());

  stroke(255, 255, 255);
  smooth();
  perspective(radians(45), float(width)/float(height), 10, 150000);  
  
  rectMode(CORNERS);
}

void draw()
{   
  kinect.update();

  background(0, 0, 0);

  translate(width / 2, height / 2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoom);

  int[] depthMap = kinect.depthMap();
  int index;

  translate(0, 0, -depthMax);
  stroke(255);

  fill(0, 102, 153, 50);

  PVector[] realWorldMap = kinect.depthMapRealWorld();
                
  /* Draw hand pointcloud */
  beginShape(POINTS);
  for (int y = 0 ; y < kinect.depthHeight() ; y += quality)
  {
    for (int x = 0 ; x < kinect.depthWidth() ; x += quality)
    {
      index = x + y * kinect.depthWidth();
      if (depthMap[index] > 0)
      {                     
        /* Draw the projected points */
        realWorldPoint = realWorldMap[index];
        
        if (realWorldPoint.z > depthMin && realWorldPoint.z < depthMax && (realWorldPoint.y > -100 && realWorldPoint.y < 50))
          vertex(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
      }      
    }

    /* Check if a box is pressed */
    if (side == 1)
    {
      if (realWorldPoint.z < rectangle1.Az && realWorldPoint.z > rectangle1.Bz && realWorldPoint.x < rectangle1.Ax && realWorldPoint.x > rectangle1.Bx)
        rectangle1.tick();
      else if (realWorldPoint.z < rectangle2.Az && realWorldPoint.z > rectangle2.Bz && realWorldPoint.x < rectangle2.Ax && realWorldPoint.x > rectangle2.Bx)
        rectangle2.tick();    
      /*else if (realWorldPoint.z < rectangle51.Az && realWorldPoint.z > rectangle51.Bz && realWorldPoint.x < rectangle51.Ax && realWorldPoint.x > rectangle51.Bx)
        rectangle51.tick(); */ 
    }
    else if (side == 2)
    {
      if (realWorldPoint.z < rectangle3.Az && realWorldPoint.z > rectangle3.Bz && realWorldPoint.x < rectangle3.Ax && realWorldPoint.x > rectangle3.Bx)
        rectangle3.tick();
      else if (realWorldPoint.z < rectangle4.Az && realWorldPoint.z > rectangle4.Bz && realWorldPoint.x < rectangle4.Ax && realWorldPoint.x > rectangle4.Bx)
        rectangle4.tick(); 
      else if (realWorldPoint.z < rectangle51.Az && realWorldPoint.z > rectangle51.Bz && realWorldPoint.x < rectangle51.Ax && realWorldPoint.x > rectangle51.Bx)
        rectangle51.tick();
      else if (realWorldPoint.z < rectangle52.Az && realWorldPoint.z > rectangle52.Bz && realWorldPoint.x < rectangle52.Ax && realWorldPoint.x > rectangle52.Bx)
        rectangle52.tick();
    }
    else if (side == 3)
    {
      if (realWorldPoint.z < rectangle0.Az && realWorldPoint.z > rectangle0.Bz && realWorldPoint.x < rectangle0.Ax && realWorldPoint.x > rectangle0.Bx)
        rectangle0.tick();
      else if (realWorldPoint.z < rectangle51.Az && realWorldPoint.z > rectangle51.Bz && realWorldPoint.x < rectangle51.Ax && realWorldPoint.x > rectangle51.Bx)
        rectangle51.tick();
      else if (realWorldPoint.z < rectangle52.Az && realWorldPoint.z > rectangle52.Bz && realWorldPoint.x < rectangle52.Ax && realWorldPoint.x > rectangle52.Bx)
        rectangle52.tick();
    }
    else if (side == 4)
    {
      if (realWorldPoint.z < rectangle5.Az && realWorldPoint.z > rectangle5.Bz && realWorldPoint.x < rectangle5.Ax && realWorldPoint.x > rectangle5.Bx)
        rectangle5.tick();
      else if (realWorldPoint.z < rectangle6.Az && realWorldPoint.z > rectangle6.Bz && realWorldPoint.x < rectangle6.Ax && realWorldPoint.x > rectangle6.Bx)
        rectangle6.tick();
      else if (realWorldPoint.z < rectangle51.Az && realWorldPoint.z > rectangle51.Bz && realWorldPoint.x < rectangle51.Ax && realWorldPoint.x > rectangle51.Bx)
        rectangle51.tick();
      else if (realWorldPoint.z < rectangle52.Az && realWorldPoint.z > rectangle52.Bz && realWorldPoint.x < rectangle52.Ax && realWorldPoint.x > rectangle52.Bx)
        rectangle52.tick();
    }
    else if (side == 5)
    {
      if (realWorldPoint.z < rectangle7.Az && realWorldPoint.z > rectangle7.Bz && realWorldPoint.x < rectangle7.Ax && realWorldPoint.x > rectangle7.Bx)
        rectangle7.tick();
      else if (realWorldPoint.z < rectangle8.Az && realWorldPoint.z > rectangle8.Bz && realWorldPoint.x < rectangle8.Ax && realWorldPoint.x > rectangle8.Bx)
        rectangle8.tick();            
      else if (realWorldPoint.z < rectangle10.Az && realWorldPoint.z > rectangle10.Bz && realWorldPoint.x < rectangle10.Ax && realWorldPoint.x > rectangle10.Bx)
        rectangle10.tick();            
      else if (realWorldPoint.z < rectangle52.Az && realWorldPoint.z > rectangle52.Bz && realWorldPoint.x < rectangle52.Ax && realWorldPoint.x > rectangle52.Bx)
        rectangle52.tick();
    }
    
  }   
  endShape();

  /* Draw Kinect lines and limits */
  kinect.drawCamFrustum();
  noFill();
  
  /* Draw the outline of all boxes */
  int c;
  
  c = (side == 3) ? 255 : 0;
  stroke(c);
  rectangle0.show();

  c = (side == 1) ? 255 : 0;
  stroke(c);
  rectangle1.show();    
  rectangle2.show();    
  
  c = (side == 2) ? 255 : 0;
  stroke(c);
  rectangle3.show();    
  rectangle4.show();

  c = (side == 4) ? 255 : 0;
  stroke(c);    
  rectangle5.show();
  rectangle6.show();    

  c = (side == 5) ? 255 : 0;
  stroke(c);  
  rectangle7.show();
  rectangle8.show();    
  rectangle10.show();

  stroke(255);  
  rectangle51.show();    
  rectangle52.show();    
}

void keyPressed()
{
  switch(key)
  {
  case 'b':
    println("x: " + realWorldPoint.x  + " Depth: " + realWorldPoint.z);
    break;
  case 's':
    OscMessage msg = new OscMessage("/EAC-COL");
    msg.add(2000);
    oscP5.send(msg, remoteLocation);
    print("Test network message has been sent.\n");
    break;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
     rotY -= 0.1f;
     break;
  case UP:
    if (keyEvent.isShiftDown())
      zoom += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if (keyEvent.isShiftDown())
    {
      zoom -= 0.02f;
      if (zoom < 0.01)
        zoom = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  case SHIFT:
    break;
  }
}

