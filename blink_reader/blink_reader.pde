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
  size (1300, 500); 
  background (150, 150, 150);
  smooth(); 
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
  fill (100);
  rect (boxCorX, boxCorY, boxWidth, boxHeight); 


  for (int q = 0; q < userList.size(); q++) 
  {

    User u = (User) userList.get(q);

    //println ("clip size: " + u.clips.size()); 
    for (int j = 0; j < u.clips.size(); j++) {

      ArrayList clips1 = getClips(1);
      for (int i = 0; i < clips1.size(); i++) {
        Clip c1 = (Clip) clips1.get(i);  
        c1.display(height/2);
      }

      ArrayList clips2 = getClips(2);
      for (int i = 0; i < clips2.size(); i++) {
        Clip c2 = (Clip) clips2.get(i);
        c2.display(height/2 + 50);
      }
    }
  }
}

//-----------------------------------------------------------------------------------------------------------------------

ArrayList getClips(int num)
{
  ArrayList clips = new ArrayList();
  for (int i = 0; i < userList.size(); i++) {
    User u = (User) userList.get(i);
    //println ("NEW USER------------------------ "); 
    for (int j = 0; j < u.clips.size(); j++) {
      //println ("-----new clip----"); 
      Clip c = (Clip) u.clips.get(j); 
      //println ("c.num: " + c.num + " num: "  + num); 
      if (c.num == num) {
        //println ("ADD"); 

        clips.add(c);
        //println ("TOTAL size " + clips.size());
      }
    }
  }
  //println (clips.size() + " is clipsize of " + num); 
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

