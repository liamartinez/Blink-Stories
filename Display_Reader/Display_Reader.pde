import processing.pdf.*;




Frame[] frame = new Frame [3000]; 
PImage [] mermaid = new PImage[3000]; 
int timeInc; 

int laki = 100; 
int lakiY = 140; 
int increment; 
int distance; 


import proxml.*; 
proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList userList = new ArrayList();

PFont font;
int userColor; 
int count; 

int boxCorX, boxCorY; 
int boxWidth, boxHeight; 
int topBorder, sideBorder; 
int boxEndX, boxEndY; 

float maxTime; 

//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (1350, 1800); 
  smooth(); 

  //noLoop();
  //beginRecord(PDF, "littlemermaid.pdf"); 

  timeInc = 30; 
  increment = 0; 
  distance = 0;   

  for (int i = 0; i < mermaid.length; i= i+timeInc) {
    //String imageName = "file" + nf(i, 4) + ".jpg"; 
    mermaid[i] = loadImage ("littlemermaid/file" + nf(i, 4) + ".jpg");
    frame[i] = new Frame(); 
    frame[i].framePic = mermaid[i]; 
    frame[i].frameNum = i;
    // println (i);
  }
  fill(255); 
  //ellipse (height/2, 0, 100, 100);
  font = loadFont ("SansSerif-48.vlw");

  sideBorder = width/15; 
  topBorder = height/8; 
  boxCorX = sideBorder;
  boxCorY = topBorder;  
  boxWidth = width - sideBorder * 2; 
  boxHeight = height - topBorder * 2; 

  count = 1; 

  maxTime = 500; 

  xmlIO = new XMLInOut (this);
  try {
    xmlIO.loadElement ("blinkie.xml");
  } 
  catch (Exception e) {
    println ("there is no XML");
  }
}

//-----------------------------------------------------------------------------------------------------------------------

void draw () {
  background (255); 

  for (int i=0; i< mermaid.length; i=i + timeInc) {                                //loop through the frames
    int imageLoc = int(map (i, 0, mermaid.length, 0, width*10));  

    //println (i); 

    /*
    for (int q = 0; q < userList.size(); q++)                                       //loop through the users
     {
     User u = (User) userList.get(q);
     
     //println ("clip size: " + u.clips.size()); 
     for (int c = 0; c < u.clips.size(); c++) {
     */

    ArrayList clips2 = getClips(2);
    for (int j = 0; j < clips2.size(); j++) {
      Clip c2 = (Clip) clips2.get(j); 

      for (int k = 0; k< c2.blinks.size(); k++) {
        float blinkNum = (Float) c2.blinks.get(k);

        if (blinkNum >= i-20 && blinkNum <= i+20) {
          //distance = distance + 20; 
          //frame[i].imageTint = 100; 
          //println(frame[i].imageTint);
          if(j == 0){
            frame[i].user1Blinked = true;
          }
          
          if(j == 1){
                      frame[i].user2Blinked = true;

          }
          
        //  println ("frame number " + i + "blinkNum " + blinkNum + " MATCH! "); 
        } 
       // else {
          //distance = distance + 0;
        //  frame[i].imageTint = 255; 
          //println ("frame number " + i + "blinkNum " + blinkNum);
        //}

/*
        increment = increment + distance; 
        frame[i].imageDistance = distance; 
        if (frame[i].imageIncrement == 0) frame[i].imageIncrement = increment; 

        println ("------------ ACTUAL DISTANCE IS: " + frame[i].imageDistance + "---------"); //distance, check!

        

         */
      }
      //distance = 0;
    } 
 
    frame[i].imageX = imageLoc;
    frame[i].display(laki); //laki is "size" in tagalog
  }

  //endRecord();
}


//-----------------------------------------------------------------------------------------------------------------------

ArrayList getClips(int num)
{
  ArrayList clips = new ArrayList();
  for (int i = 0; i < userList.size(); i++) {
    User u = (User) userList.get(i);
    for (int j = 0; j < u.clips.size(); j++) {
      Clip c = (Clip) u.clips.get(j); 
      if (c.num == num) {
      clips.add(c);

      }
    }
  } 
    
  return clips;
}



//-----------------------------------------------------------------------------------------------------------------------

/* called automatically whenever an XML file is loaded */
void xmlEvent(proxml.XMLElement element) {
  XMLusers = element;
  //initXML(); 

  proxml.XMLElement[] users = XMLusers.getChildren();

  for (int i = 0; i < users.length;i++) 
  {

    User u = new User();
    println ("------new user------");

    proxml.XMLElement[] clips = users[i].getChildren(); 
    for (int j = 0; j < clips.length; j++) {  
      Clip c = new Clip();    
      c.num = clips[j].getIntAttribute ("num"); 
      println ("--new clip -- " + c.num); 


      proxml.XMLElement[] blinks = clips[j].getChildren(); 
      for (int q = 0; q < blinks.length; q++) {  

        float blink = blinks[q].getFloatAttribute ("time");
        println ("blink: " + blink); 
        //add the blink to the arraylist within the arraylist!
        c.blinks.add(blink);
      }

      u.clips.add(c);
    }
    // add it to the arraylist
    userList.add(u);
  }
}

