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
      if(temp.body.getUserData().getClass().getName().contains("Shade") || temp.body.getUserData().getClass().getName().contains("Eye"))
      {
        if(temp.owner.equals("enemy")){
          temp.setTarget(mouseX,mouseY);//width/2, height/2);    //Replace this with a targeting system
          temp.threshold = 3;                   //Arbitrary number, it should reflect the number of units moving at once
          temp.move();
        }
      }         
    }
 
 }
 
}
