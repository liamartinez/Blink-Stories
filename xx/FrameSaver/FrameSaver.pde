/**
 * Loop. 
 * 
 * Move the cursor across the screen to draw. 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;

Movie movie;
//int picWidth = movie.width;
//int picHeight = movie.height; 

void setup() {
  size(500, 350);
  
  // Load and play the video in a loop
  movie = new Movie(this, "pulp.m4v");
  movie.play();
}

void movieEvent(Movie movie) {
  movie.read();
}

void draw() {
  //tint(255, 20);
  background(0);
  
  imageMode (CENTER); 
  image(movie,width/2,height/2, width,height);
  saveFrame("pulp####.jpg");
  
}
