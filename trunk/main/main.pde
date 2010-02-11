import processing.opengl.*;

static final int WIDTH = 600;
static final int HEIGHT = 600;
Terrain terrain;
ArrayList obstacles;


float pulse;
boolean gameEnable;
ImageButtons button;
PImage startBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  background(255);
  frameRate(30);
  terrain = new Terrain(WIDTH, HEIGHT);
  obstacles = terrain.getObstacles();
  
  //displayMap();
  displayUnits();
  
  //Startup Image
  startBackground = loadImage("Light&Shade.png");
   
  // Define and create image button
  PImage b = loadImage("base.gif");
  PImage r = loadImage("roll.gif");
  PImage d = loadImage("down.gif");
  int x = width - b.width;
  //int y = height - b.height; 
  int y = 0;
  int w = b.width;
  int h = b.height;
  button = new ImageButtons(x, y, w, h, b, r, d);
}


void draw() {
  if(true) 
  {//Display game
      //displayMap();
      
  }
  else//Show startup screen
  {
    image(startBackground,0,0);
    drawSpotLight();
    button.update();
    button.display();
  }
}
void mouseClicked()
{
  if(button.isPressed())
    {
      gameEnable = true;
    }
}
void displayMap()
{
  
  background(200);
  translate(width/2, height/2);
  //rotateX(-200);
  //fill(100, 50, 0);
  rect(-200, -200, 400, 400);
  
}
//Displays units (represented as boxes)
void displayUnits()
{
  
 // rect(100, 100, 50, 50);
  // Obstacle temp = ((Obstacle) obstacles.get(0));
  // translate(0 , 0);
  // fill(200, 150, 0);
  // rect(-25, -25, 50, 50);
   
   for(int i = 0; i < obstacles.size(); i++)
   {
     Obstacle temp = ((Obstacle) obstacles.get(i));
     
     //tint(255, 153);
     //rotateY(.5);
     fill(0);
     rect(temp.getX(), temp.getY(), 50, 50);
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
