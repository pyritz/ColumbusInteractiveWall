/*  File    : Textbox Object on Corridor Display-Receiver
 *  Version : 1.0.0
 *  Update  : 28/04/2014
 *  Author  : Alexandros M. Cardaris (alexandros@cardaris.gr)
 *  Company : European Space Agency - EAC
 */ 

/*  Useful Notes
 *
 *  this.stage: 0 - Rectangle not shown yet
 *              1 - A side was bounced
 *              2 - Increment animation completed, line appears
 *              3 - Rectangle is ready, text and title appears
 *              4 - Animation completed
 */

import processing.core.*;

public class Textbox
{
  /* -------------------- Class Properties -------------------- */
    
  private int x, y;
  private float oppositeX, oppositeY;

  private int width = 150;
  private int height = 190;
  
  private int textMargin = 5;
  private int lineMargin = 23;
    
  public String title;
  public String text;
  
  private color fontcolor = color (255,255,255);
  private color background = color(0,152,219);

  private int speed = 13;
  private ObjectOrientation animation;
  private boolean bouncingHeight, bouncingWidth;
  
  private int stage, substring;

  PFont esaFont = createFont("NotesESA", 16, true);
  PFont verdanaFont = createFont("Verdana", 16, true);

  
  /* -------------------- Class Functions -------------------- */
  
  Textbox(int x, int y, ObjectOrientation orientation, String title, String text)
  {
    this.x = x;
    this.y = y;
    
    this.animation = orientation;

    this.title = title;
    this.text = text;
    
    this.stage = 0;
    this.bouncingHeight = false;
    this.bouncingWidth = false;
    this.oppositeX = 0;
    this.oppositeY = 0;    
  }
    
  public ReturnMessage appear(boolean state)
  {
    this.boxAnimation(state);
    this.textAnimation(state);

    if (this.stage == 0 || this.stage == 4)
      return ReturnMessage.Completed;
    else
      return ReturnMessage.InProgress;    
  }
      
  private ReturnMessage boxAnimation(boolean shown)
  { 
    /* Set position, background color and other properties of the rectangle per frame */
    
    rectMode(CORNERS);
    fill(this.background);        
    noStroke();

    if (this.animation == ObjectOrientation.UpperLeft)
      rect(this.x + this.lineMargin, this.y + this.lineMargin, this.x + this.lineMargin + this.oppositeX, this.y + this.lineMargin + this.oppositeY);
    else if (this.animation == ObjectOrientation.UpperRight)
      rect(this.x - this.lineMargin, this.y + this.lineMargin, this.x - this.lineMargin - this.oppositeX, this.y + this.lineMargin + this.oppositeY);
    else if (this.animation == ObjectOrientation.BottomLeft)
      rect(this.x - this.lineMargin, this.y - this.lineMargin, this.x - this.lineMargin - this.oppositeX, this.y - this.lineMargin - this.oppositeY);
    else if (this.animation == ObjectOrientation.BottomRight)
      rect(this.x + this.lineMargin, this.y - this.lineMargin, this.x + this.lineMargin + this.oppositeX, this.y - this.lineMargin - this.oppositeY);

    /* Calculate the size of the rectangle per frame and stage */
    
    if (this.stage < 2 && shown == true)
    {      
      /* Bouncing */
      
      if (this.bouncingHeight == true && this.oppositeY > this.height)
      {
          this.oppositeY = this.height;
          this.stage += 1;
      }  

      if (this.bouncingWidth == true && this.oppositeX > this.width)
      {
          this.oppositeX = this.width;
          this.stage += 1;
      }        
      
      /* Increment animation of width & height */
      
      if (this.bouncingHeight == false)
      {      
        if (this.oppositeY <= this.height)
          this.oppositeY += this.speed;
        
        if (this.oppositeY > this.height)
        {
          this.oppositeY = this.height + (this.speed / 1.5);
          this.bouncingHeight = true;
        }
      }   
    
      if (this.bouncingWidth == false)
      {
        if (this.oppositeX <= this.width)
          this.oppositeX += this.speed * 1.5;

        if (this.oppositeX > this.width)
        {
          this.oppositeX = this.width + (this.speed / 1.8);
          this.bouncingWidth = true;
        } 
      }
    }
    
    /* Decrement animation of width & height */
    
    if (this.stage == 2 && shown == false)
    {
        if (this.oppositeY > 0)
          this.oppositeY -= this.speed * 3;
        
        if (this.oppositeY < 0)
          this.oppositeY = 0;
        
        if (this.oppositeX > 0)
          this.oppositeX -= this.speed * 1.5;

        if (this.oppositeX < 0)
          this.oppositeX = 0;
          
        if (this.oppositeX == 0 && this.oppositeY == 0)
        {
          this.stage = 0;
          this.bouncingHeight = false;
          this.bouncingWidth = false;
        }
    }
    
    /* Line appears when increment animation of width & height is completed */

    if (this.stage > 0)
    {
      stroke(this.background);
      
      if (this.animation == ObjectOrientation.UpperLeft)
        line(this.x, this.y, this.x + (this.lineMargin - 3), this.y + (this.lineMargin - 3));
      else if (this.animation == ObjectOrientation.UpperRight)
        line(this.x, this.y, this.x - (this.lineMargin - 3), this.y + (this.lineMargin - 3));
      else if (this.animation == ObjectOrientation.BottomLeft)
        line(this.x, this.y, this.x - (this.lineMargin - 3), this.y - (this.lineMargin - 3));
      else if (this.animation == ObjectOrientation.BottomRight)
        line(this.x, this.y, this.x + (this.lineMargin - 3), this.y - (this.lineMargin - 3));
    }

    return ReturnMessage.Success;    
  }
  
