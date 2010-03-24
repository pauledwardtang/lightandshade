import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
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

ImageButtons startButton, debugButton, addObsButton, addUnitsButton;
PImage startBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  background(255);
  frameRate(30);
  
    // Initialize box2d physics and create the world ( no assumed gravity)
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  //Create obstacles
  
  //Create terrain
  terrain = new Terrain(WIDTH, HEIGHT);
  //obstacles = terrain.getObstacles();
  
    
  //Startup Image
  startBackground = loadImage("Light&Shade.png");
  PImage debugButtonImg = loadImage("debug.gif");
  PImage obsButtonImg = loadImage("obs.gif");
  PImage unitsButtonImg = loadImage("units.gif");
  
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

  //(X,Y) for addUnitsButton
  int bottomLeftX = 0;
  int bottomLeftY = height - b.height; 
  
  startButton = new ImageButtons(x, y, w, h, b, r, d);  //Hidden at the top right
  debugButton = new ImageButtons(topLeftX, topLeftY, w, h, debugButtonImg, r, d);  //Hidden at the top left
  addObsButton= new ImageButtons(bottomRightX, bottomRightY, w, h, obsButtonImg, r, d);  //Hidden at the bottom right
  addUnitsButton= new ImageButtons(bottomLeftX, bottomLeftY, w, h, unitsButtonImg, r, d);  //Hidden at the bottom left

}


void draw() {
  if(gameEnable) //Display Game, objects etc
  {
      background(255);
      box2d.step();
      terrain.draw();
  }
  else if(debugEnable) //Debug mode
  {
     background(255);
     //Update buttons
     addObsButton.update();
     addUnitsButton.update();
     
     //Display add units button
     addObsButton.display();
     addUnitsButton.display();
     
     box2d.step();
     terrain.draw();
  }
  else  //Show startup screen
  {
    background(255);
    image(startBackground,0,0);
    
    //Update buttons
    startButton.update();
    debugButton.update();
    
    //Display buttons
    startButton.display();
    debugButton.display();
    //drawSpotLight();
  }
}

//Handles all actions when the mouse is clicked.
void mouseClicked()
{
  if(startButton.isPressed() && !gameEnable)
    {
      gameEnable = true;
      println("Game enabled");
    }
  if(debugButton.isPressed() && !debugEnable)
    {
      debugEnable = true;
      println("Debug enabled");
    }
  if(addObsButton.isPressed() && debugEnable)
    {
      terrain.randomizeObstacles();
      println("Randomized obstacles");
    }
   if(addUnitsButton.isPressed() && debugEnable)
    {
      terrain.createUnits(50);
      terrain.createParticles();
      println("Added units");
    }
    println("Mouse clicked");
    //Update particle selection if the mouse is clicked
    for(int i = 0; i < terrain.particles.size(); i++)
     {
        Particle temp = (Particle) terrain.particles.get(i);
        
        if(temp.contains(mouseX, mouseY))
        {
           if(temp.isSelected)
             temp.isSelected = false;
           else
             temp.isSelected = true;
        }

        println("particle[" + i + "] selected: "+ temp.isSelected);
     }
}

//Handles all actions when a mouse is released
  void mouseReleased()
  {

  }
  
//  //Handles all actions when a mouse is dragged.
//  void mouseDragged()
//  {
//    //Update selectedParticles if the mouse is dragged
//    for(int i = 0; i < terrain.selectedParticles.size(); i++)
//     {
//        Particle temp = (Particle) terrain.selectedParticles.get(i);
//        if(temp.isSelected && temp.contains(mouseX,mouseY))
//          temp.update(mouseX,mouseY);
//        println("Mouse dragged, updating particle");
//     }
//  }
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