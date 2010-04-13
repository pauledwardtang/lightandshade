class AIPlayer{
 

    //List of objects
  private ArrayList particles = new ArrayList();
  
  ArrayList selectedParticles = new ArrayList();
  private ArrayList obstacles = new ArrayList();
  private ArrayList lightParticles = new ArrayList();
  
  
 AIPlayer(ArrayList particles, ArrayList selectedParticles, ArrayList obstacles, ArrayList lightParticles)  
 {
     this.particles = particles;
     this.selectedParticles = selectedParticles;
     this.obstacles = obstacles;
     this.lightParticles = lightParticles;
 } 
 

 void update()
 {
     movementManager();
 }
 
 void movementManager()
 {
     moveUnits();
 }
 
 void moveUnits(){
   
     for(int i = 0; i < particles.size(); i++)
    {
      Particle temp = (Particle) particles.get(i);
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
