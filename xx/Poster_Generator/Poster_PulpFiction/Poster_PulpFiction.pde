import processing.pdf.*;

boolean recording;
PGraphicsPDF pdf;

Frame[] frame = new Frame [2000]; 
PImage [] mermaid = new PImage[2000]; 
int timeInc; 
int mapMultiplier; 

int lakiY = 75; 
int laki = 130; 
int increment; 
int distance; 
int blinkDistance; 


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

  //  noLoop();
  //  beginRecord(PDF, "littlemermaid.pdf"); 

  timeInc = 10; //old one was 30 
  mapMultiplier = 20; 
  blinkDistance = 1; 
  increment = 0;  
  distance = 0;   

  for (int i = 0; i < mermaid.length; i= i+timeInc) {
    //String imageName = "file" + nf(i, 4) + ".jpg"; 
    mermaid[i] = loadImage ("Pulp/pulp" + nf(i, 4) + ".jpg");
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
  background (0); 
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "lines.pdf");
  beginRecord(pdf);

  for (int i=0; i< mermaid.length; i=i + timeInc) {                                //loop through the frames
    int imageLoc = int(map (i, 0, mermaid.length, 0, width*mapMultiplier));  //this was 10 when inc was 30

    //println (i); 

    /*
    for (int q = 0; q < userList.size(); q++)                                       //loop through the users
     {
     User u = (User) userList.get(q);
     
     //println ("clip size: " + u.clips.size()); 
     for (int c = 0; c < u.clips.size(); c++) {
     */

    ArrayList clips1 = getClips(4);
    for (int j = 0; j < clips1.size(); j++) {
      Clip c1 = (Clip) clips1.get(j); 

      for (int k = 0; k< c1.blinks.size(); k++) {
        float blinkNum = (Float) c1.blinks.get(k);

        if (blinkNum >= i-blinkDistance && blinkNum <= i+blinkDistance) {


          frame[i].userBlinked.add((float)j); 
          //println (i + " " + frame[i].userBlinked.size()); 
          //frame[i].numBlinked.add((float)1); 



          /*
          if(j == 0){
           frame[i].user1Blinked = true;
           }
           
           if(j == 1){
           frame[i].user2Blinked = true;
           
           }
           */
        }
      }
    } 

    frame[i].imageX = imageLoc;
    frame[i].display(); //laki is "size" in tagalog
  }
  endRecord();
  noLoop();
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
    //println ("------new user------");

    proxml.XMLElement[] clips = users[i].getChildren(); 
    for (int j = 0; j < clips.length; j++) {  
      Clip c = new Clip();    
      c.num = clips[j].getIntAttribute ("num"); 
      println ("--new clip -- " + c.num); 


      proxml.XMLElement[] blinks = clips[j].getChildren(); 
      for (int q = 0; q < blinks.length; q++) {  

        float blink = blinks[q].getFloatAttribute ("time");
        //println ("blink: " + blink); 
        //add the blink to the arraylist within the arraylist!
        c.blinks.add(blink);
      }

      u.clips.add(c);
    }
    // add it to the arraylist
    userList.add(u);
  }
}

//-------------------------------------------------------------------------------------------------
/*void keyPressed() {
 if (key == 'r') {
 if (recording) {
 endRecord();
 println("Recording stopped.");
 recording = false;
 } else {
 beginRecord(pdf);
 println("Recording started.");
 recording = true;
 }
 } else if (key == 'q') {
 if (recording) {
 endRecord();
 }
 exit();
 }  
 }*/
