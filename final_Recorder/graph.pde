class Graph {

  Graph () {
  }  


  void drawLines () {

    for (float i = 0; i < clip.getLength(movie); i = i+ 50) {
      float loc = map (i, 0, clip.getLength(movie), 50, width-50); 
      line (loc, boxStartY, loc, height-20);
    }
  }

  void drawText () {
    fill (0); 
    textSize (15); 
    text("frame: " + " " + clip.getFrame(movie) + " / " + (clip.getLength(movie) - 1), width/8, height/2+40);
    text ("Press P to play and pause",  width/8, height/2 + 60); 
    text ("Press N to for a new user", width/8, height/2 + 80); 
    text ("mousebutton for Blink", width/8, height/2 + 100);
  }

  void drawMarks () {

    for (int i=0; i<blinks.size(); i++) {  
      //ellipse (i*15, height/2, 10, 10);
      Blink b = (Blink) blinks.get(i); 
      float locTime = map (b.time, 0, clip.getLength(movie), 50, width-50); 
      noStroke(); 
      ellipse (locTime, height - dotLoc, 4, 4);
      //line (locTime, 0, locTime, height); 
     
    }
  }
}



