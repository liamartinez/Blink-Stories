
/*

Generator_Video
generates real time representation for Blink Stories

liamartinez.com

*/


import proxml.*; 

import processing.video.*;            
import hypermedia.video.*;  
Movie movie; 
int movieTime; 
boolean isPlaying; 

proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;

long blinkNow;

ArrayList<User> userList = new ArrayList();

PFont font;

int whatClip; 

Film film; 


//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (400, 201, P2D); 

  smooth(); 
  font = loadFont ("SansSerif-48.vlw");

  film = new Film(); 

  movie = new Movie (this, "aplocalypse.m4v");
  movie.play();
  movie.goToBeginning();
  movie.pause();
  isPlaying = false; 

  xmlIO = new XMLInOut (this);
  try {
    xmlIO.loadElement ("blinkie.xml");
  } 
  catch (Exception e) {
    println ("there is no XML");
  }
  
  whatClip = 2; 
  
}

//-----------------------------------------------------------------------------------------------------------------------

void draw () {
  background (0); 
  fill (255);
  smooth(); 
  noStroke(); 

  film.play(movie); 
  movieTime = film.getFrame(movie);

      ArrayList clips1 = getClips(whatClip);
      for (int i = 0; i < clips1.size(); i++) {
        Clip c1 = (Clip) clips1.get(i);  
        
        for (int k = 0; k< c1.blinks.size(); k++) {
          float blinkTimes =  (Float)c1.blinks.get(k); 

          if (movieTime == blinkTimes) {
            println ("MATCH!"); 
            c1.display();

            blinkNow = millis();
          }
          if (millis() - blinkNow >= 100) {
            println("hide");
            fill(0, 0, 0);
          }
        }
      }
    
}

//-----------------------------------------------------------------------------------------------------------------------

ArrayList getClips(int num)
{
  ArrayList clips = new ArrayList();
  for (int i = 0; i < userList.size(); i++) {
    User u = (User) userList.get(i);
    //println ("NEW USER------------------------ "); 
    for (int j = 0; j < u.clips.size(); j++) {
      Clip c = (Clip) u.clips.get(j); 
      if (c.num == num) {

        clips.add(c);
      }
    }
  }
  return clips;
}



//-----------------------------------------------------------------------------------------------------------------------

/* called automatically whenever an XML file is loaded */
void xmlEvent(proxml.XMLElement element) {
  XMLusers = element;

  proxml.XMLElement[] users = XMLusers.getChildren();

  for (int i = 0; i < users.length;i++) 
  {

    User u = new User();
    u.num = users[i].getIntAttribute("num");
    println ("------new user------");

    proxml.XMLElement[] clips = users[i].getChildren(); 
    for (int j = 0; j < clips.length; j++) {  
      Clip c = new Clip();    
      c.whichUser = u.num; 
      c.num = clips[j].getIntAttribute ("num"); 
      println ("--new clip -- " + c.num); 


      proxml.XMLElement[] blinks = clips[j].getChildren(); 
      for (int q = 0; q < blinks.length; q++) {  

        float blink = blinks[q].getFloatAttribute ("time");
        //println ("blink: " + blink); 
        //add the blink to the arraylist within the arraylist!
        c.blinks.add(blink);
      }

      u.clips.add(c);
    }
    // add it to the arraylist
    userList.add(u);
  }
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
  
  
}

//----------------------------------------------------------------------------------------------------------------------

void movieEvent(Movie m) {
  m.read();
}

