class Clip {

  
  
Clip () {
}


void play (Movie temp) {

  image (temp, (width-movie.width) - 20, 0, width/2, height/2); 

}



int getFrame(Movie temp) {    
  return ceil(temp.time() * temp.getSourceFrameRate()) - 1;
}


//----------------------------------------------------------------------------------------------------------------
void setFrame(int n, Movie temp) {
  temp.play();

  float srcFramerate = temp.getSourceFrameRate();

  // The duration of a single frame:
  float frameDuration = 1.0 / srcFramerate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = temp.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  temp.jump(where);
  temp.pause();
}  

//----------------------------------------------------------------------------------------------------------------

int getLength(Movie temp) {
  return int(temp.duration() * temp.getSourceFrameRate());
}  


//----------------------------------------------------------------------------------------------------------------


}
