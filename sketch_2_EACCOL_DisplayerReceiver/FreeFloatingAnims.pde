/*  File    : Textbox Object on Corridor Display-Receiver
 *  Version : 1.0.0
 *  Update  : 28/04/2014
 *  Author  : Alexandros M. Cardaris (alexandros@cardaris.gr)
 *            Nelson Steinmetz (nelsonsteinmetz@gmail.com) 
 *  Company : European Space Agency - EAC
 *  Credits : Moritz221 (https://discussions.zoho.com/processing/user/moritz221)
 *            https://discussions.zoho.com/processing/topic/videos-with-alpha-mask-sync-problem
 */ 

import processing.core.*;
import processing.video.*;

float mov_timespot;
float moviespeed = 0.04;

public class FreeFloatingAnims
{
  
  FreeFloatingAnims()
  {       

  }
  
  public ReturnMessage showObject(int vidX, int vidY)
  {
     floatObjects[0].read();
     floatObjects[1].read();
     floatObjects[0].play();
     floatObjects[1].play();
     floatObjects[0].loop();
     floatObjects[1].loop();
     
     //Sync-er
     if (mov_timespot < floatObjects[0].duration()) {
       mov_timespot += moviespeed;
     } else {
       mov_timespot = 0;
     }
     floatObjects[0].jump(mov_timespot);
     floatObjects[1].jump(mov_timespot);
    
     floatObjects[0].mask(floatObjects[1]);
     image(floatObjects[0], vidX, vidY);   
     
     return ReturnMessage.InProgress;
  }
}
