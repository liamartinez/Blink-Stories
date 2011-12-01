
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.List;
import java.awt.Rectangle;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.image.BufferedImage;
import java.awt.image.Raster;
import java.awt.image.WritableRaster;
import java.util.ArrayList;
import java.util.Arrays;

import blobs.Blob;
import blobs.BlobFinder;
import blobs.BlobInPixelSource;
import blobs.BrightBlob;

import pFaceDetect.PFaceDetect;
import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;
import util.VariableAdjuster;
import vxp.AxisPixelSource;
import vxp.PixelSource;
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.util.ArrayList;
import java.util.Arrays;

import processing.core.PApplet;
import util.VariableAdjuster;
import vxp.AxisPixelSource;
import vxp.PixelSource;

import blobs.Blob;
import blobs.BlobFinder;
import blobs.BlobInPixelSource;
import blobs.SkinBlob;

public class DontBlink extends PApplet {

  PFont myFont;

  int w = 320;

  int h = 240;

  Rectangle seedArea = new Rectangle(0, 0, 320, 240);

  FaceFinder face;
  PFaceDetect facecv;
  PixelSource ps ;

  public void setup() {
    size(800, 600);

    myFont = createFont("ArialMT-48.vlw");
    ps = new AxisPixelSource("128.122.151.189", 320, 240, false);
    face = new FaceFinder(ps);
    facecv = new PFaceDetect(this, ps.getVideoWidth(), ps.getVideoHeight(), "haarcascade_frontalface_default.xml");
  }

  public void draw() {

    BufferedImage img = ps.getImage();
    image(new PImage(img), 0, 0, 320, 240);

    img= face.vxpanalyze(seedArea);
    image(new PImage(img), 0, 0, 320, 240);

  }

  static public void main(String _args[]) {
    PApplet.main(new String[] { 
      "DontBlink"
    }
    );
  }
  public void keyPressed(KeyEvent e) {
    face.keyPressed(e);
  }

  public class FaceFinder {
    BufferedImage myImage;

    BufferedImage backgroundImage;

    WritableRaster braster;

    BufferedImage displayImage;

    BlobFinder skinFinder = new BlobFinder(w, h);

    VariableAdjuster variableAdjuster;

    PixelSource ps;

    SkinBlob19 skinBlob;

    public int consolidationX = 5;

    public int consolidationY = 5;

    ArrayList<Blob> existingBlobs = new ArrayList<Blob>();

    // ArrayList<Blob> oldEnoughBefore = new ArrayList<Blob>();
    public int tooSmall = 1000;

    public FaceFinder(PixelSource _ps) {
      backgroundImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
      braster = backgroundImage.getRaster();
      displayImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
      ps = _ps;

      //protoBlob = new Blob19(aps);
      skinBlob = new SkinBlob19(_ps);

      //seedArea = new Rectangle(0, 0, 320, 240);
      variableAdjuster = new VariableAdjuster(this, null, ps.getDeviceName());
      //variableAdjuster.addObject(protoBlob, “ProtoBlob”);
      variableAdjuster.addObject(skinBlob, "SkinBlob");
      //variableAdjuster.addObject(bf, “BlobFinder”);
      variableAdjuster.addObject(skinFinder, "SkinFinder");
    }
    public int dist(int a, int b, int c, int a1, int b1, int c1) {
    //  return (int) Math.sqrt(Math.pow(a – a1, 2) + Math.pow(b – b1, 2) + Math.pow(c – c1, 2));
      return (int) Math.sqrt(Math.pow(a - a1, 2) + Math.pow(b-b1, 2) + Math.pow (c-c1, 2)); 
    }

    public void keyPressed(KeyEvent _e) {
      variableAdjuster.keyPressed(_e);
    }

    public BufferedImage vxpanalyze(Rectangle _seedArea) {
      if (ps.grabFrame()) {
        long now = System.currentTimeMillis();
        myImage = ps.getImage();

        Graphics2D myGraphics = displayImage.createGraphics();
        myGraphics.drawImage(myImage, 0, 0, null);
        skinFinder.clearDebugImage();
        ArrayList foundBlobs = skinFinder.findBlobs(skinBlob, true, _seedArea);
        foundBlobs = BlobFinder.killSmallBlobs(foundBlobs, tooSmall);
        skinFinder.consolidate(foundBlobs, consolidationX, consolidationY, false);
        BlobFinder.drawRects(Color.PINK, myGraphics, foundBlobs);
        skinFinder.lookForContinuity(existingBlobs, foundBlobs, true, false);

        myGraphics.drawImage(skinFinder.getDebugImage(), 0, 0, null);
        myGraphics.drawImage(variableAdjuster.getImage(), 0, 0, null);
      }
      return displayImage;
      // return myImage;
    }

    public class SkinBlob19 extends BlobInPixelSource {

      public float skinRedLower = .35f;

      public float skinRedUpper = .55f;

      public float skinGreenLower = .26f;

      public float skinGreenUpper = .35f;

      public SkinBlob19(PixelSource _ps) {
        super(_ps);
      }


      public boolean doesPixelQualify(int[] _rgb) {
        int total = (_rgb[0] + _rgb[1] + _rgb[2]);
        float nr = (float) _rgb[0] / total;
        float ng = (float) _rgb[1] / total;

        return (( nr < skinRedUpper && nr > skinRedLower && ng < skinGreenUpper && ng > skinGreenLower));
      }

      public void shiftRed(float _redShift) {
        skinRedUpper = skinRedUpper + _redShift;
        skinRedLower = skinRedLower + _redShift;
      }

      public void shiftGreen(float _greenShift) {
        skinGreenUpper = skinGreenUpper + _greenShift;
        skinGreenLower = skinGreenLower + _greenShift;
      }

      public float[] getRanges() {
        float[] a = { 
          skinRedLower, skinRedUpper, skinGreenLower, skinGreenUpper
        };
        return a;
      }
    }
  }
}

