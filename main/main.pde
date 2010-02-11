import processing.opengl.*;

static final int WIDTH = 800;
static final int HEIGHT = 600;
float pulse;
ArrayList objects;
boolean gameEnable;
ImageButtons button;
PImage startBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  fill(0, 150);
  frameRate(30);
  noStroke();
  objects = new ArrayList();
  
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
  if(gameEnable) 
  {//Display game
      background(200);
      displayMap();
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
  translate(width/2, height/2);
  rotateX(-200);
  rect(-200, -200, 400, 400);
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
