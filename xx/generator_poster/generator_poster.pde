
/*

Generator_Poster
generates posters for Blink Stories

liamartinez.com

*/

import processing.pdf.*;

boolean recording;
PGraphicsPDF pdf;

Frame[] frame = new Frame [2000]; 
PImage [] pictures = new PImage[2000]; 

int timeInc; 
int cols; 
int lakiY = 90; 
int laki = 130; 
int blinkDistance; 
int clipNum; 


import proxml.*; 
proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList userList = new ArrayList();



//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (1350, 1800); 
  smooth(); 

  timeInc = 20; 
  blinkDistance = 1; 
  clipNum = 3; 

  cols = (pictures.length/(width/laki))/timeInc; 

  for (int i = 0; i < pictures.length; i= i+timeInc) {
    pictures[i] = loadImage ("apocalypse/AN" + nf(i, 4) + ".jpg");
    frame[i] = new Frame(); 
    frame[i].framePic = pictures[i]; 
    frame[i].frameNum = i;
    println ("loading " + frame[i].frameNum);
  }
  fill(255); 

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
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "poster.pdf");
  beginRecord(pdf);

  for (int i=0; i< pictures.length; i=i + timeInc) {                                //loop through the frames
    int imageLoc = int(map (i, 0, pictures.length, 0, width*cols));  //this was 10 when inc was 30

    ArrayList clips1 = getClips(clipNum);
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

        c.blinks.add(blink);
      }

      u.clips.add(c);
    }
    // add it to the arraylist
    userList.add(u);
  }
}


