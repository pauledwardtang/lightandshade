import java.util.ArrayList;
/*
Terrain (2D) Should have:
-Coordinates
-List of objects (units, obstacles)
-random generator for placing units
-load preset maps randomly
-texture
*/
class Terrain{
  
  //Coordinates
  private int WIDTH;
  private int HEIGHT;
  
  //Obstacle size (rectangles)
  static final int OBS_WIDTH = 100;
  static final int OBS_HEIGHT = 100;
  
  //List of objects
  private ArrayList units = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  private Boolean terrainDisplayEnable;
  
  Terrain(int width, int height)
  {
    randomizeObstacles();
  } 
  
  //Randomly initializes obstacles
  private void randomizeObstacles()
  {
    for(int i = 0; i < random(50); i++)
      obstacles.add(new Obstacle(random(width-50), random(height-50), random(OBS_WIDTH), random(OBS_HEIGHT)));

  }
  
  //Returns a list of obstacles
  ArrayList getObstacles()
  {
    return obstacles;
  }
  
  //Displays obstacles
  public void displayObstacles()
  {
      for(int i = 0; i < obstacles.size(); i++)
     {
        Obstacle obs = (Obstacle) obstacles.get(i);
        obs.display();
     } 
  }
  
  //Draw
  void draw()
  {
    if(terrainDisplayEnable)
      displayObstacles();
  }
  
  void setTerrainDisplayEnable(Boolean val)
  {
    terrainDisplayEnable = val;
  }
  
  
}
