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
  int cellsize = 10;
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
        if(timer%10==0 && lightmap[i][j]>0)
          lightmap[i][j] = lightmap[i][j]-1;
          
        if(lightmap[i][j]>5){
          pushMatrix();
          translate(i*cellsize,j*cellsize);
          noStroke();
          
          fill(255,0,255,lightmap[i][j]*.1);

          rectMode(CENTER);
          if (cellsize == 1)
          {
            stroke(255,0,255,lightmap[i][j]*.25);
            point(0,0);
          }
          else{
            //stroke(255,0,255,lightmap[i][j]*.1);
            //ellipse(0,0,cellsize+2,cellsize+2);
            rect(0,0,3*cellsize,3*cellsize);
          }
          popMatrix();
        }
      }
    }    
  }
  
  void add(LightParticle particle){
  Vec2 pos = box2d.getScreenPos(particle.body);
  int x = (int)pos.x/cellsize;
  int y = (int)pos.y/cellsize;
  lightmap[x][y] = lightmap[x][y] + 1;
  }
  
}
