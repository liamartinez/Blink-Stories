import processing.core.*; 

import processing.video.*; 
import hypermedia.video.*; 
import java.awt.Rectangle; 
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

public class blink_with_opencv extends PApplet {


            
       

 

OpenCV opencv;                    
Movie movie; 
PImage movementImg;   
PImage cropImg; 
int dotLoc = 25; 
int boxStartY;
boolean isPlaying;

ArrayList blinks; 
Graph graph; 
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
int oldTime; 
int totalPixels; 
int interval = 20; 
int thresh = 35; 
int cvWidth = 320;
int cvHeight = 240; 

//----------------------------------------------------------------------------------

public void setup () {
  size (1000, 500); 
  smooth(); 

  opencv = new OpenCV( this );   
  opencv.capture( cvWidth, cvHeight );     
  movementImg = new PImage( cvWidth, cvHeight ); 
  cropImg = new PImage (cvWidth, cvHeight); 

  opencv.cascade( "haarcascade_frontaleyes.xml" ); //eyes, eyeright, frontaleyes

  xmlIO = new XMLInOut (this);
  try {
    xmlIO.loadElement ("blinkie.xml");
  }
  catch(Exception e) {
    xmlEvent(new proxml.XMLElement("users"));
  }

  font = loadFont ("SansSerif-48.vlw");
  blinks = new ArrayList (); 
  graph = new Graph(); 
  smooth(); 
  timez = millis();
  movie = new Movie (this, "pulp.mp4"); 

  movie.play();
  movie.goToBeginning();
  movie.pause();

  isPlaying = false;
  boxStartY = height - dotLoc*2;
  oldTime = 0; 

  newUser = new proxml.XMLElement ("user");
  XMLusers.addChild(newUser);

  totalPixels = 0;
}

//----------------------------------------------------------------------------------

public void draw () {
  background (255); 
  textFont (font, 10); 

  //--------------------------------------------------


  opencv.read();                  

  Rectangle[] faces = opencv.detect( 1.2f, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  image( opencv.image(), 0, 0 );  //  Display the difference image

  opencv.absDiff();                           //  Creates a difference image
  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(thresh);                       //  Thresholds to convert to black and white
  movementImg = opencv.image();               //  Puts the OpenCV buffer into an image object

  // draw face area(s)
  noFill();  
  stroke(255, 0, 0);

  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );    // draw the rectangle

    for (int x = faces[i].x; x < (faces[i].x+faces[i].width); x++) {      //loop through 
      for (int y = faces[i].y; y < (faces[i].y + faces[i].height); y++) {

        //cropImg = get (faces[i].x, faces[i].y, faces[i].width, faces[i].height); 


        if (isPlaying) {           
          if (blinkTime != oldTime && blinkTime - oldTime > interval) {
            //        if (brightness(movementImg.pixels[x+(y*cvWidth)]) > 230) {  //if brightness is higher
            if (brightness(movementImg.pixels[x+(y*movementImg.width)]) > 230) {  //if brightness is higher
              totalPixels++;
            }

            if (totalPixels >20) {
              addNewBlink(blinkTime);
              saveData();
              oldTime = blinkTime;  
              totalPixels = 0; 

              fill (255, 0, 0); 
              ellipse (width/2 - 40, height/2 - 100, 30, 30);
              println ("MARKER " + blinkTime);

            }
          }
        }
      }
    }
  }

  opencv.remember(OpenCV.SOURCE);

  //--------------------------------------------------

  //draw the movie to watch
  image (movie, (width-movie.width) - 20, 0, width/2, height/2); 

  //get blinktime
  blinkTime = getFrame();

  graph.drawLines(); 
  graph.drawText(); 
  graph.drawMarks();
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

//----------------------------------------------------------------------------------------------------------------


public void stop() {
  opencv.stop();
  super.stop();
}

class Blink {

float time; 
  
Blink (float x) {
time = x;
}



}
class Graph {

  Graph () {
  }  


  public void drawLines () {

    for (float i = 0; i < getLength(); i = i+ 50) {
      float loc = map (i, 0, getLength(), 50, width-50); 
      line (loc, boxStartY, loc, height-20);
    }
  }

  public void drawText () {
    fill (0); 
    textSize (15); 
    text("frame: " + " " + getFrame() + " / " + (getLength() - 1), width/2 + width/8, height/2+40);
    text ("Press P to play and pause", width/2 + width/8, height/2 + 60); 
    text ("Press N to for a new user", width/2 + width/8, height/2 + 80); 
    text ("mousebutton for Blink", width/2 + width/8, height/2 + 100);
  }

  public void drawMarks () {

    for (int i=0; i<blinks.size(); i++) {  
      //ellipse (i*15, height/2, 10, 10);
      Blink b = (Blink) blinks.get(i); 
      float locTime = map (b.time, 0, getLength(), 50, width-50); 
      noStroke(); 
      ellipse (locTime, height - dotLoc, 4, 4);
      //line (locTime, 0, locTime, height); 
     
    }
  }
}



  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "blink_with_opencv" });
  }
}
