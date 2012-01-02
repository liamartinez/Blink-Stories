class Frame {

  PImage framePic; 

  int imageX;
  int imageRow = 1; 
  int imageTint = 255; 

  ArrayList userBlinked = new ArrayList(); 

  int frameNum;

  Frame () {

  }

  void display (int totalClips) {

    imageRow = imageX/width; 
    imageX = imageX - (width*imageRow);

    float tintVal = map(userBlinked.size(), 0, totalClips -1, 255, 0);
    tintVal = constrain(tintVal, 0, 255);
    tint(tintVal);
    image (framePic, imageX, imageRow*lakiY, laki, lakiY); // "laki" is size
  }
}
