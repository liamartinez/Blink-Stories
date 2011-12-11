
Frame[] frame = new Frame [3000]; 
PImage [] mermaid = new PImage[3000]; 
int timeInc; 

int laki = 100; 
int lakiY = 140; 


void setup () {
  size (1350, 1800); 
  smooth(); 


  timeInc = 30; 

  for (int i = 0; i < mermaid.length; i= i+timeInc) {
    //String imageName = "file" + nf(i, 4) + ".jpg"; 
    mermaid[i] = loadImage ("littlemermaid/file" + nf(i, 4) + ".jpg");
    frame[i] = new Frame(); 
    frame[i].framePic = mermaid[i]; 

   // println (i);
  }
  fill(255); 
  //ellipse (height/2, 0, 100, 100);
  

}

void draw () {
  background (0); 
   
  
  for (int i=0; i< mermaid.length; i=i + timeInc) {
    int imageLoc = int(map (i, 0, mermaid.length, 0, width*10));   
       println (imageLoc);

    frame[i].imageX = imageLoc;     
    frame[i].display(laki);  
    



  }
}

