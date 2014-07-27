/*   File    : EAC Columbus Corridor Display-Receiver
 *   Version : 1.0.0
 *   Update  : 28/04/2014
 *   Authors : Nelson Steinmetz (nelsonsteinmetz@gmail.com),
 *             Alexandros M. Cardaris (alexandros@cardaris.gr)
 *   Company : European Space Agency - EAC
 *   Credits : Andreas Schlegel (oscP5sendreceive)
 */

// IMPORTANT NOTE: Run DisplayerReceiver First!

import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

PImage[] images;
Movie[] transitions;
Movie[] floatObjects;
int currentBackground = 0;

/* Free floating elements */
int floatX, floatY, directionX, directionY;
boolean activateFreeFloaters;

int message;
ReturnMessage objectState;

/* Textbox type objects are declared and initialized */

Textbox textbox0, textbox1, textbox2, textbox3, textbox4, textbox5, textbox6, textbox7, textbox8;
Gallery gallery10;
FreeFloatingAnims screwdriver;

void setup()
{
  size(878, 768);
  oscP5 = new OscP5(this, 12000);
  
  images = new PImage[5];
  images[0] = loadImage("F1F2.jpg");
  images[1] = loadImage("F3F4.jpg");
  images[2] = loadImage("S1.jpg");
  images[3] = loadImage("A4A3.jpg");
  images[4] = loadImage("A2A1.jpg");

  transitions = new Movie[8];
  transitions[0] = new Movie(this, "FrontToFront.mp4");
  transitions[1] = new Movie(this, "FrontToFront_rev.mp4");
  transitions[2] = new Movie(this, "FrontToStarboard.mp4");
  transitions[3] = new Movie(this, "FrontToStarboard_rev.mp4");
  transitions[4] = new Movie(this, "StarboardToAft.mp4");
  transitions[5] = new Movie(this, "StarboardToAft_rev.mp4");
  transitions[6] = new Movie(this, "AftToAft.mp4");
  transitions[7] = new Movie(this, "AftToAft_rev.mp4");

  floatObjects = new Movie[2];
  floatObjects[0] = new Movie(this, "screwdriver.mov");
  floatObjects[1] = new Movie(this, "screwdriver_a.mov");

  frameRate(30);
  
  objectState = ReturnMessage.Completed;
  textbox1 = new Textbox(246, 330, ObjectOrientation.UpperLeft, "ESA EDR", "The European Drawer Rack is a Multi-discipline flexible experiment carrier designed to host medium-sized, dedicated experiment equipment for space research.");
  textbox2 = new Textbox(650, 388, ObjectOrientation.UpperRight, "NASA GloveBox", "The Microgravity Science Glovebox allows astronauts to perform a wide range of experiments in a fully sealed and controlled environment.");
  textbox3 = new Textbox(206, 408, ObjectOrientation.BottomRight, "ESA MARES", "The Muscle Atrophy Research and Exercise System is a general-purpose instrument intended for (neuro-) muscular and exercise research on the ISS (absent here).");
  textbox4 = new Textbox(630, 535, ObjectOrientation.BottomLeft, "Commemorative plates", "These two metal sheets show the signature of all the European engineers who participated in the making of the Columbus Module.");

  textbox0 = new Textbox(436, 410, ObjectOrientation.UpperLeft, "Starboard Cone", "At the end of the Columbus module, on the starboard side, is located a concave cone, usually used for storage.");

  textbox5 = new Textbox(229, 440, ObjectOrientation.UpperRight, "PAYLOAD STORAGE", "This Rack is used to store various equipement. Storage is an important issue aboard the Station but several systems allow tracking and efficieny in item stowage.");
  textbox6 = new Textbox(617, 480, ObjectOrientation.UpperLeft, "ESA EPM", "The European Physiology Modules are an International Standard Payload Rack, equipped with Modules to investigate the effects of long-duration spaceflight on the human body.");
  textbox7 = new Textbox(325, 375, ObjectOrientation.UpperRight, "ESA BIOLAB", "The Biolab Rack supports biological experiments on micro-organisms, cells, tissue cultures, small plants and small invertebrates.");
  textbox8 = new Textbox(620, 400, ObjectOrientation.UpperLeft, "NASA EXPRESS 2", "Columbus hosts several international payloads, such as the NASA Express Racks. Training for these payloads are performed at NASA.");
  gallery10 = new Gallery(630, 210, ObjectOrientation.UpperLeft, "LucaGallery", "Pictures of Astronaut Luca Parmitano operating the BioLab Centrifuge");
  
  screwdriver = new FreeFloatingAnims();
  
  randomObject();
}

