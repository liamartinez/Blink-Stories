import proxml.*; 

proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList<User> userList = new ArrayList();

PFont font;
int wordSize; 
int userColor; 
int count; 
int last; 
int interval; 

int boxCorX, boxCorY; 
int boxWidth, boxHeight; 
int topBorder, sideBorder; 
int boxEndX, boxEndY; 

//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (1300, 500); 
  smooth(); 
  font = loadFont ("SansSerif-48.vlw");

  sideBorder = width/15; 
  topBorder = height/8; 
  boxCorX = sideBorder;
  boxCorY = topBorder;  
  boxWidth = width - sideBorder * 2; 
  boxHeight = height - topBorder * 2; 
  wordSize = 15; 

  count = 1; 



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
  fill (25);
  noStroke(); 
  rect (boxCorX, boxCorY, boxWidth, boxHeight); 

  for (int q = 0; q < userList.size(); q++) {
    User u = (User) userList.get(q); 
    for (int j = 0; j < u.clips.size(); j++) {

      //start little mermaid  
      ArrayList clips1 = getClips(1); 
      for (int i = 0; i< clips1.size(); i++) {
        Clip c1 = (Clip) clips1.get(i);         
        c1.display(boxCorY + wordSize, "The Little Mermaid", 3900);
      }

      //start pulp fiction
      ArrayList clips2 = getClips(2); 
      for (int i = 0; i< clips2.size(); i++) {
        Clip c2 = (Clip) clips2.get(i);         
        c2.display(((boxHeight-boxCorY)/4)*2, "Pulp Fiction", 1200);
      }  

      //start apocalypse now
      ArrayList clips3 = getClips(3); 
      for (int i = 0; i< clips3.size(); i++) {
        Clip c3 = (Clip) clips3.get(i);         
        c3.display(((boxHeight-boxCorY)/4)*3, "Apocalypse Now", 2700);
      }  
      
      //start jurassic park
      ArrayList clips4 = getClips(4); 
      for (int i = 0; i< clips4.size(); i++) {
        Clip c4 = (Clip) clips4.get(i);         
        c4.display(((boxHeight-boxCorY)/4)*4, "Jurassic Park", 1800);
      }
    } // close clips loop
  } // close users loop
}// close draw loop

//-----------------------------------------------------------------------------------------------------------------------

ArrayList getClips(int num)
{
  ArrayList clips = new ArrayList();
  for (int i = 0; i < userList.size(); i++) {
    User u = (User) userList.get(i);
    //println ("NEW USER------------------------ "); 
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

  //create array of proxml elements called "users", get the children
  proxml.XMLElement[] users = XMLusers.getChildren();
  for (int i = 0; i < users.length;i++) 
  {
    User u = new User();
    u.num = users[i].getIntAttribute("num");
    println ("------new user------");

    //create another array of the children of the users
    proxml.XMLElement[] clips = users[i].getChildren(); 
    for (int j = 0; j < clips.length; j++) {  
      Clip c = new Clip();    
      c.whichUser = u.num; 
      c.num = clips[j].getIntAttribute ("num"); 
      println ("--new clip -- " + c.num); 

      //get the blinks within the clip array
      proxml.XMLElement[] blinks = clips[j].getChildren(); 
      for (int q = 0; q < blinks.length; q++) {  

        float blink = blinks[q].getFloatAttribute ("time");
        //add the blink to the arraylist within the arraylist!
        c.blinks.add(blink);
      }
      u.clips.add(c);
    }
    // add it to the arraylist
    userList.add(u);
  }
}


//----------------------------------------------------------------------------------

void keyPressed () {
  
  if (key == 's') {
    save("graph.tiff"); 
  }
  
}

