
Frame[] frame = new Frame [3000]; 
PImage [] mermaid = new PImage[3000]; 
int timeInc; 

int laki = 100; 
int lakiY = 140; 


import proxml.*; 
proxml.XMLInOut xmlIO; 

proxml.XMLElement XMLusers;
proxml.XMLElement userz;
proxml.XMLElement blinkz;

ArrayList userList = new ArrayList();

PFont font;
int userColor; 
int count; 

int boxCorX, boxCorY; 
int boxWidth, boxHeight; 
int topBorder, sideBorder; 
int boxEndX, boxEndY; 

float maxTime; 

//-----------------------------------------------------------------------------------------------------------------------

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
  font = loadFont ("SansSerif-48.vlw");

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

  /*
for (int q = 0; q < userList.size(); q++) 
   {
   User u = (User) userList.get(q);
   
   //println ("clip size: " + u.clips.size()); 
   for (int j = 0; j < u.clips.size(); j++) {
   
   ArrayList clips2 = getClips(2);
   for (int i = 0; i < clips2.size(); i++) {
   Clip c2 = (Clip) clips2.get(i);
   }
   }
   }
   */




  for (int i=0; i< mermaid.length; i=i + timeInc) {
    int imageLoc = int(map (i, 0, mermaid.length, 0, width*10));   
    println (i); 
    for (int q = 0; q < userList.size(); q++) 
    {

      User u = (User) userList.get(q);

      //println ("clip size: " + u.clips.size()); 
      for (int c = 0; c < u.clips.size(); c++) {

          ArrayList clips2 = getClips(2);
        for (int j = 0; j < clips2.size(); j++) {
          Clip c2 = (Clip) clips2.get(j); 

          for (int k = 0; k< c2.blinks.size(); k++) {
            float blinkNum = (Float) c2.blinks.get(k);
            if (blinkNum >= i-30 && blinkNum <= i+30) {
            println (blinkNum + " "+ i + " NO WAY"); 
            }
           
          }
        }
      }
    }



        /*
   this is where we will say
         for loop array for the blinks {
         map the blinks[j]
         
         if j == i {
         distance = 2;
         } else {
         distance = 0;
         }
         
         imageLoc = imageLoc + increment + distance; 
         increment = increment + distance; 
         
         }
         
         }
         
         */


        frame[i].imageX = imageLoc;    // this is what we need to change 
        frame[i].display(laki);
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
          //println ("-----new clip----"); 
          Clip c = (Clip) u.clips.get(j); 
          //println ("c.num: " + c.num + " num: "  + num); 
          if (c.num == num) {
            //println ("ADD"); 

            clips.add(c);
            //println ("TOTAL size " + clips.size());
          }
        }
      }
      //println (clips.size() + " is clipsize of " + num); 
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
            println ("blink: " + blink); 
            //add the blink to the arraylist within the arraylist!
            c.blinks.add(blink);
          }

          u.clips.add(c);
        }
        // add it to the arraylist
        userList.add(u);
      }
    }

