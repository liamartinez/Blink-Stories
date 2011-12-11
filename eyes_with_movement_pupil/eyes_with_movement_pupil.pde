import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object
import java.awt.Rectangle;

int edge = 50;

boolean debug = true;
PImage movementImg;    
PImage pupilImg; 
int pupilThreshold = 100;
int reach = 5;
int minPupilArea = 75;

void setup()
{

  size( 640, 480 );

  opencv = new OpenCV( this );    //  Initialises the OpenCV object
  opencv.capture( 640, 480 );     //  Opens a video capture stream
  movementImg = new PImage( 640, 480 ); 
  pupilImg = new PImage (640, 480); 

  opencv.cascade( "haarcascade_frontaleyes.xml" ); //eyes, eyeright, frontaleyes
}

void draw()
{

  opencv.read();                  //  Grabs a frame from the camera



  // proceed detection
  Rectangle[] eyes = opencv.detect( 1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  image( opencv.image(), 0, 0 );  //  Display the difference image
  pupilImg = opencv.image(); 

  opencv.absDiff();                           //  Creates a difference image

  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(50);                       //  Thresholds to convert to black and white
  movementImg = opencv.image();               //  Puts the OpenCV buffer into an image object


  // draw face area(s)
  noFill();  
  stroke(255, 0, 0);

  for ( int i=0; i<eyes.length; i++ ) {
    rect( eyes[i].x, eyes[i].y, eyes[i].width, eyes[i].height );    // draw the rectangle

    //findPupil (eyes[i]); 

    int totalPixels = 0;
    for (int x = eyes[i].x; x < (eyes[i].x+eyes[i].width); x++) {      //loop through 
     for (int y = eyes[i].y; y < (eyes[i].y + eyes[i].height); y++) {
     
     if (brightness(movementImg.pixels[x+(y*movementImg.width)]) > 230) {  //if brightness is higher
       totalPixels++;
     //fill (255, 0, 0); 
     //ellipse (width/2, height/2, 50, 50);                            // draw a circle!
     }
     
     }
     }
     
     if (totalPixels > ????) {
       // blinked! 
       
     }
     
  }

  opencv.remember(OpenCV.SOURCE);
}

public void stop() {
  opencv.stop();
  super.stop();
}


//-----------------------------------------------------------------------------

public Rectangle findPupil(Rectangle eyesBox) {
  // /FIND THE PUPIL

  ArrayList boxes = new ArrayList();
  for (int row = eyesBox.x; row < (eyesBox.x+eyesBox.width); row++) {
    for (int col = eyesBox.y; col < (eyesBox.y+eyesBox.height); col++) {
     
      int offset = row * eyesBox.width + col;
      int thisPixel = pupilImg.pixels[offset];
      //look for dark things
      if (brightness(thisPixel) < pupilThreshold) {
        pupilImg.pixels[offset] = 0;
        // be pessimistic
        boolean foundAHome = false;
        // look throught the existing
        for (int i = 0; i < boxes.size(); i++) {
          Rectangle existingBox = (Rectangle) boxes.get(i);
          // is this spot in an existing box
          Rectangle inflatedBox = new Rectangle(existingBox); // copy the existing box
          inflatedBox.grow(reach, reach); // widen it's reach
          if (inflatedBox.contains(col, row)) {
            existingBox.add(col, row);
            foundAHome = true; // no need to make a new one
            break; // no need to look through the rest of the boxes
          }
        }
        // if this does not belong to one of the existing boxes make a new one at this place
        if (foundAHome == false) boxes.add(new Rectangle(col, row, 0, 0));
      }
    }
  }

  consolidate(boxes, 0, 0);

  // OF EVERYTHING YOU FIND TAKE THE ONE CLOSEST TO THE CENTER
  Rectangle pupil = findClosestMostBigOne(boxes, eyesBox.width / 2, eyesBox.height / 2, minPupilArea);

  if (debug) {
    // show the the edges of the search
    fill(0, 0, 0, 0);
     stroke (255); 
      rect( eyesBox.x, eyesBox.y, eyesBox.width, eyesBox.height );  //white box
    // show all the pupil candidates
    stroke(0, 0, 0);
    for (int i = 0; i < boxes.size(); i++) {
      Rectangle thisBox = (Rectangle) boxes.get(i);
      rect(thisBox.x, thisBox.y, thisBox.width, thisBox.height);  //black box
    }
    // show the winning pupil candidate in red
    if (pupil != null) {
      stroke(255, 0, 0);
      rect(pupil.x, pupil.y, pupil.width, pupil.height);
    }
  }

  return pupil;
}

//---------------------------------------------------------------------------------------------


public void consolidate(ArrayList _shapes, int _consolidateReachX, int _consolidateReachY) { 

  //check every combination of shapes for overlap 
  //make the repeat loop backwards so you delete off the bottom of the stack
  for (int i = _shapes.size() - 1; i > -1; i--) {
    //only check the ones up 
    Rectangle shape1 = (Rectangle) _shapes.get(i);
    Rectangle inflatedShape1 = new Rectangle(shape1); //copy the existing box
    inflatedShape1.grow(_consolidateReachX, _consolidateReachY); //widen it's reach

    for (int j = i - 1; j > -1; j--) {
      Rectangle shape2 = (Rectangle) _shapes.get(j);
      if (inflatedShape1.intersects(shape2) ) {
        shape1.add(shape2);
        //System.out.println("Remove" + j);
        _shapes.remove(j);
        break;
      }
    }
  }
}

public Rectangle findClosestMostBigOne(ArrayList _allRects, int _x, int _y, int _minArea) {
    if (_allRects.size() == 0) return null;
    int winner = 0;
    float closest = 1000;

    for (int i = 0; i < _allRects.size(); i++) {
      Rectangle thisRect = (Rectangle)  _allRects.get(i);
      if (thisRect.width * thisRect.height < _minArea) continue;
      float thisDist = dist(_x, _y, thisRect.x + thisRect.width / 2, thisRect.y + thisRect.height / 2);
      if (thisDist < closest) {
        closest = thisDist;
        winner = i;
      }
    }
    return (Rectangle) _allRects.get(winner);
  }

//----------------------


void keyPressed () {
     if (key == 'd') {

      debug = !debug;
      if (debug == false) ellipse(width/3, height/3, 50,50);
      println("debug " + debug);
    } 
}
