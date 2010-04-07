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
  
  //Obstacle size (rectangles)
  static final int OBS_WIDTH = 150;
  static final int OBS_HEIGHT = 150;
  
  //List of objects
  private ArrayList units = new ArrayList();
  private ArrayList particles = new ArrayList();
  
  ArrayList selectedParticles = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  private ArrayList lightSources = new ArrayList();
  private ArrayList lightParticles = new ArrayList();

  GameState(int width, int height)
  {
    randomizeObstacles();
    createUnits();
    //createParticles();
    //createLightSources();
  } 
  
  GameState(int width, int height, int range)
  {
    randomizeObstacles();
 //   createUnits(range);
    createLightSources();
  } 
  
  //Randomly initializes obstacles
  private void randomizeObstacles()
  {
    for(int i = 0; i < random(10) + 1 ; i++)
      obstacles.add(new Obstacle(random(width-50), random(height-50), OBS_WIDTH, OBS_HEIGHT));

  }
  
  //Initializes units (random number from 1 to 10)
  private void createUnits()
  {
    //Dark Units
    
        //Shades
        for(int i = 0; i < 1; i++)
          particles.add(new Shade( 200 ,50, i));
          
        //Eyes
            for(int i = 0; i < 1; i++)
          particles.add(new Eye(200, 200, i));
    
    //Light Units
    
        //LightSource
        createLightSources();
        
        //Light particles
        createLightParticles();
        
        //Sprites
        for(int i = 0; i < 1; i++)
          particles.add(new Sprite(WIDTH-200, HEIGHT-200, i));
          
        //Prisms
            for(int i = 0; i < 1; i++)
          particles.add(new Prism(WIDTH-500, HEIGHT-500, i));
  }
  
  //FOR DEBUGGING PURPOSES
  //Initializes units (random number from a specified range)
//  private void createUnits(int range)
//  {
//    for(int i = 0; i < random(range); i++)
//      units.add(new Unit());
//  }
  
  //Initialize light source
  private void createLightSources()
  {
    LightSource temp = new LightSource(WIDTH/2, HEIGHT/2, 0);
    particles.add(temp);
    lightSources.add(temp);
  }
  
  private void createLightParticles()
  {
    for(int i = 0; i < lightSources.size(); i++)
    {
      LightSource tempSource = (LightSource) lightSources.get(i);
      for(int k = 0; k < 4; k++)
      {
        LightParticle temp = tempSource.spawn();
        lightParticles.add(temp);
      }
    }
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
//  public void displayUnits()
//  {
//      for(int i = 0; i < units.size(); i++)
//     {
//        Unit temp = (Unit) units.get(i);
//        temp.update();
//        temp.draw();
//     } 
//  }
//  
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
        
         if(temp.done())
        {
          particles.remove(temp);
          selectedParticles.remove(temp);
//          println("Removed particle");
        }

     } 
  }
  
  //displays light source
  public void updateLightSources()
  {
    for(int i = 0; i < lightSources.size(); i++)
    {
      LightSource temp = (LightSource) lightSources.get(i);
      temp.update(lightParticles);
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
//      println(particles.size());
  } 
}
