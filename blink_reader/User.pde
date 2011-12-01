class User 
{
  int ID;
  ArrayList blinks = new ArrayList(); 
  int locY; 
  float blinkTime; 
  
  User() {
  }
  
  void display(int locY_)
  {
    locY = locY_; 
    
    for(int i = 0; i < blinks.size(); i++)
    {
       float blinkNum = (Float) blinks.get(i);
       blinkTime = map (blinkNum, 0, maxTime, boxCorX, boxCorX + boxWidth); 
       fill (250); 
       ellipse (blinkTime, locY+40, 7, 7); 

    }
  }
  
}

