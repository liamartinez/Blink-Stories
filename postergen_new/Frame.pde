class Frame {
  PImage framePic; 
  int frameNum; 
  int imageX;
  int imageRow = 1; 
  
  Frame () {
  
  
  }

  void display () {

    frameNum = frameNum/width; 
    frameNum = frameNum - (width*imageRow);
    image (framePic, frameNum, imageRow*130, 90, 130); // "laki" is size
  }

}
