class User 
{
  int ID;
  int num; 
  //ArrayList blinks = new ArrayList(); 
  ArrayList clips = new ArrayList(); 
  int locY; 
  float clipName;
  int userColour; // user is british
  //float blinkTime; 
  
  User() {

  }
  
 void display()
  {

    
    for(int i = 0; i < clips.size(); i++)
    {
      
      //println (clips.size()); 
      //println((string)clips.get(i)); 
       //String clipNum = (String) clips.get(i);
       // float clipNum =  (Float) clips.get(i);
       /*
       blinkTime = map (blinkNum, 0, maxTime, boxCorX, boxCorX + boxWidth); 
       fill (250); 
       ellipse (blinkTime, locY+40, 7, 7); 
       */

    }
  }
  
}

