import processing.core.*; 

import processing.video.*; 
import proxml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class blink_with_mouse extends PApplet {


Movie movie; 
int dotLoc = 25; 
int boxStartY;
boolean isPlaying;

ArrayList blinks; 
float timez; 
float maxTime = 120000; //2 mins
float increment = 1000; 
PFont font; 

 
proxml.XMLInOut xmlIO; 
proxml.XMLElement xml;
proxml.XMLElement XMLusers;
proxml.XMLElement video; 
proxml.XMLElement newUser;

int blinkTime; 

//----------------------------------------------------------------------------------

public void setup () {
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

  movie.play();
  movie.goToBeginning();
  movie.pause();

  isPlaying = false;
  boxStartY = height - dotLoc*2;

  newUser = new proxml.XMLElement ("user");
  XMLusers.addChild(newUser);
}

//----------------------------------------------------------------------------------

public void draw () {
  background (255); 
  textFont (font, 10); 
  timez = millis(); 

  //text(getFrame() + " / " + (getLength() - 1), 10, 30);
  //draw the lines
  //  for (float i = 0; i < maxTime; i = i+ increment) {
  for (float i = 0; i < getLength(); i = i+ 50) {
    float loc = map (i, 0, getLength(), 50, width-50); 
    line (loc, boxStartY, loc, height-20); 
    /*
    if (loc%50==0) {
      text (int(loc), loc, height-60 );
    }
    */
  }

  fill (0); 
  image (movie, width/10, height/6, width/2, height/2); 
  fill (0); 
  text("frame: " + " " + getFrame() + " / " + (getLength() - 1), width/2 + width/8, height/2);
  text ("Press P to play and pause", width/2 + width/8, height/2 + 20); 
  text ("Press N to for a new user", width/2 + width/8, height/2 + 40); 
  text ("mousebutton for Blink", width/2 + width/8, height/2 + 60); 
  blinkTime = getFrame();

  for (int i=0; i<blinks.size(); i++) {  
    //ellipse (i*15, height/2, 10, 10);
    Blink b = (Blink) blinks.get(i); 
    float locTime = map (b.time, 0, getLength(), 50, width-50); 
    ellipse (locTime, height - dotLoc, 4, 4);
    //line (locTime, 0, locTime, height); 
    println(b.time);
  }
}

//----------------------------------------------------------------------------------

public void mouseClicked () {
  addNewBlink(blinkTime);
  //addNewBlink (timez); 
  saveData(); 
  //saveToDisk();
}

//----------------------------------------------------------------------------------

public void keyPressed () {
  if (key == 'p') {
    // toggle pausing
    if (!isPlaying) {
      movie.play();
    } 
    else {
      movie.pause();
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
public void initXML () {
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

public void addNewBlink (float time) {
  blinks.add (new Blink(time));

  proxml.XMLElement blink = new proxml.XMLElement ("blink"); 
  blink.addAttribute ("time", time);
  newUser.addChild(blink);
}
//-----------------------------------------------------------------------------------------------------------------------

public void saveData() {
  xmlIO.saveElement (XMLusers, "blinkie.xml");
}


//-----------------------------------------------------------------------------------------------------------------------

/* called automatically whenever an XML file is loaded */
public void xmlEvent(proxml.XMLElement element) {
  XMLusers = element;
}
//----------------------------------------------------------------------------------------------------------------------

public void movieEvent(Movie m) {
  m.read();
}
//----------------------------------------------------------------------------------------------------------------------
public void clear() {

  // create a new empty pulses XML list to overwrite the previous one
  XMLusers = new proxml.XMLElement("blinkie");

  // save the new empty list to disk
  saveData();
}
//----------------------------------------------------------------------------------------------------------------

public int getFrame() {    
  return ceil(movie.time() * movie.getSourceFrameRate()) - 1;
}

public void setFrame(int n) {
  movie.play();

  float srcFramerate = movie.getSourceFrameRate();

  // The duration of a single frame:
  float frameDuration = 1.0f / srcFramerate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5f) * frameDuration; 

  // Taking into account border effects:
  float diff = movie.duration() - where;
  if (diff < 0) {
    where += diff - 0.25f * frameDuration;
  }

  movie.jump(where);

  movie.pause();
}  

public int getLength() {
  return PApplet.parseInt(movie.duration() * movie.getSourceFrameRate());
}  

class Blink {

float time; 
  
Blink (float x) {
time = x;
}



}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "blink_with_mouse" });
  }
}