void draw()
{
  /* Message event decoding and appear the appropriate objects */

  /* Scenes */
 
  if (message == 1051)
    moving(0, 1);
  else if (message == 1052)
    moving(1, 0);
  else if (message == 1053)
    moving(2, 2);
  else if (message == 1054)
    moving(3, 1);
  else if (message == 1055)
    moving(4, 3);
  else if (message == 1056)
    moving(5, 2);
  else if (message == 1057)
    moving(6, 4);
  else if (message == 1058)
    moving(7, 3);
  else
    image(images[currentBackground], 0, 0);
  
  /* Objects */

  objectState = textbox1.appear(message == 1001);
  objectState = textbox2.appear(message == 1002);
  objectState = textbox3.appear(message == 1003);
  objectState = textbox4.appear(message == 1004);
  
  objectState = textbox0.appear(message == 1000); // Starboard Cone
  
  objectState = textbox5.appear(message == 1005);
  objectState = textbox6.appear(message == 1006);
  objectState = textbox7.appear(message == 1007);
  objectState = textbox8.appear(message == 1008);
  
  objectState = gallery10.appear(message == 1104 || message == 1105);
  if (message == 1105)
  {
    gallery10.turn();
    message = 1104;
  }
  
  /* Floating Objects */
  if(activateFreeFloaters){
    if(floatX > width*10 || floatX < -2000) randomObject();
    if(floatY > height*10 || floatY < - 2000) randomObject();
    
    floatX += directionX;
    floatY += directionY;
    screwdriver.showObject(floatX/10, floatY/10); //width/2, height/2
  }
}

/* Incoming osc messages are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage)
{
  if (objectState != ReturnMessage.InProgress)
  {
    message = theOscMessage.get(0).intValue();
    if (message == 2000)
     println("Client received a network test message.");
    else
     println("Client received a network message.");
 }

  /* Changing Scenes OSC Messages */ 
  if (message == 1051 && objectState != ReturnMessage.InProgress)
  {
      if (currentBackground == 0) message = 1051;
      else if (currentBackground == 1) message = 1053;
      else if (currentBackground == 2) message = 1055;
      else if (currentBackground == 3) message = 1057;
  }
  else if (message == 1052 && objectState != ReturnMessage.InProgress)
  {
      if (currentBackground == 1) message = 1052;
      else if (currentBackground == 2) message = 1054;
      else if (currentBackground == 3) message = 1056;
      else if (currentBackground == 4) message = 1058;
  }  
}

void randomObject()
{
    directionX = int(random(-10, 10));
    directionY = int(random(-8, 8));
    if(directionX >= 0){
      floatX = -1500;
      directionX = 10;
    }
    if(directionX < 0){
      floatX = width*10;
      directionX = -10;
    }
    floatY = floatY = int(random(100, 700));
    //println(directionX + " directionX");
    //println(directionY + " directionY");
    //println(floatX + " floatX");
    //println(floatY + " floatY");
}

void moving(int videoIndex, int imageIndex)
{
  if (transitions[videoIndex].time() >= transitions[videoIndex].duration())
  {
    message = 0;
    currentBackground = imageIndex;    
    transitions[videoIndex].stop();
  }
  else
  {
    transitions[videoIndex].play();
    image(transitions[videoIndex], 0, 0);
  }  
}

void movieEvent(Movie m)
{
  m.read();
}

void keyPressed()
{
  if (key == '1' && objectState != ReturnMessage.InProgress)
    message = 1001;
  else if (key == '2' && objectState != ReturnMessage.InProgress)
    message = 1002;
  else if (key == '3' && objectState != ReturnMessage.InProgress)
    message = 1003;
  else if (key == '4' && objectState != ReturnMessage.InProgress)
    message = 1004;
  else if (key == '5' && objectState != ReturnMessage.InProgress)
    message = 1005;
  else if (key == '6' && objectState != ReturnMessage.InProgress)
    message = 1006;
  else if (key == '7' && objectState != ReturnMessage.InProgress)
    message = 1007;
  else if (key == '8' && objectState != ReturnMessage.InProgress)
    message = 1008;
  else if (key == '0' && objectState != ReturnMessage.InProgress)
    message = 1000;
    
  else if (key == 'n')
    randomObject();
  else if (key == 'v')
    activateFreeFloaters = !activateFreeFloaters;
  
  
  if (key == CODED)
  {
    if (keyCode == RIGHT && objectState != ReturnMessage.InProgress)
    {
      if (currentBackground == 0) message = 1051;
      else if (currentBackground == 1) message = 1053;
      else if (currentBackground == 2) message = 1055;
      else if (currentBackground == 3) message = 1057;
    }
    else if (keyCode == LEFT && objectState != ReturnMessage.InProgress)
    {
      if (currentBackground == 1) message = 1052;
      else if (currentBackground == 2) message = 1054;
      else if (currentBackground == 3) message = 1056;
      else if (currentBackground == 4) message = 1058;
    }
  }
}
