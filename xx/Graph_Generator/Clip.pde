class Clip {

  ArrayList blinks = new ArrayList(); 
  int locY; 
  float blinkTime;
  int num;
  int colorUser; 
  int whichUser; 
  String clipName; 
  int maxTime; 

  Clip () {
  }

  void display(int locY_, String clipName_, int maxTime_ )
  {
    locY = locY_; 
    clipName = clipName_;
    maxTime = maxTime_; 
    for (int i = 0; i < blinks.size(); i++)
    {
      noStroke(); 

      float blinkNum = (Float) blinks.get(i);
      blinkTime = (int)map (blinkNum, 0, maxTime, boxCorX, boxCorX + boxWidth); 
      colorMode (HSB); 
      fill (50+whichUser*30, 230, 255 ); 
      textSize (wordSize); 
      ellipse (blinkTime, locY+5+(whichUser*10), 2, 2);
      fill (200); 
      text (clipName, boxCorX + 10, locY);
    }
  }
}

