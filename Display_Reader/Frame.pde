class Frame {

  PImage framePic; 
  int frameX, frameY; 
  int imageDistance;
  int imageIncrement; 
  int imageLocation; 
  int imageX;
  int imageRow = 1; 
  int imageInit;
  int imageTint = 255; 
  float totalBlinks; 

  boolean slot1empty, slot2empty, slot3empty;

  ArrayList userBlinked = new ArrayList(); 
  ArrayList numBlinked = new ArrayList(); 
  //boolean [] blinked; 
  boolean user1Blinked;
  boolean user2Blinked;

  int frameNum;

  boolean returnValue = false; 

  Frame () {
    imageIncrement = 0;
    slot1empty = true; 
    slot2empty = true; 
    slot3empty = true; 
    //imageTint = 255;
  }

  void display () {

    //imageX = imageLocation + (imageIncrement + imageDistance); 
    imageRow = imageX/width; 
    imageX = imageX - (width*imageRow);
    tint (imageTint); 
    image (framePic, imageX, imageRow*lakiY, laki, lakiY); // "laki" is size 
 

    pushMatrix();
    translate(imageX, imageRow*lakiY);
    fill(255);
    //text(frameNum, 0, 10);

    /*
    if(user1Blinked){
     imageTint = 100; 
     fill(255,0,0);
     ellipse(50,50,10,10);
     }
     
     if(user2Blinked){
     fill(0,255,0);
     ellipse(80,80,20,20);
     }
     */
    for (int i = 0; i < userBlinked.size(); i++) {
      float userBlink = (Float) userBlinked.get(i);


      /*
      for (int j = 0; j < numBlinked.size(); j++) {   
        float numBlinks = (Float) numBlinked.get(i);
        totalBlinks += numBlinks; 
        text ((int)numBlinks, 0+(userBlink*10), 80);
      }
      */
      //println ("userblink " + userBlink); 
      fill (0, 0, 0); 
      
      rect (0, (lakiY - lakiY/6)-((lakiY/6)*(userBlink)),laki,laki/6); 
      tint (imageTint-200); 
      image (framePic, 0, 0, laki, lakiY);
      ellipse (80+(userBlink*10), 80, 20, 20);

      

//      else {
//      rect (0, (lakiY - lakiY/6)-((lakiY/6)*(4)),laki,laki/6); 
//      } 
      
      
      //image (framePic, imageX, imageRow*lakiY, laki, lakiY); // "laki" is size 
      
    }    
    

    popMatrix();
    //if (imageDistance != 0) ellipse (imageX, imageRow*laki, 40, 40);
  }
}

