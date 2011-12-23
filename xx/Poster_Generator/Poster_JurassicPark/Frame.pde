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

    float tintVal = map(userBlinked.size(), 0, 2, 255, 0);
    tintVal = constrain(tintVal, 0, 255);
    println(userBlinked.size() + " " + tintVal);
    //tint (imageTint); 
    tint(tintVal);
    image (framePic, imageX, imageRow*lakiY, laki, lakiY); // "laki" is size
  }
}
