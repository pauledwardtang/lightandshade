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
  int lightUnits = 0;
  int darkUnits = 0;
  int lightTimer = 0;
  int darkTimer = 0;
  
  //List of objects
  private ArrayList particles = new ArrayList();
  
  ArrayList selectedParticles = new ArrayList();
  private ArrayList prison = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  private ArrayList lightParticles = new ArrayList();
  private ArrayList edges = new ArrayList();

  GameState(int width, int height)
  {
    randomizeObstacles();
    //createPrison();
    createUnits();
    createEdges();
  } 
//  
//  GameState(int width, int height, int range)
//  {
//    randomizeObstacles();
//    createLightSources();
//  } 
//  

  private void createEdges()
  {
    Edge topEdge = new Edge(WIDTH/2, 10, WIDTH, 20);
    Edge bottomEdge = new Edge(WIDTH/2, HEIGHT-10, WIDTH, 20);
    Edge leftEdge = new Edge(10, HEIGHT/2, 20, HEIGHT);
    Edge rightEdge = new Edge(WIDTH-10, HEIGHT/2, 20, HEIGHT);
    edges.add(topEdge);
    edges.add(bottomEdge);
    edges.add(leftEdge);
    edges.add(rightEdge);
  }
  
  private void displayEdges()
  {
    for(int i = 0; i < edges.size(); i++)
    {
      Edge temp = (Edge) edges.get(i);
      temp.display();
    }
  }

 private void createPrison(){
   
   prison.add(new PlayerPrison(0));
   
   prison.add( new EnemyPrison(1));
   
   
 }
  //Randomly initializes obstacles
  private void randomizeObstacles()
  {
      obstacles.add(new Obstacle(random(width - 300,width-250), random(height-300,height-250)));
      
      obstacles.add(new Obstacle(random(width - 600,width-550), random(height-700,height-650)));
      
      obstacles.add(new Obstacle(random(width - 890,width-840), random(height-350,height-300)));
      

  }
  
  //Initializes units (random number from 1 to 10)
  private void createUnits()
  {
    //Dark Units
    
        //Shades
        for(int i = 0; i < 15; i++)
          particles.add(new Shade( random(width-91,width-10),random(height/2-100,height/2+100),i));//200 ,50, i));
          
        //Eyes
            for(int i = 0; i < 3; i++)
          particles.add(new Eye( random(width-91,width-10),random(height/2-100,height/2+100),i));//200, 200, i));
    
    //Light Units
    
        //LightSource
          particles.add(new LightSource(WIDTH/8, HEIGHT/2, 0));
        
        
        //Light particles
        //createLightParticles();
        
        //Sprites
        for(int i = 0; i < 10; i++)
          particles.add(new Sprite(random(10,width/3),random(100,height-100),i));//WIDTH-200, HEIGHT-200, i));
          
        //Prisms
        for(int i = 0; i < 3; i++)
          particles.add(new Prism(random(10,width/5),random(200,height-200),i));//WIDTH-500, HEIGHT-500, i));
//          particles.add(new Prism(width/4,height/2-200,1));
//          particles.add(new Prism(width/4,height/2+200,2));
  }
  
  //Returns a list of obstacles
  public ArrayList getObstacles()
  {
    return obstacles;
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
  
 //Displays Prison
   void updatePrison(){
     for(int i = 0; i < prison.size(); i++)
     {
       Prison pri = (Prison) prison.get(i);
         pri.display();
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
        if(temp.body.getUserData().getClass().getName().contains("$LightSource"))
        {
              lightParticles.add(((LightSource) temp).spawn());
              lightParticles.add(((LightSource) temp).spawn());
        }      
        //let all the prisms update the lightParticles with their produced particles
        if(temp.body.getUserData().getClass().getName().contains("$Prism"))
            if(((Prism) temp).light >= 190)
            {
              lightParticles.add(((Prism) temp).spawn());
              
            }
            else if(((Prism) temp).light >= 170)
            {
              lightParticles.add(((Prism) temp).spawn());
            }
              
        temp.update();
        temp.display();
        //temp.move();
        
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
      
      if(!temp.isAlive())
          lightParticles.remove(temp);
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

void checkVictoryConditions(){
  lightUnits = 0;
  darkUnits = 0;
  //count lit units, blind eyes
  for(int i = 0; i < particles.size(); i++){
    
    Particle unit = (Particle)particles.get(i);
    String name = unit.getClass().getName();
    
    //light unit
    if(name.contains("Sprite") || name.contains("Prism")){
      if (!unit.blind)
        lightUnits = lightUnits+1;
    }
    //dark unit
    if(name.contains("Eye")){
      if (unit.blind)
        darkUnits = darkUnits+1;
    }
  }
  
  if(lightUnits<=0){
    lightTimer++;
  }
  else
    lightTimer = 0;
    
  if(darkUnits>=3){
    darkTimer++;
  }
  else
    darkTimer = 0;
  
  if (lightTimer >=150 && darkTimer<150){//dark victory
    println("Dark Victory");//dark victory
    game_display = GAME_LOSE;
  }
  else if(lightTimer< 150 && darkTimer>=150){ //light victory
    println("Light Victory");//light victory
    game_display = GAME_WIN;
  }
  else if(lightTimer>=150 && darkTimer >=150){//rare state- draw
  //do nothing, wait for it to do one of the others
  }
  
}

  //Draw
  void draw()
  {
      displayLightParticles();
      updateParticles();
      updateObstacles();
      //updatePrison();
      displayEdges();
      checkVictoryConditions();
  }  
}
