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
import ddf.minim.*;

public static final int MAIN_GAME    = 1;
public static final int DEBUG        = 2;
public static final int INSTRUCTIONS = 3;
public static final int GAME_WIN     = 4;
public static final int GAME_LOSE    = 5;
public static final int STARTUP      = 6;
public static final int PAUSE        = 7;
public static final int CONTROLS     = 8;

static int game_display;

Minim minim;
AudioPlayer in, win;

// A reference to our box2d world
static PBox2D box2d;

// The Spring that will attach to the box from the mouse
Spring spring;
Particle attachedParticle;

//Selection stuff
SelectionBox sBox = new SelectionBox();
boolean L_MOUSE = false;
boolean R_MOUSE = false;
boolean playWin = false;

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

PFont font;

ImageButtons startButton, debugButton, addObsButton, addUnitsButton, addParticles,clearButton;
PImage startBackground, gameBackground, winBackground, loseBackground, controlsBackground;

void setup() {
  size(WIDTH, HEIGHT, OPENGL);
  background(255);
  colorMode(HSB);
  frameRate(30);

  //Creating minim object
  minim = new Minim(this);
  // load a file, default sample buffer size is 1024
  in = minim.loadFile("textSound.mp3");
  win = minim.loadFile("win.wav");
  // play the file
  //in.play();



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

  //Initialize the game display to the startup screen
  game_display = STARTUP;


  //Font
  font = loadFont("AmericanTypewriter-24.vlw"); 

  //Startup Image
  startBackground = loadImage("Light&Shade.png");
  gameBackground  = loadImage("background.jpg");
  winBackground   = loadImage("background2.jpg");
  loseBackground  = loadImage("youlose.jpg");
  controlsBackground = loadImage("ctrl_SelectionBox.jpg");

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
    playWin = true;
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

//      textFont(font); 
//    textAlign(LEFT,TOP); 
//    fill(0,0,255);
//    text("Light Timer: " + gameState.lightTimer, 10, 20, 0);    //Arbitrary padding
//    //textAlign(RIGHT,TOP);
//    translate(width - 200, 0);
//    text("Dark Timer: " + gameState.darkTimer, 0, 20, 0);  
//
//    translate(-width + 200, 0);
    
    
    stroke(0);
    fill(0,0,128);
    rect(175,35, 300, 20);
    noStroke();
    
    fill(0,0,255);
    rect(175,30, (300-gameState.lightTimer*2), 10);

    fill(0,0,50);
    rect(175,40, (gameState.darkTimer*2), 10);


    ////Display game end screen if the game is over
    if(gameState.victory == 1)  
    {
      game_display = GAME_WIN;
      win.play();
    }
    else if(gameState.victory == -1)
      game_display = GAME_LOSE;

    if(gameState.lightTimer > 0)
    {
      rectMode(CORNER);
      //fill(255);
      fill(0,0,0, gameState.lightTimer*1.5);
      rect(0, 0, WIDTH, HEIGHT);
      rectMode(CENTER);
    }

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

    textFont(font);  
    fill(0,0,255);
    textAlign(LEFT,TOP);
    text("\n\nGame Overview: \n\n " +
      "    The game is a two-player, competitive real-time strategy game. There is a light player and a dark player.\n" +
      "    The light player has a light source, prisms, and sprites. The dark player has eyes and shades.\n\n\n" +
      "                     Game Flow\n\n\n" + 
      "A typical game of Light and Shade should look like this:\n" +           
      "     1. Game starts, pieces scattered\n"+
      "     2. Light player rescues light units, captures dark units\n"+
      "     3. Dark player gathers its units as the light player advances, captures light units\n"+
      "     4. Dark player works to push into light player\n"+
      "     5. Light player works to capture dark eyes\n"+
      "     6. Game ends when all light units captured, or all dark eyes captured\n\n"+
      "Please press Spacebar to continue reading, press Enter to start the game", 0, 0, 0);
  }
  else if(game_display == GAME_WIN)
  {
    playWin = false;
    background(255);
    image(winBackground, 0, 0);
    textFont(font); 
    fill(0);
    textAlign(CENTER,BOTTOM);
    text("You have WON!!!...press R to start again, press Q for main menu.",width/2, height/2,0);   
  }
  else if(game_display == GAME_LOSE)
  {
    background(255);
    image(loseBackground, 0, 0);
    textFont(font); 
    fill(255);
    textAlign(CENTER,BOTTOM);
    //text("You have been defeated...press R to start again, press Q for main menu.");
    text("You have been defeated...press R to start again, press Q for main menu.",width/2, height,0);   
  }
  else if(game_display == PAUSE)
  {
    for(int i = 0; i < gameState.particles.size(); i++)
      ((Particle) gameState.particles.get(i)).display();

    for(int i = 0; i < gameState.obstacles.size(); i++)
      ((Obstacle) gameState.obstacles.get(i)).display();

    gameState.displayEdges();


    fill(0,100,200,100);  
    rect(WIDTH/2, HEIGHT/2-8, WIDTH, 40);  
    PFont font;
    fill(255);
    textAlign(CENTER);
    text("GAME PAUSED. Press Enter to resume, press R to start again, press Q for main menu.",width/2, height/2,0);  
  }  
  else if(game_display == CONTROLS)
  {
    background(255);
    image(controlsBackground, 0, 0);
    textFont(font); 
    fill(255);
    textAlign(CENTER,TOP);
    //text("You have been defeated...press R to start again, press Q for main menu.");
    text("Controls",width/2, 20, 0);   
    textAlign(CENTER, BOTTOM);
    text("Press enter to play!", width/2, height, 0);
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
      float maxdist = 200;//dist(0,0,width,height);
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

void stop()
{
  // always close audio I/O classes
  in.close();
  // always stop your Minim object
  minim.stop();

  super.stop();
}

