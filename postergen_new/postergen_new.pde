

PImage[] picture = new PImage [2687];//change frame
Frame[] frames = new Frame [picture.length]; 

int timeInc; 
float s; 

//-------------------------------------------------------------------------------------------

void setup () {
  size (1350, 1800);
  background (0); 

  timeInc = 10; 

  //load images 
  for (int i = 0; i < frames.length; i=i+timeInc) {
    picture[i] = loadImage ("Apoca_" + nf(i, 4) + ".jpg"); 
    frames[i] = new Frame(); 
    frames[i].framePic = picture[i];
    frames[i].frameNum = i; 
    println ("loading ... " + i);
  }
  
  /*
  for (int i = 0; i < frame.length; i=i+timeInc) {
  image (frame[i].framePic, i*10, (i*10)/width, 130, 90);   
  }
  */
  
   for (int i = 0; i < frames.length; i=i+timeInc) {
  //image(frames[i].framePic, floor(i/10) * 130, (i % 10) * 90,  130, 90);
  //image(frames[i].framePic, (i*13) - (i/10), i/10 ,  130, 90);
  frames[i].display(); 
   }
  
}

//-------------------------------------------------------------------------------------------

void draw () {
  
  
  
}


//--------------------------------------------------------------------------------------------
/*
void drawGrid(Pimage[] pics, float x, float y, float s) {

 
 pushMatrix();
 translate(x,y);
 //Draw the grid
 for (int i = 0; i < pics.length; i++) {

   
   image(i, (i % 10) * s, floor(i/10) * s);
 };
 popMatrix();
};

*/
 
