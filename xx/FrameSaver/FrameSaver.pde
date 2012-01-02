/**
 * Loop. 
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 *
 */
int start; 
int i; 

import processing.video.*;

Movie movie;
//int picWidth = movie.width;
//int picHeight = movie.height;

int newFrame = 0;
PFont font;

void setup() {
  size(500, 350);
  start = millis(); 

  frameRate (1); 
  i = 1; 
  
  font = loadFont("DejaVuSans-24.vlw");
  textFont(font, 24);

  // Load and play the video in a loop
  movie = new Movie(this, "pulp.m4v");
  movie.play();
  movie.goToBeginning();
  movie.pause();
}

void movieEvent(Movie movie) {
  movie.read();
}

void draw() {
  //tint(255, 20);
  background(0);

  imageMode (CENTER); 
  image(movie, width/2, height/2, width, height);
    //movie.play();
  //text(getFrame() + " / " + (getLength() - 1), 10, 30);

  
  if ( millis () - start >= 1500) {
    start = millis(); 
    if (i < (getLength() - 1)) {
      setFrame (i);
      i++; 
      println (i);
    }
  }
  

}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      if (0 < newFrame) newFrame--;
    } 
    else if (keyCode == RIGHT) {
      if (newFrame < getLength() - 1) newFrame++;
      println (getFrame());
    }
  } 


  setFrame(newFrame);
}

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
  saveFrame("Pulp####.jpg");
}  

int getLength() {
  return int(movie.duration() * movie.getSourceFrameRate());
}  

