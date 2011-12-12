class Frame {

  PImage framePic; 
  int frameX, frameY; 
  int imageDistance;
  int imageIncrement; 
  int imageLocation; 
  int imageX;
  int imageRow = 1; 
  int imageInit; 
 // int imageTint = 0; 
  
  boolean user1Blinked;
  boolean user2Blinked;
  
  int frameNum;
  
  boolean returnValue = false; 

  Frame () {
    imageIncrement = 0;
    //imageTint = 255;
  }

  void display (int laki) {

    //imageX = imageLocation + (imageIncrement + imageDistance); 
    imageRow = imageX/width; 
    imageX = imageX - (width*imageRow);
    
    //tint (255,imageTint); 
    image (framePic, imageX, imageRow*laki, lakiY, laki); // "laki" is size 
    pushMatrix();
    translate(imageX, imageRow*laki);
    fill(255);
    text(frameNum, 0, 10);
    
    if(user1Blinked){
      fill(255,0,0);
      ellipse(50,50,10,10);
    }
    
    if(user2Blinked){
      fill(0,255,0);
      ellipse(80,80,20,20);
    }
    
    popMatrix();
    //if (imageDistance != 0) ellipse (imageX, imageRow*laki, 40, 40);
  }
}

