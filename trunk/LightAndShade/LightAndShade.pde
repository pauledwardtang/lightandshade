import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.JointUtils;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.opengl.*;

public static final int MAIN_GAME    = 1;
public static final int DEBUG        = 2;
public static final int INSTRUCTIONS = 3;
public static final int GAME_WIN     = 4;
public static final int GAME_LOSE    = 5;
public static final int STARTUP      = 6;
public static final int PAUSE        = 7;

static int game_display;

// A reference to our box2d world
static PBox2D box2d;

// The Spring that will attach to the box from the mouse
Spring spring;
Particle attachedParticle;

//Selection stuff
SelectionBox sBox = new SelectionBox();
boolean L_MOUSE = false;
boolean R_MOUSE = false;

static final int WIDTH = 1260;
static final int HEIGHT = 730;

GameState gameState;
AIPlayer AI;
ArrayList obstacles;
  
float pulse;
boolean gameEnable;
static boolean debugEnable;

LightSource source;
ArrayList particles;

//Game Win stuff
PImage extrude, extrude2;
int[][] values, values2;
float angle = 0;

ImageButtons startButton, debugButton, addObsButton, addUnitsButton, addParticles,clearButton;
PImage startBackground, gameBackground, winBackground, loseBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  background(255);
  colorMode(HSB);
  frameRate(30);
  
    // Initialize box2d physics and create the world ( no assumed gravity)
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  
  // Add a listener to listen for collisions!
  box2d.world.setContactListener(new CustomListener());

  //Create gameState & obstacles
  gameState = new GameState(WIDTH, HEIGHT);
  //obstacles = gameState.getObstacles();
  
  AI = new AIPlayer();  
  
//  ArrayList lightSource = gameState.getLightSource();
//  source = (LightSource) lightSource.get(0);
//  particles = source.spawn(18);
  
  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();
  attachedParticle = new Particle(0,0,0, 0,1,"player",0);
  //spring.bind(width/2,height/2,box);
  
  game_display = STARTUP;
  
  //Startup Image
  startBackground = loadImage("Light&Shade.png");
  gameBackground  = loadImage("background.jpg");
  winBackground   = loadImage("background2.jpg");
  loseBackground  = loadImage("youlose.jpg");
  
  
  PImage debugButtonImg = loadImage("debug.gif");
  PImage obsButtonImg = loadImage("obs.gif");
  PImage unitsButtonImg = loadImage("units.gif");
  PImage clearButtonImg = loadImage("clear.gif");
  
  // Define and create imageButton
  PImage b = loadImage("base.gif");
  PImage r = loadImage("roll.gif");
  PImage d = loadImage("down.gif");
  PImage s = loadImage("start.gif");
  
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
  
  //(X,Y) for clearButton
  int leftOfAddObsButtonX = bottomRightX - b.width;
  int leftOfAddObsButtonY = bottomRightY; 
  
  startButton = new ImageButtons(width - s.width, y, s.width, s.height, s, s, s);  //Hidden at the top right
  debugButton = new ImageButtons(topLeftX, topLeftY, w, h, debugButtonImg, r, d);  //Hidden at the top left
  addObsButton= new ImageButtons(bottomRightX, bottomRightY, w, h, obsButtonImg, r, d);  //Hidden at the bottom right
  addUnitsButton= new ImageButtons(bottomLeftX, bottomLeftY, w, h, unitsButtonImg, r, d);  //Hidden at the bottom left
  clearButton= new ImageButtons(leftOfAddObsButtonX, leftOfAddObsButtonY, w, h, clearButtonImg, r, d);  //Hidden at the bottom left
  addParticles = new ImageButtons(topLeftX, topLeftY, w, h, obsButtonImg, r, d);
}


void draw() {
  if(game_display == MAIN_GAME) //Display Game, objects etc
  {
      //Background display
      background(255);
      image(gameBackground, 0, 0);
      
      //Have Box2D step through its physics engine
      box2d.step();
      
      //Update the mouse joint
      spring.update(mouseX,mouseY);
      spring.display();
             
      AI.update(); 
   
      //Draw the game's objects
      gameState.draw();
      
      if (L_MOUSE == true)
        sBox.updateBox();//update the SelectionBox 
//     
//      PFont font;
//      font = loadFont("AmericanTypewriter-24.vlw"); 
//      textFont(font); 
//      //translate(width/4,height/2,0);     
//      fill(255);
//      text("Light Timer: " + gameState.lightTimer,0,0,0);   
//      translate(width - 20, 0);
//      text("Dark Timer: " + gameState.darkTimer,0,0,0);  
  }
  else if(game_display == DEBUG) //Debug mode
  {
     background(255);
     image(gameBackground,0,0);
     //Update buttons
     addObsButton.update();
     addUnitsButton.update();
     addParticles.update();
     clearButton.update();
     
     //Display add units button
     addObsButton.display();
     addUnitsButton.display();
     addParticles.display();
     clearButton.display();
     
     box2d.step();
     
     AI.update(); 
      
       // Always alert the spring to the new mouse location
     spring.update(mouseX,mouseY);
     spring.display();
    
     gameState.draw();
     
     if (L_MOUSE == true)
      sBox.updateBox();//update the SelectionBox 
  }
  else if(game_display == STARTUP)  //Show startup screen
  {
    background(255);
    image(startBackground,0,0);
    
    //Update buttons
    startButton.update();
    debugButton.update();
    
    //Display buttons
    startButton.display();
    //debugButton.display();
    //drawSpotLight();
  }
  else if(game_display == INSTRUCTIONS)
  {
      background(255);
      image(gameBackground, 0, 0);
      
      PFont font;
      font = loadFont("AmericanTypewriter-24.vlw"); 
      textFont(font); 
      //translate(width/4,height/2,0);     
      fill(255);
      text("Instructions...Please press Enter to start the game",width/4, height/2,0);     
  }
  else if(game_display == GAME_WIN)
  {
      background(255);
      image(winBackground, 0, 0);
      PFont font;
      font = loadFont("AmericanTypewriter-24.vlw"); 
      textFont(font); 
      translate(0,height/2-3);     
      text("You have WON!!!...press Q to start again",width/2, height/2,0);   
  }
  else if(game_display == GAME_LOSE)
  {
      background(255);
      image(loseBackground, 0, 0);
      PFont font;
      font = loadFont("AmericanTypewriter-24.vlw"); 
      textFont(font); 
      fill(255);
      translate(0, height/2-3);
      text("You have been defeated...press Q to start again",width/2, height/2,0);   
  }
  else if(game_display == PAUSE)
  {
      for(int i = 0; i < gameState.particles.size(); i++)
        ((Particle) gameState.particles.get(i)).display();
      
      for(int i = 0; i < gameState.obstacles.size(); i++)
        ((Obstacle) gameState.obstacles.get(i)).display();
        
      PFont font;
      font = loadFont("AmericanTypewriter-24.vlw"); 
      textFont(font); 
      text("GAME PAUSED. Press Enter to resume.",width/4, height/2,0);   
      //textSize(50);      
      fill(255);
      //translate(width/4,height/2,0);     
      text("GAME PAUSED. Press Enter to resume.",width/4, height/2,0);   
//  private ArrayList prison = new ArrayList();
//  private ArrayList obstacles = new ArrayList();
//  private ArrayList lightParticles = new ArrayList();
//  private ArrayList edges = new ArrayList();
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
      float maxdist = 100;//dist(0,0,width,height);
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