  private ReturnMessage textAnimation(boolean shown)
  { 
    if (this.stage == 2)
    {
      this.stage += 1;
      this.substring = 0;
    }
    else if (this.stage >= 3)
    { 
      int beginIndexTitle = 0 , endIndexTitle = 0;
      int beginIndexText = 0, endIndexText = 0;
      
      if (this.substring >= this.title.length() && this.substring >= this.text.length())
        this.stage = 4;
      else if (this.substring == 0 && shown == false)
        this.stage = 2;
            
      if (shown == true && this.stage == 3)
      {
        this.substring += 6;                  
      }
      else if (shown == false && this.stage == 4)
      {
        this.substring -= 6;
        if (this.substring < 0) this.substring = 0;
      }
                  
      if (this.substring > this.title.length()) endIndexTitle = this.title.length();
      else endIndexTitle = this.substring;
        
      if (this.substring > this.text.length()) endIndexText = this.text.length();
      else endIndexText = this.substring; 
                  
      fill(255);
      stroke(255);

      /* Text and title relative position and size are depended of the parent rectangle */

      if (this.animation == ObjectOrientation.UpperLeft)
      {        
        textFont(esaFont, 14);
        text(this.title.substring(beginIndexTitle, endIndexTitle), this.x + this.lineMargin + this.textMargin, this.y + this.lineMargin + this.textMargin, this.x + this.lineMargin + this.width - this.textMargin, this.y + this.lineMargin + this.height - this.textMargin);
        textFont(verdanaFont, 11);
        text(this.text.substring(beginIndexTitle, endIndexText), this.x + this.lineMargin + this.textMargin, this.y + this.lineMargin + (this.textMargin * 7), this.x + this.lineMargin + this.width - this.textMargin, this.y + this.lineMargin + this.height - this.textMargin);
        if (this.substring >= 10) line(this.x + this.lineMargin + this.textMargin, this.y + this.lineMargin + (this.textMargin * 5), this.x + this.lineMargin + (this.width / 2), this.y + this.lineMargin + (this.textMargin * 5));
      }
      else if (this.animation == ObjectOrientation.UpperRight)
      {
        textFont(esaFont, 14);
        text(this.title.substring(beginIndexTitle, endIndexTitle), this.x - this.lineMargin - this.width + this.textMargin, this.y + this.lineMargin + this.textMargin, this.x - this.lineMargin - this.textMargin, this.y + this.lineMargin + this.height - this.textMargin);
        textFont(verdanaFont, 11);
        text(this.text.substring(0, endIndexText), this.x - this.lineMargin - this.width + this.textMargin, this.y + this.lineMargin + (this.textMargin * 7), this.x - this.lineMargin - this.textMargin, this.y + this.lineMargin + this.height - this.textMargin);
        if (this.substring >= 10) line(this.x - this.lineMargin - this.width + this.textMargin, this.y + this.lineMargin + (this.textMargin * 5), this.x - this.lineMargin - (this.width / 2), this.y + this.lineMargin + (this.textMargin * 5)); 
      }
      else if (this.animation == ObjectOrientation.BottomLeft)
      {
        textFont(esaFont, 14);
        text(this.title.substring(beginIndexTitle, endIndexTitle), this.x - this.lineMargin - this.width + this.textMargin, this.y - this.lineMargin - this.height + this.textMargin, this.x - this.lineMargin - this.textMargin, this.y - this.lineMargin - this.textMargin);
        textFont(verdanaFont, 11);
        text(this.text.substring(beginIndexText, endIndexText), this.x - this.lineMargin - this.width + this.textMargin, this.y - this.lineMargin - this.height + (this.textMargin * 7), this.x - this.lineMargin - this.textMargin, this.y - this.lineMargin - this.textMargin);
        if (this.substring >= 10) line(this.x - this.lineMargin - this.width + this.textMargin, this.y - this.lineMargin - this.height + (this.textMargin * 5), this.x - this.lineMargin - (this.width / 2), this.y - this.lineMargin - this.height + (this.textMargin * 5)); 
      }
      else if (this.animation == ObjectOrientation.BottomRight)
      {
        textFont(esaFont, 14);
        text(this.title.substring(beginIndexTitle, endIndexTitle), this.x + this.lineMargin + this.textMargin, this.y - this.lineMargin - this.height + this.textMargin, this.x + this.lineMargin + this.width - this.textMargin, this.y - this.lineMargin - this.textMargin);
        textFont(verdanaFont, 11);
        text(this.text.substring(beginIndexText, endIndexText), this.x + this.lineMargin + this.textMargin, this.y - this.lineMargin - this.height + (this.textMargin * 7), this.x + this.lineMargin + this.width - this.textMargin, this.y - this.lineMargin - this.textMargin);
        if (this.substring >= 10) line(this.x + this.lineMargin + this.textMargin, this.y - this.lineMargin - this.height + (this.textMargin * 5), this.x + this.lineMargin + (this.width / 2), this.y - this.lineMargin - this.height + (this.textMargin * 5));
      }    
    }
    
    return ReturnMessage.Success;
  }
}
