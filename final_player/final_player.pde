import proxml.*; 

import processing.video.*;            
import hypermedia.video.*;  
Movie movie; 
int movieTime; 
boolean isPlaying; 
boolean isTimerOn; 

proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

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
  size (1300, 500); 

  smooth(); 
  font = loadFont ("SansSerif-48.vlw");

  film = new Film(); 
  timer = new Timer(1000);
  last = millis(); 
  interval = 500; 
  isTimerOn = false; 


  movie = new Movie (this, "pulp.mp4");
  movie.play();
  movie.goToBeginning();
  movie.pause();
  isPlaying = false; 

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
  fill (100);
  //rect (boxCorX, boxCorY, boxWidth, boxHeight); 

  film.play(movie); 
  movieTime = film.getFrame(movie);
  text("frame: " + " " + film.getFrame(movie) + " / " + (film.getLength(movie) - 1), width/2 + width/8, height/2+40);

  for (int q = 0; q < userList.size(); q++) 
  {
    User u = userList.get(q);

    //println ("clip size: " + u.clips.size()); 
    for (int j = 0; j < u.clips.size(); j++) {

      ArrayList clips1 = getClips(1);
      for (int i = 0; i < clips1.size(); i++) {
        Clip c1 = (Clip) clips1.get(i);  
        //c1.display(height/2);

        for (int k = 0; k< c1.blinks.size(); k++) {
          float blinkTimes =  (Float)c1.blinks.get(k); 
          println ("movietime " + movieTime + " blinkTimes " + blinkTimes); 
          if (movieTime >= blinkTimes -1 && movieTime <= blinkTimes+1) {
            println ("MATCH!"); 
            //isTimerOn = true; 

            if (k == 0) {
                          fill(0, 255, 0);
            ellipse ( width/2, height/2, 100, 100);
            }

            if (k == 1) {
                          fill(255, 0, 0);
            ellipse ( width/2, height/2, 100, 100);
            }
            blinkNow = millis();
          }
        }
      }
    }

    // println(millis() - blinkNow + 100);
    if (millis() - blinkNow >= 100) {
      println("hide");
      fill(0, 0, 0);
      ellipse ( width/2, height/2, 100, 100);
    }

    // ArrayList clips2 = getClips(2);
    /* for (int i = 0; i < clips2.size(); i++) {
     Clip c2 = (Clip) clips2.get(i);
     //c2.display(height/2 + 50);
     }*/
    // }
  }
  /*
  if (isTimerOn) {
   timer.start(); 
   if (!timer.isFinished()) {  
   fill (0); 
   ellipse (height/2, width/2, 50, 50);
   }
   isTimerOn = false; 
   }
   */
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
    println ("------new user------");

    proxml.XMLElement[] clips = users[i].getChildren(); 
    for (int j = 0; j < clips.length; j++) {  
      Clip c = new Clip();    
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

