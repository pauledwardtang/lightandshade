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
  } 
//  
//  GameState(int width, int height, int range)
//  {
//    randomizeObstacles();
//    createLightSources();
//  } 
//  
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
          particles.add(new LightSource(WIDTH/2, HEIGHT/2, 0));
        
        
        //Light particles
        createLightParticles();
        
        //Sprites
        for(int i = 0; i < 1; i++)
          particles.add(new Sprite(WIDTH-200, HEIGHT-200, i));
          
        //Prisms
            for(int i = 0; i < 1; i++)
          particles.add(new Prism(WIDTH-500, HEIGHT-500, i));
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
        
        //Have LightSource give an int value that specifies the number of LightParticles to generate (i.e change the K value)
        if(temp.body.getUserData().getClass().getName().contains("LightSource"))
            for(int k = 0; k < 2; k++)
              lightParticles.add(((LightSource) temp).spawn());
          
        
        temp.update();
        temp.display();
        temp.move(selectedParticles.size());
        
        
        if(temp.done())
        {
          particles.remove(temp);
          selectedParticles.remove(temp);
          println("Removed particle");
        }
        

     } 
  }

    //puts all light particles in list on screen.
  void displayLightParticles()
  {
    for(int i = 0; i < lightParticles.size(); i++)
    {
      LightParticle temp = (LightParticle) lightParticles.get(i);
      
      temp.update();
      temp.display();
      
      if(temp.done() || !temp.isAlive())
        {
          lightParticles.remove(temp);
        }
    }
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
      updateParticles();
      displayLightParticles();
  }  
}
