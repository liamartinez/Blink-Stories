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
    //colorUser = color_; 
    //println ("INSIDE COLOR " + colorUser); 
    for (int i = 0; i < blinks.size(); i++)
    {
      noStroke(); 

      float blinkNum = (Float) blinks.get(i);
      blinkTime = (int)map (blinkNum, 0, maxTime, boxCorX, boxCorX + boxWidth); 
      colorMode (HSB); 
      fill (50+whichUser*50, 230, 255 ); 
      textSize (wordSize); 
      //textFont (font);
      //text ((int)blinkNum, blinkTime + 100, locY);
      //fill (255, colorUser+200, 255); 
      ellipse (blinkTime, locY+10+(whichUser*10), 2, 2);
      fill (200); 
      text (clipName, boxCorX + 10, locY); 

    }
  }
}

