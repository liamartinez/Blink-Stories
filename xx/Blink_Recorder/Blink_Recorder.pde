
/*

Blink Recorder
records the blinks for Blink Stories

liamartinez.com

*/

import processing.video.*;            
import hypermedia.video.*;       
import java.awt.Rectangle;
import proxml.*; 

OpenCV opencv;                    
Movie movie; 
PImage movementImg;   
PImage cropImg; 
int dotLoc = 25; 
int boxStartY;
boolean isPlaying;

boolean loaded; 
boolean debugOn;

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
proxml.XMLElement newClip; 

int userNum; 
int state; 

Clip clip; 

int blinkTime; 
int oldTime; 
int totalPixels; 
int interval = 10; 
int thresh = 15; 
int cvWidth = 320;
int cvHeight = 240; 

//----------------------------------------------------------------------------------

void setup () {
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

  clip = new Clip(); 
  font = loadFont ("SansSerif-48.vlw");
  blinks = new ArrayList (); 

  graph = new Graph(); 
  timez = millis();

  isPlaying = false;
  loaded = false; 
  boxStartY = height - dotLoc*2;
  oldTime = 0; 
  totalPixels = 0;

  newUser = new proxml.XMLElement ("user");
  userNum++;
  newUser.addAttribute ("num", userNum); 
  XMLusers.addChild(newUser);
}

//----------------------------------------------------------------------------------

void draw () {
  background (0); 
  textFont (font, 10); 

  switch (state) {
  case 0:
    startUp(); 
    break;

  case 1:
    //selection screen
    selectScreen(); 

    break;

  case 2:
    //play movie
    textAlign (CENTER); 
    fill (200); 
    textSize (15); 


    readBlinks(); 

    if (loaded) {
      clip.play(movie); 
      blinkTime = clip.getFrame(movie);
    }

    if (debugOn) debug(); 

    if (clip.getFrame(movie) > clip.getLength(movie) - 10) {
      text ("The End. To return to the selection screen, press the SpaceBar.", width/2, height - 40);
    } 
    else {
      text ("Press P to Play or Pause anytime.", width/2, height - 40);
    }

    break;
  }
}

//----------------------------------------------------------------------------------

void mouseClicked () {
  addNewBlink(blinkTime);
  //addNewBlink (timez); 
  saveData(); 
  //saveToDisk();
}

//----------------------------------------------------------------------------------

