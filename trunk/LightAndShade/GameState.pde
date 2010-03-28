import java.util.ArrayList;
/*
GameState (2D) Should have:
-Coordinates
-List of objects (units, obstacles)
-random generator for placing units
-load preset maps randomly
-texture
*/
class GameState{
  
  //Coordinates
  private int WIDTH;
  private int HEIGHT;
  
  //Obstacle size (rectangles)
  static final int OBS_WIDTH = 150;
  static final int OBS_HEIGHT = 150;
  
  //List of objects
  private ArrayList units = new ArrayList();
  private ArrayList particles = new ArrayList();
  
  ArrayList selectedParticles = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  private ArrayList lightSources = new ArrayList();

  
  GameState(int width, int height)
  {
    randomizeObstacles();
    createUnits();
    createParticles();
    createLightSources();
  } 
  
  GameState(int width, int height, int range)
  {
    randomizeObstacles();
    createUnits(range);
    createLightSources();
  } 
  
  //Randomly initializes obstacles
  private void randomizeObstacles()
  {
    for(int i = 0; i < random(10) + 1 ; i++)
      obstacles.add(new Obstacle(random(width-50), random(height-50), OBS_WIDTH, OBS_HEIGHT));

  }
  
    //Initializes particles (random number from 1 to 10)
  private void createParticles()
  {
    for(int i = 0; i < 10; i++)
      particles.add(new Particle(10));
  }
  
  //Initializes units (random number from 1 to 10)
  private void createUnits()
  {
    for(int i = 0; i < random(10) + 1; i++)
      units.add(new Unit());
  }
  
  //Initializes units (random number from a specified range)
  private void createUnits(int range)
  {
    for(int i = 0; i < random(range); i++)
      units.add(new Unit());
  }
  
  //Initialize light source
  private void createLightSources()
  {
    lightSources.add(new LightSource());
  }
  
  //Returns a list of obstacles
  public ArrayList getObstacles()
  {
    return obstacles;
  }
  
  //Returns a list of Units
  ArrayList getUnits()
  {
    return units;
  }
  
  //Displays obstacles
  public void updateObstacles()
  {
      for(int i = 0; i < obstacles.size(); i++)
     {
        Obstacle obs = (Obstacle) obstacles.get(i);
        obs.display();
     } 
  }
  
  //Displays units
  public void displayUnits()
  {
      for(int i = 0; i < units.size(); i++)
     {
        Unit temp = (Unit) units.get(i);
        temp.update();
        temp.draw();
     } 
  }
  
    //Displays particles
  public void updateParticles()
  {
      selectedParticles.clear();
      for(int i = 0; i < particles.size(); i++)
     {
        Particle temp = (Particle) particles.get(i);
        
        //Move the selected particle to the mouse X,Y position
//        if(temp.isSelected && mousePressed)
//          temp.update(mouseX, mouseY);
        
        if(temp.isSelected)
          selectedParticles.add(temp);
          
        temp.update();
        temp.display();

     } 
  }
  
  //displays light source
  public void updateLightSources()
  {
    for(int i = 0; i < lightSources.size(); i++)
    {
      LightSource temp = (LightSource) lightSources.get(i);
      temp.update();
      temp.display();
    }
  }
  
  public ArrayList getLightSource()
  {
    return lightSources;
  }
  
  
  //Kills all particle bodies
  void removeParticles()
  {
     for(int i = 0; i < particles.size(); i++)
     {
        Particle temp = (Particle) particles.get(i);
        temp.killBody();
     } 
     particles.clear();
     selectedParticles.clear();
  }
  
  //Kills all obstacle bodies
  void removeObstacles()
  {
         for(int i = 0; i < obstacles.size(); i++)
     {
        Obstacle temp = (Obstacle) obstacles.get(i);
        temp.killBody();
     } 
     obstacles.clear();
  }
  
  //Draw
  void draw()
  {
      updateObstacles();
      //displayUnits();
      updateParticles();
      updateLightSources();
  }

  
  
}
