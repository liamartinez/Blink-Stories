import processing.video.*;
import hypermedia.video.*;        //  Imports the OpenCV library
import java.awt.Rectangle;
import proxml.*; 

OpenCV opencv;                    //  Creates a new OpenCV Object
Movie movie; 
PImage movementImg;    
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

//----------------------------------------------------------------------------------

void setup () {
  size (1000, 500); 
  smooth(); 

  opencv = new OpenCV( this );    //  Initialises the OpenCV object
  opencv.capture( 320, 240 );     //  Opens a video capture stream
  movementImg = new PImage( 320, 240 ); 

  opencv.cascade( "haarcascade_frontaleyes.xml" ); //eyes, eyeright, frontaleyes

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
  graph = new Graph(); 
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

void draw () {
  background (255); 
  textFont (font, 10); 

  blinkTime = getFrame();
  
  image (movie, width/10, height/6, width/2, height/2); 
  
  graph.drawLines(); 
  graph.drawText(); 
  graph.drawMarks(); 

  //--------------------------------------------------
  
  
  opencv.read();                  //  Grabs a frame from the camera

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  //image( opencv.image(), 0, 0 );  //  Display the difference image

  opencv.absDiff();                           //  Creates a difference image

  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(50);                       //  Thresholds to convert to black and white
  movementImg = opencv.image();               //  Puts the OpenCV buffer into an image object

  // draw face area(s)
  noFill();  
  stroke(255, 0, 0);

  for ( int i=0; i<faces.length; i++ ) {
    //rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );    // draw the rectangle

    for (int x = faces[i].x; x < (faces[i].x+faces[i].width); x++) {      //loop through 
      for (int y = faces[i].y; y < (faces[i].y + faces[i].height); y++) {

        if (brightness(movementImg.pixels[x+(y*240)]) > 230) {  //if brightness is higher
            if (isPlaying) {
              addNewBlink(blinkTime);
              saveData(); 
            }
        }
      }
    }
  }

  opencv.remember(OpenCV.SOURCE);

}

//----------------------------------------------------------------------------------

void mouseClicked () {
  addNewBlink(blinkTime);
  saveData(); 
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
  } 
  else if (key == 'c') {
    clear();
  }
}



//-----------------------------------------------------------------------------------------------------------------------

void addNewBlink (float time) {
  blinks.add (new Blink(time));

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

int getFrame() {    
  return ceil(movie.time() * movie.getSourceFrameRate()) - 1;
}

void setFrame(int n) {
  movie.play();

  float srcFramerate = movie.getSourceFrameRate();

  // The duration of a single frame:
  float frameDuration = 1.0 / srcFramerate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = movie.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  movie.jump(where);
  movie.pause();
}  

int getLength() {
  return int(movie.duration() * movie.getSourceFrameRate());
}  

//----------------------------------------------------------------------------------------------------------------


public void stop() {
  opencv.stop();
  super.stop();
}