void keyPressed () {

  if (key == ' ') {
    if (state < 1) {
      state ++;
    } 
    else if (state == 2) {
      state = 1;
    }
  }

  else if (key == 'p') {
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
  else if (key == 'u') {
    newUser = new proxml.XMLElement ("user");
    userNum ++; 
    newUser.addAttribute ("num", userNum); 
    XMLusers.addChild(newUser);

  } else if (key == '0') {
   state = 0; 
  }
  
  else if (key == 'X') {
    clear();
  } 

  else if (key == 'd') { //debug mode
    if (!debugOn) {
      debugOn = true;
    } 
    else {
      debugOn = false;
    }
  }

  else if (key == '1') {
    if (loaded) movie.pause(); 
    movie = new Movie (this, "lilmermaid.mp4"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded Little Mermaid"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "1");
    newUser.addChild(newClip);
    state = 2;
  }
  else if (key == '2') {
    if (loaded) movie.pause(); 
    movie = new Movie (this, "pulp.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded Pulp Fiction"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "2");
    newUser.addChild(newClip);
    state = 2;
  }
  else if (key == '3') {
    if (loaded) movie.pause(); 
    movie = new Movie (this, "aplocalypse.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded Apocalypse Now"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "3");
    newUser.addChild(newClip);
    state = 2;
  }

  else if (key == '4') {
    if (loaded) movie.pause(); 
    movie = new Movie (this, "jpark.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded Jurassic Park"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "4");
    newUser.addChild(newClip);
    state = 2;
  }
}

//-----------------------------------------------------------------------------------------------------------------------

void addNewBlink (float time) {
  blinks.add (new Blink(time));

  proxml.XMLElement blink = new proxml.XMLElement ("blink"); 
  blink.addAttribute ("time", time);
  newClip.addChild(blink); 
  //newUser.addChild(blink);
}
//-----------------------------------------------------------------------------------------------------------------------

void saveData() {
  xmlIO.saveElement (XMLusers, "blinkie.xml");
}

//-----------------------------------------------------------------------------------------------------------------------

/* called automatically whenever an XML file is loaded */
void xmlEvent(proxml.XMLElement element) {
  XMLusers = element;

  proxml.XMLElement[] users = XMLusers.getChildren();
  userNum = users.length;
  println ("User Size: " + users.length);
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
//----------------------------------------------------------------------------------------------------------------

void readBlinks() {
  opencv.read();                  

  Rectangle[] faces = opencv.detect( 1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  if (debugOn) image( opencv.image(), 0, 0 );  //  Display the difference image

  opencv.absDiff();                           //  Creates a difference image
  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(thresh);                       //  Thresholds to convert to black and white
  movementImg = opencv.image();               //  Puts the OpenCV buffer into an image object

  // draw face area(s)
  noFill();  
  stroke(255, 0, 0);

  for ( int i=0; i<faces.length; i++ ) {
    if (debugOn) rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );    // draw the rectangle

    for (int x = faces[i].x; x < (faces[i].x+faces[i].width); x++) {      //loop through 
      for (int y = faces[i].y; y < (faces[i].y + faces[i].height); y++) {

        if (isPlaying) {           
          if (blinkTime != oldTime && blinkTime - oldTime > interval) {
            if (brightness(movementImg.pixels[x+(y*movementImg.width)]) > 230) {  //if brightness is higher
              totalPixels++;
            }

            if (totalPixels >10) {
              addNewBlink(blinkTime);
              saveData();
              oldTime = blinkTime;  
              totalPixels = 0; 

              if (debugOn) fill (255, 0, 0); 
              if (debugOn) ellipse (100, height/2 - 100, 30, 30);
              println ("MARKER " + blinkTime);
            }
          }
        }
      }
    }
  }
  opencv.remember(OpenCV.SOURCE);
}


//----------------------------------------------------------------------------------------------------------------

void debug () {

  graph.drawLines(); 
  graph.drawText(); 
  graph.drawMarks();
}


//---------------------------------------------------------------------------------------------------------------

void startUp () {

  opencv.read();                  
  Rectangle[] faces = opencv.detect( 1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  pushMatrix(); 
  translate (width/2 - opencv.image().width/2, height/2 - opencv.image().height); 
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


        if (brightness(movementImg.pixels[x+(y*movementImg.width)]) > 230) {  //if brightness is higher
          println ("MOVE"); 
          totalPixels++;
        }

        if (totalPixels >10) {
          totalPixels = 0; 

          fill (255, 0, 0); 
          ellipse (50, 200, 30, 30);
          println ("TEST BLINK " + blinkTime);
        }
      }
    }
  }
  popMatrix(); 
  opencv.remember(OpenCV.SOURCE);

  textAlign (CENTER); 
  fill (200); 
  textSize (15); 
  text ("The red dot blinks when you blink.", width/2, height/2 + 30);
  text ("If you feel like your blinks aren't getting detected, make sure your entire face is seen", width/2, height/2 + 50); 
  text ("and the room you are in is well-lit.", width/2, height/2 + 70); 
  text ("Remember, try not to move your head at all while watching the clip.", width/2, height/2 + 90); 
  textSize (20); 
  text ("When you are ready to start, press the spacebar.", width/2, height/2 + 190);
  textSize (10);
  text ("New User? Press U.", width/2, height/2 + 210);
}

//----------------------------------------------------------------------------------------------------------------
void selectScreen() {
  textAlign (CENTER); 
  fill (200); 
  textSize (15); 
  text ("What would you like to watch?", width/2, height/2 - 200);
  text ("You can watch as many as you like, just not the same clip twice.", width/2, height/2 - 180);
  text ("All the clips are around 2 mins long.", width/2, height/2 - 150);

  text ("Press 1 to watch clip from The Little Mermaid", width/2, height/2 - 130);
  text ("Press 2 to watch clip from Pulp Fiction", width/2, height/2 - 110);
  text ("Press 3 to watch clip from Apocalypse Now", width/2, height/2 - 90);
  text ("Press 4 to watch clip from Jurassic Park", width/2, height/2 - 70);

  text ("To go back to the calibration screen, press 0", width/2, height/2 - 40);
}

//----------------------------------------------------------------------------------------------------------------


public void stop() {
  opencv.stop();
  super.stop();
}

