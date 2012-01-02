class Clip {

  ArrayList blinks = new ArrayList(); 
  int locY; 
  float blinkTime;
  int num;
  int colorUser; 
  int whichUser; 

  Clip () {
  }

  void display() {

    ellipse (50 + (whichUser*50), height - height/4, 30, 30); 

  }
}

