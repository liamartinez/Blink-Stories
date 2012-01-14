class Frame {

  PImage framePic; 
  int imageX;
  int imageRow = 1; 
  int imageInit;
  int imageTint = 255; 

  ArrayList userBlinked = new ArrayList(); 
  //ArrayList numBlinked = new ArrayList(); 

  int frameNum;

  Frame () {

  }

  void display () {

    imageRow = imageX/width; 
    imageX = imageX - (width*imageRow);

    float tintVal = map(userBlinked.size(), 0, 2, 255, 0);
    tintVal = constrain(tintVal, 0, 255);
    tint(255,tintVal);
    image (framePic, imageX, imageRow*lakiY, laki, lakiY); // "laki" is size
  }
}
