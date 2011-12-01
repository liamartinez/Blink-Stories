import hypermedia.video.*;        //  Imports the OpenCV library
OpenCV opencv;                    //  Creates a new OpenCV Object
import java.awt.Rectangle;

PImage movementImg;    

void setup()
{

  size( 640, 480 );

  opencv = new OpenCV( this );    //  Initialises the OpenCV object
  opencv.capture( 640, 480 );     //  Opens a video capture stream
  movementImg = new PImage( 640, 480 ); 

  opencv.cascade( "haarcascade_frontaleyes.xml" ); //eyes, eyeright, frontaleyes
}

void draw()
{

  opencv.read();                  //  Grabs a frame from the camera



  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 10, 10 );

  image( opencv.image(), 0, 0 );  //  Display the difference image


  opencv.absDiff();                           //  Creates a difference image

  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(50);                       //  Thresholds to convert to black and white
  movementImg = opencv.image();               //  Puts the OpenCV buffer into an image object


  // draw face area(s)
  noFill();  
  stroke(255, 0, 0);

  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );    // draw the rectangle

    for (int x = faces[i].x; x < (faces[i].x+faces[i].width); x++) {      //loop through 
      for (int y = faces[i].y; y < (faces[i].y + faces[i].height); y++) {

        if (brightness(movementImg.pixels[x+(y*width)]) > 230) {  //if brightness is higher
          fill (255, 0, 0); 
          ellipse (width/2, height/2, 50, 50);                            // draw a circle!
        }
      }
    }
  }

  opencv.remember(OpenCV.SOURCE);
}

public void stop() {
  opencv.stop();
  super.stop();
}

