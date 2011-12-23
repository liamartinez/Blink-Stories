import proxml.*; 

import processing.video.*;            
import hypermedia.video.*;  
Movie movie; 
int movieTime; 
boolean isPlaying; 

//MovieMaker mm; 

proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;

long blinkNow;

ArrayList<User> userList = new ArrayList();

PFont font;
int userColor; 
int count; 
int last; 
int interval; 

Timer timer; 

Film film; 

int boxCorX, boxCorY; 
int boxWidth, boxHeight; 
int topBorder, sideBorder; 
int boxEndX, boxEndY; 

float maxTime; 
//-----------------------------------------------------------------------------------------------------------------------

void setup () {
  size (500, 400, P2D); 

  smooth(); 
  font = loadFont ("SansSerif-48.vlw");

  film = new Film(); 

  movie = new Movie (this, "lilmermaid.mp4");
  movie.play();
  movie.goToBeginning();
  movie.pause();
  isPlaying = false; 
  
  //mm = new MovieMaker (this, width, height, "lilmermaid-blinked.mov", 30, MovieMaker.H264, MovieMaker.HIGH); 

  sideBorder = width/15; 
  topBorder = height/8; 
  boxCorX = sideBorder;
  boxCorY = topBorder;  
  boxWidth = width - sideBorder * 2; 
  boxHeight = height - topBorder * 2; 

  count = 1; 

  maxTime = 500; 

  xmlIO = new XMLInOut (this);
  try {
    xmlIO.loadElement ("blinkie.xml");
  } 
  catch (Exception e) {
    println ("there is no XML");
  }
}

//-----------------------------------------------------------------------------------------------------------------------

void draw () {
  background (0); 
  fill (255);
  smooth(); 
  noStroke(); 
  //rect (boxCorX, boxCorY, boxWidth, boxHeight); 

  film.play(movie); 
  movieTime = film.getFrame(movie);
  text("frame: " + " " + film.getFrame(movie) + " / " + (film.getLength(movie) - 1), width/2, height-height/12);

      ArrayList clips1 = getClips(1);
      for (int i = 0; i < clips1.size(); i++) {
        Clip c1 = (Clip) clips1.get(i);  
        //c1.display(height/2);

        for (int k = 0; k< c1.blinks.size(); k++) {
          float blinkTimes =  (Float)c1.blinks.get(k); 

          if (movieTime >= blinkTimes -1 && movieTime <= blinkTimes+1) {
            println ("MATCH!"); 
            //isTimerOn = true; 

            c1.display();
            //ellipse (width/2, height/2, 100,100); 

            blinkNow = millis();
          }
          // println(millis() - blinkNow + 100);
          if (millis() - blinkNow >= 200) {
            println("hide");
            fill(0, 0, 0);
            //ellipse ( width/2, height/2, 100, 100);
          }
        }
      }
    
  //mm.addFrame(); 
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
  //initXML(); 

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
  
  /*
  if (key == ' ') {
    println ("finishing movie"); 
    mm.finish(); 
  }
  */
  
}

//----------------------------------------------------------------------------------------------------------------------

void movieEvent(Movie m) {
  m.read();
}

