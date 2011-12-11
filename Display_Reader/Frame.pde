class Frame {

  PImage framePic; 
  int frameX, frameY; 
  int imageX;
  int imageRow = 1; 
  int imageInit; 

  Frame () {
    
  }

  void display (int laki) {
 
    imageRow = imageX/width; 
    imageX = imageX - (width*imageRow);
    image (framePic, imageX, imageRow*laki, lakiY, laki); 

  }
}


