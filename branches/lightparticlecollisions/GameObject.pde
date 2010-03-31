
class GameObject
{
   public PImage img, icon; 
   
   float x, y, w, h; // X-coordinate, y-coordinate
         
   GameObject()
   {
   }
   
   //All dimensions given
   GameObject (float xpos, float ypos, float w_, float h_)
   {
     x = xpos;
     y = ypos;
     w = w_;
     h = h_;
   }
   
   //Dimensions obtained from provided pImage
   GameObject (float xpos, float ypos, PImage img)
   {
     x = xpos;
     y = ypos;
     this.img = img;
     w = img.width;
     h = img.height;
   }

   GameObject (float xpos, float ypos)
   {
     x = xpos;
     y = ypos;
     this.img = img;
   }
   //Display the image on the screen at specified X,Y
   void display(float x, float y)
   {
     if(img == null)
     {
        fill(0);
        stroke(0);
        rectMode(CENTER);
        rect(x,y,w,h);
   
     }
     else
       image(img, x, y);
   }
   
   //Display the image on the screen at local X,Y
   void display()
   {
     if(img == null)
     {
        fill(0);
        stroke(0);
        rectMode(CENTER);
        rect(x,y,w,h);
   
     }
     else
       image(img, x, y);
   }
}


class Unit extends GameObject{
  float light, radius;
  boolean lit = false;
  
  Unit(){
    radius = 8;
    x = random(0+radius,width-radius);//spawn it somewhere on the screen
    y = random(0+radius,height-radius);
    light = 1;
  }
  
  Unit(float x, float y)
  {
    super(x,y);
    radius = 8;
    light = 1;
  }
  void update(){
    if (light > 0){
      moveToward(mouseX, mouseY);
      
     // light = light*.98;//reduces light over time
     light = 1;//this line for test purposes
    }  
  }//end unit.update
  
  void draw(){
    color cl = color(105, 105+75*light, 0);
    fill(cl);
    stroke(2);
    ellipse(x, y, radius, radius);
    noFill();
    noStroke();
  }//end unit.draw
  
  
  //this is garbage, make it circular
  void moveToward(float xin, float yin){
    if(dist(xin,yin,x,y)>1){
    
    if(mouseX-x>1)
      x = x + light;
      else if (mouseX-x<-1)
      x = x - light;     
      
    if(mouseY-y>1)
      y = y + light;
      else if (mouseY-y<-1)
      y = y - light;      
    }
  }
  
}//end Unit

//small unit, can manipulate blinded units
class Sprite extends Particle{
    Sprite(float x, float y, int id)
  {
    super(x, y, 10, id, "player");
    changeColor(0,255,0);
  }
}

//Redirects light particles
class Prism extends Particle{
    Prism(float x, float y, int id)
  {
      super(x, y, 20, id, "player");
      changeColor(255,255,0);
  }
}

//small unit, can manipulate blinded units
class Shade extends Particle{
    Shade(float x, float y, int id)
  {
      super(x, y, 10, id, "enemy");
      changeColor(100,100,100);
  }
}

//They're just there to be blinded. They each control their own troops
class Eye extends Particle{
  
  Eye(float x, float y, int id)
  {
      super(x, y, 30, id, "enemy");
      changeColor(50,50,50);
  }
}
//
//class LightSourceDebug extends Particle{
// float spawnAngle;
// int groupID = -1;
// 
//  ArrayList particles = new ArrayList();
//  
//  LightSourceDebug(int x, int y, int id)
//  {
//    super(x, y, 40, id, "lightsource");
//    spawnAngle = radians(75);
//    //makeBody(x, y, radius);
//    //body.setUserData(this);
//  }
//
//  //adds k new particles to the particle list.
//  ArrayList spawn(int k)
//  {
//    float dir = random(radians(-spawnAngle/2), radians(spawnAngle/2));
//    float xin, yin;
//    
//    for(int i = 0; i < k; i++)
//     {
//       //must be inside the LightSource
//        xin = random(x-radius, x+radius);
//        yin = random(y-radius, y+radius);
//        particles.add(new LightParticle(xin, yin, dir, groupID)); 
//        println("Particle spawned");
//     }
//     return particles;
//  } 
//  
//  void display()
//  {
//    // We look at each body and get its screen position
//    Vec2 pos = box2d.getScreenPos(body);
//    // Get its angle of rotation
//    float a = body.getAngle();
//    pushMatrix();
//    translate(pos.x,pos.y);
//    rotate(a);
//    fill(color(255, 0, 0, 100));
//    stroke(0);
//    strokeWeight(1);
//    ellipse(0,0,radius*2,radius*2);
//    // Let's add a line so we can see the rotation
//    line(0,0,radius,0);
//    popMatrix();
//  
//  }
//  
//  //puts all particles in list on screen. Should be called after every spawn().
//  void displayParticles()
//  {
//    for(int i = 0; i < particles.size(); i++)
//    {
//      LightParticle temp = (LightParticle) particles.get(i);
//      if(temp.isAlive() == true)
//      {
//        temp.update();
//        temp.display();
//      }
//      else
//      {
//        particles.remove(i);
//      }
//    }
//  }
//  void update()
//  {
//    //spawn(5);
//    //displayParticles();
//  }
//  
//  void makeBody(float x, float y, float r) {
//    super.makeBody(x, y, r, groupID);
//    body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
//  }
//  
//  void draw(){
//    color cl = color(255, 0, 0);
//    fill(cl);
//    stroke(2);
//    ellipse(x, y, radius, radius);
//    noFill();
//    noStroke();
//    
//    
//  }//end draw
//}



