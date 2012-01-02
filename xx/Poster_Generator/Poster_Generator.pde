import processing.pdf.*;

boolean recording;
PGraphicsPDF pdf;


// 1 = 3820
// 2 = 1100
// 3 = 2600
// 4 = 1700

PImage [] pictures = new PImage[3800]; //FORMULA = total/increment/10 (columns)  = rows
Frame[] frame = new Frame [pictures.length]; 

int timeInc; 
int rows; 

int lakiY = 70; 
int laki = 130; 
int increment; 
int distance; 
int blinkDistance; 

String postername; 
int posterClip; 

import proxml.*; 
proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList userList = new ArrayList();

PFont font;

float maxTime; 

//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (1350, 1800); 
  smooth(); 
 

  // 1 = 19; 3 = 10; 
  timeInc = 19; //old one was 30 
  // 1 = 20; 3 = 20; 
  //rows = 20; 
  rows = (pictures.length/timeInc)/(width/laki);
  blinkDistance = 3;  
  postername = "poster_mermaid.pdf"; 
  posterClip = 1; 

  for (int i = 0; i < pictures.length; i= i+timeInc) {

    pictures[i] = loadImage ("1/Mermaid_" + nf(i, 4) + ".jpg"); 
    frame[i] = new Frame(); 
    frame[i].framePic = pictures[i]; 
    frame[i].frameNum = i;
    println ("loading ..." + i); 

  }
  fill(255); 
  //ellipse (height/2, 0, 100, 100);
  font = loadFont ("SansSerif-48.vlw");


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
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, postername);
  beginRecord(pdf);

  for (int i=0; i< pictures.length; i=i + timeInc) {                                //loop through the frames
    int imageLoc = int(map (i, 0, pictures.length, 0, width*rows));  //this was 10 when inc was 30

    ArrayList clips1 = getClips(posterClip);
    for (int j = 0; j < clips1.size(); j++) {
      Clip c1 = (Clip) clips1.get(j); 

      for (int k = 0; k< c1.blinks.size(); k++) {
        float blinkNum = (Float) c1.blinks.get(k);

        if (blinkNum >= i-blinkDistance && blinkNum <= i+blinkDistance) {
         
          frame[i].userBlinked.add((float)j); 
          
        } 
      }
    } 
 
    frame[i].imageX = imageLoc;
    frame[i].display(clips1.size()); //laki is "size" in tagalog
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


