/*  File    : Detectbox Object on Corridor Detector-Sender
 *  Version : 1.0.0
 *  Update  : 02/07/2014
 *  Author  : Alexandros M. Cardaris (alexandros@cardaris.gr)
 *  Company : European Space Agency - EAC
 */ 

import oscP5.*;
import netP5.*;
import processing.core.*;

public class DetectBox
{
  /* --------------- Class Static Configuration --------------- */
  
  private int size = 100;
  
  /* -------------------- Class Properties -------------------- */
  
  // Center coordinates
  private int x;
  private int y;
  private int z;
  
  // A as upper left point  
  private int Ax;
  private int Ay;
  private int Az;
  
  // B as bottom right point
  private int Bx;
  private int By;
  private int Bz;
  
  private int id;
  private int savedTimer = 0;
  private int passedTimer = 01;
  private int counter = 0;
  
  private OscMessage message = new OscMessage("/EAC-COL");

  /* -------------------- Class Functions -------------------- */
  
  public DetectBox(int x, int z, int code)
  {
    this.x = x;
    this.y = this.size;
    this.z = z;
    
    this.Ax = this.x + this.size;
    this.Ay = this.y;
    this.Az = this.z + this.size;
    
    this.Bx = this.x - this.size;
    this.By = this.y;
    this.Bz = this.z - this.size;
    
    this.id = code;
    this.savedTimer = 0;
    this.passedTimer = millis();
    
    this.message.add(code);
  }
  
  public void show()
  {
    translate(this.Bx, 0, this.Az);
    box(abs(this.size));
    translate(-this.Bx, 0, -this.Az);
  }

  public void tick()
  {
    passedTimer = millis() - savedTimer;
   
    if (passedTimer > 1000)
    {
      this.counter++;
      this.savedTimer = millis();
      
      oscP5.send(this.message, remoteLocation);
      
      if (this.id == 1052 && this.id > 1) side--;
      else if (this.id == 1051 && this.id < 5) side++;
      
      println("scene:", side, "id:", this.id, "activated:", this.counter, "timestamp:", hour() + ":" + minute() + ":" + second());
    }    
  }
  
  /* // Old version
  public void tick()
  {
    if (this.timer == 0)
      this.timer = millis();
    
    if (millis() - this.timer >= 1000)
    {
      this.counter++;
      this.timer = 0;
      oscP5.send(this.message, remoteLocation);
      
      if (this.id == 1052 && this.id > 1) side--;
      else if (this.id == 1051 && this.id < 5) side++;
      
      println("scene:", side, "id:", this.id, "activated:", this.counter, "timestamp:", hour() + ":" + minute() + ":" + second());
    }    
  }*/
}
