import processing.video.*;
Movie movie; 
int dotLoc = 25; 
int boxStartY;
boolean isPlaying;

ArrayList blinks; 
float timez; 
float maxTime = 120000; //2 mins
float increment = 1000; 
PFont font; 

import proxml.*; 
proxml.XMLInOut xmlIO; 
proxml.XMLElement xml;
proxml.XMLElement XMLusers;
proxml.XMLElement video; 
proxml.XMLElement newUser;

 proxml.XMLElement userz;
  proxml.XMLElement blinkz;


void setup () {
  size (1000, 500); 
  smooth(); 


  xmlIO = new XMLInOut (this);
  try {
    xmlIO.loadElement ("blinkie.xml");
  }
  catch(Exception e) {
    //if the xml file could not be loaded it has to be created
    xmlEvent(new proxml.XMLElement("users"));
  }


  font = loadFont ("SansSerif-48.vlw");
  blinks = new ArrayList (); 
  smooth(); 
  timez = millis();
  movie = new Movie (this, "pulp.mp4"); 
  movie.loop(); 
  isPlaying = true;
  boxStartY = height - dotLoc*2;

  /*
  newUser = new proxml.XMLElement ("user");
  XMLusers.addChild(newUser);
  */
}


void draw () {
  background (255); 
  textFont (font, 10); 
  timez = millis(); 

  //draw the lines
  for (float i = 0; i < maxTime; i = i+ increment) {
    float loc = map (i, 0, maxTime, 0, width); 
    line (loc, boxStartY, loc, height); 
    text (int(i/increment), loc + 5, height-20 );
  }

  fill (0); 
  image (movie, 0, 0, width/2, height/2); 

  for (int i=0; i<blinks.size(); i++) {  
    //ellipse (i*15, height/2, 10, 10);
    Blink b = (Blink) blinks.get(i); 
    float locTime = map (b.time, 0, maxTime, 0, width); 
    ellipse (locTime, height - dotLoc, 10, 10);
    //line (locTime, 0, locTime, height); 
    println(b.time);
  }
}

//----------------------------------------------------------------------------------

void mouseClicked () {
  addNewBlink(timez);
  saveData(); 
  //saveToDisk();
}

//----------------------------------------------------------------------------------

void keyPressed () {
  if (key == 'p') {
    // toggle pausing
    if (isPlaying) {
      movie.pause();
    } 
    else {
      movie.play();
    }
    isPlaying = !isPlaying;
  } 
  else if (key == 's') {
    // stop playing
    movie.stop();
    isPlaying = false;
  } 
  else if (key == 'n') {
    newUser = new proxml.XMLElement ("user");
    XMLusers.addChild(newUser);
  } 
  else if (key == 'c') {
    clear();
  }
}

//----------------------------------------------------------------------------------
void initXML () {
  /*
  proxml.XMLElement users;
   proxml.XMLElement blink;
   
   for (int i = 0; i < XMLusers.countChildren(); i++) {
   users = XMLusers.getChild(i); 
   for (int j = 0; i < users.countChildren(); j++) {
   blink = users.getChild(j); 
   }
   }
   */
}

//-----------------------------------------------------------------------------------------------------------------------


void addNewBlink (float time) {
  blinks.add (new Blink(time));

  //proxml.XMLElement XMLusers_ = new proxml.XMLElement ("users");
  //XMLusers.addChild (XMLusers_);



  //proXML.XMLElement video = new proXML.XMLElement ("video"); 
  proxml.XMLElement blink = new proxml.XMLElement ("blink"); 
  blink.addAttribute ("time", time);
  newUser.addChild(blink);
}

//-----------------------------------------------------------------------------------------------------------------------

void saveData() {
  xmlIO.saveElement (XMLusers, "blinkie.xml");
}


//-----------------------------------------------------------------------------------------------------------------------

/* called automatically whenever an XML file is loaded */
void xmlEvent(proxml.XMLElement element) {
  XMLusers = element;
  //initXML(); 
  
  proxml.XMLElement[] users = XMLusers.getChildren();
  for (int i = 0; i < users.length;i++) {
    userz = users[i];
    println(userz);
    proxml.XMLElement[] blinks = userz.getChildren();
    for (int j = 0; j < blinks.length; j++) {
    blinkz = blinks[i];
    println(blinkz);
    
    blinkz.getFloatAttribute ("time");     
      
    }

    /*
    String[] users = child.getAttributes();
    for (int j = 0; j<users.length; j++)
    { 
      println (users[j] + " " + child.getAttribute (users[j]));
    }
    */
  }
}
//----------------------------------------------------------------------------------------------------------------------

void movieEvent(Movie m) {
  m.read();
}
//----------------------------------------------------------------------------------------------------------------------
void clear() {

  // create a new empty pulses XML list to overwrite the previous one
  XMLusers = new proxml.XMLElement("blinkie");

  // save the new empty list to disk
  saveData();
}

