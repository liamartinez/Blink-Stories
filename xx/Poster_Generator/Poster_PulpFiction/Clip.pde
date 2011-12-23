class Clip {

  ArrayList blinks = new ArrayList(); 
  int locY; 
  float blinkTime;
  int num;
  int colorUser; 

  Clip () {
  }

  void display(int locY_ )
  {
    locY = locY_ + 40; 
    //colorUser = color_; 
    //println ("INSIDE COLOR " + colorUser); 
    for (int i = 0; i < blinks.size(); i++)
    {
      noStroke(); 
      textSize (15); 
      text ("CLIPNAME", boxCorX + 50, locY+30); 
      float blinkNum = (Float) blinks.get(i);
      //println ("inside blinknum " + blinkNum); 
      blinkTime = (int)map (blinkNum, 0, maxTime, boxCorX, boxCorX + boxWidth); 
      fill (250); 
      textSize (10); 
      //textFont (font);
      text ((int)blinkNum, blinkTime + 100, locY);
      //fill (255, colorUser+200, 255); 
      ellipse (blinkTime + 100, locY, 7, 7);

    }
  }
}

