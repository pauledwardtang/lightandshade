class AIPlayer{
  LightMap lightmap = new LightMap();
 AIPlayer()  
 {
 } 
 

 void update()
 {
     movementManager();
     lightmap.update();
 }
 
 void movementManager()
 {
     moveUnits();
 }
 
 void moveUnits(){
   
     for(int i = 0; i < gameState.particles.size(); i++)
    {
      Particle temp = (Particle) gameState.particles.get(i);
      String name = temp.body.getUserData().getClass().getName();
      boolean moveFlag = false;
      if(name.contains("$Shade"))
      {
        temp = (Shade) temp;
        moveFlag = true;
      }
      else if(name.contains("Eye"))
      {
        temp = (Eye) temp;
        moveFlag = true;
      }
        
      if(moveFlag && temp.owner.equals("enemy"))
      {
          if(!temp.blind){
            temp.setTarget(random(width), random(height));    //Replace this with a targeting system
            temp.MOVE_MODE = true;
            temp.threshold = 3;                   //Arbitrary number, it should reflect the number of units moving at once
            temp.move();  
          }
          else
            temp.MOVE_MODE = false;
      }
    }
 }
 
}

class LightMap{
  int cellsize = 1;
  int[][] lightmap = new int[WIDTH/cellsize][HEIGHT/cellsize];
  int timer = 0;
  
  LightMap(){
    for(int i = 0; i < WIDTH/cellsize; i++){
      for(int j = 0; j< HEIGHT/cellsize; j++){
        lightmap[i][j] = 0;
      }
    }
  }
  
  void update(){
    timer++;
      
    for(int i = 0; i < gameState.lightParticles.size(); i++){
      add((LightParticle)gameState.lightParticles.get(i));
    }
    for(int i = 0; i < WIDTH/cellsize; i++){
      for(int j = 0; j< HEIGHT/cellsize; j++){
        if(timer%1==0 && lightmap[i][j]>0)
          lightmap[i][j] = int(lightmap[i][j]*.8);
          
        if(lightmap[i][j]>1){
          pushMatrix();
          translate(i*cellsize,j*cellsize);
          noStroke();
          noFill();
          //fill(0,0,255,lightmap[i][j]*.3);

          rectMode(CENTER);
          stroke(random(35,45),500-lightmap[i][j],255,lightmap[i][j]*.5);
          //translate(random(-.5,.5),random(-.5,.5));
          rect(0,0,lightmap[i][j]/80,lightmap[i][j]/80);
          //point(0,0);

              
          popMatrix();
        }
      }
    }    
  }
  
  void add(LightParticle particle){
    Vec2 pos = box2d.getScreenPos(particle.body);
    int x = (int)pos.x/cellsize;
    int y = (int)pos.y/cellsize;
    if (lightmap[x][y]<512){
      lightmap[x][y] = lightmap[x][y] + 500;
    }
  }
  
}
