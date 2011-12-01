import proxml.*; 
proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList userList = new ArrayList();

PFont font;

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
  
  maxTime = 120000; 
  
  

  
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
  
  for (int i = 0; i < userList.size(); i++) 
  {
    User u = (User) userList.get(i);
    u.display(boxCorY + (30*i));  
  }
 
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

    proxml.XMLElement[] blinks = users[i].getChildren();
    
    for (int j = 0; j < blinks.length; j++) {     
      float blink = blinks[j].getFloatAttribute ("time");
      //add the blink to the arraylist within the arraylist!
      u.blinks.add(blink); 
    }

    // add it to the arraylist
    userList.add(u);
  }
     
}

