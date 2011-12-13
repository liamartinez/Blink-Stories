
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

ArrayList blinks; 
/*
ArrayList users; 
 ArrayList clips; 
 */
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
  /*
  users = new ArrayList (); 
   clips = new ArrayList (); 
   */
  graph = new Graph(); 
  smooth(); 
  timez = millis();

  isPlaying = false;
  loaded = false; 
  boxStartY = height - dotLoc*2;
  oldTime = 0; 

  newUser = new proxml.XMLElement ("user");
  XMLusers.addChild(newUser);
  newClip = new proxml.XMLElement ("clip"); 
  newUser.addChild(newClip);

  totalPixels = 0;
  
  if (loaded) {

  }
}

//----------------------------------------------------------------------------------

void draw () {
  background (255); 
  textFont (font, 10); 

  readBlinks(); 

  //draw the movie to watch
  //image (movie, (width-movie.width) - 20, 0, width/2, height/2); 

  if (loaded) {
    clip.play(movie); 
    blinkTime = clip.getFrame(movie);
    //graph.drawLines(); 
    //graph.drawText(); 
    //graph.drawMarks();
  }

  //get blinktime
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
    newUser.addChild(newClip);
  } 
  else if (key == 'c') {
    newClip = new proxml.XMLElement ("clip");
    newUser.addChild(newClip);
  }
  else if (key == 'X') {
    clear();
  }
  else if (key == '1') {
    if (loaded) movie.stop(); 
    movie = new Movie (this, "lilmermaid.mp4"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded clip 1"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "1");
    newUser.addChild(newClip);
  }
    else if (key == '2') {
    if (loaded) movie.stop(); 
    movie = new Movie (this, "pulp.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded clip 2"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "2");
    newUser.addChild(newClip);
  }
      else if (key == '3') {
    if (loaded) movie.stop(); 
    movie = new Movie (this, "aplocalypse.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded clip 2"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "3");
    newUser.addChild(newClip);
  }
  
        else if (key == '4') {
    if (loaded) movie.stop(); 
    movie = new Movie (this, "jpark.m4v"); 
    blinkTime = 0; 
    oldTime = 0; 
    movie.play();
    movie.goToBeginning();
    movie.pause();
    loaded = true; 
    println ("loaded clip 2"); 
    newClip = new proxml.XMLElement ("clip");
    newClip.addAttribute ("num", "4");
    newUser.addChild(newClip);
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

            if (totalPixels >10) {
              addNewBlink(blinkTime);
              saveData();
              oldTime = blinkTime;  
              totalPixels = 0; 

              fill (255, 0, 0); 
              ellipse (100, height/2 - 100, 30, 30);
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


public void stop() {
  opencv.stop();
  super.stop();
}

