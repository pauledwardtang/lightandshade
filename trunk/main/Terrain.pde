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
  
  //List of objects
  private ArrayList units = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  
   Terrain()
  {
    randomizeObstacles();
  } 
  
  void randomizeObstacles()
  {
    for(int i = 0; i < 10; i++)
    {
      obstacles.add(new Obstacle(random(800), random(600)));
    }
  }
  ArrayList getObstacles()
  {
    return obstacles;
  }
  
  
  
}
