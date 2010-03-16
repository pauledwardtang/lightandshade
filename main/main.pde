import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import processing.opengl.*;

// A reference to our box2d world
static PBox2D box2d;

static final int WIDTH = 800;
static final int HEIGHT = 600;

Terrain terrain;
ArrayList obstacles;
  
float pulse;
boolean gameEnable;
boolean debugEnable;

ImageButtons startButton, debugButton, addObsButton;
PImage startBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  background(255);
  frameRate(30);
  
    // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();


  //Create obstacles
  
  //Create terrain
  terrain = new Terrain(WIDTH, HEIGHT);
  obstacles = terrain.getObstacles();
  
  //displayMap();
    
  //Startup Image
  startBackground = loadImage("Light&Shade.png");
   
  // Define and create imageButton
  PImage b = loadImage("base.gif");
  PImage r = loadImage("roll.gif");
  PImage d = loadImage("down.gif");
  
  int w = b.width;
  int h = b.height;
  //(X,Y) for startButton
  
  int x = width - b.width;
  int y = 0;
  
  //(X,Y) for debugButton
  int topLeftX = 0;
  int topLeftY = 0; 
  
  //(X,Y) for addObsButton
  int bottomRightX = width - b.width;
  int bottomRightY = height - b.height; 

  startButton = new ImageButtons(x, y, w, h, b, r, d);  //Hidden at the top right
  debugButton = new ImageButtons(topLeftX, topLeftY, w, h, b, r, d);  //Hidden at the top left
  addObsButton= new ImageButtons(bottomRightX, bottomRightY, w, h, b, r, d);  //Hidden at the bottom right

}


void draw() {
  if(gameEnable) //Display Game, objects etc
  {
      background(255);
      //terrain.setTerrainDisplayEnable(true);
      box2d.step();
      terrain.displayObstacles();
  }
  else if(debugEnable)
  {
     background(255);
     addObsButton.update();
     addObsButton.display();
     box2d.step();
     terrain.displayObstacles();
  }
  else  //Show startup screen
  {
    //image(startBackground,0,0);
    
    startButton.update();
    debugButton.update();
    addObsButton.update();
    
    startButton.display();
    debugButton.display();
    addObsButton.display();
    //drawSpotLight();
  }
}
void mouseClicked()
{
  if(startButton.isPressed())
    {
      gameEnable = true;
      println("Game enabled");
    }
  if(debugButton.isPressed())
    {
      debugEnable = true;
      println("Debug enabled");
    }
  if(addObsButton.isPressed() && debugEnable)
    {
      terrain.randomizeObstacles();
      println("Randomized obstacles");
    }
}

/**
 * Brightness
 * by Daniel Shiffman. 
 * 
 * Adjusts the brightness of part of the image
 * Pixels closer to the mouse will appear brighter. 
 */

void drawSpotLight() {
  loadPixels();
  for (int x = 0; x < startBackground.width; x++) {
    for (int y = 0; y < startBackground.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*startBackground.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (startBackground.pixels[loc]);
      g = green (startBackground.pixels[loc]);
      b = blue (startBackground.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 150;//dist(0,0,width,height);
      float d = dist(x,y,mouseX,mouseY);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      r += adjustbrightness;
      g += adjustbrightness;
      b += adjustbrightness;
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r,0,255);
      g = constrain(g,0,255);
      b = constrain(b,0,255);
      // Make a new color and set pixel in the window
      color c = color(r,g,b);
      //color c = color(r);
      pixels[loc] = c;
    }
  }
  updatePixels();
}
