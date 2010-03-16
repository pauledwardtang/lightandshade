
class GameObject
{
   private PImage icon;
   private PImage myImage; 
   
   private float x, y; // X-coordinate, y-coordinate
   GameObject (float xpos, float ypos)
   {
     x = xpos;
     y = ypos;
   }
   
   float getX()
   {
     return x;
   }
   float getY()
   {
     return y;
   }
   //Display the image on the screen
   void display(float x, float y)
   {
   }

}

/*
class Unit extends GameObject{
 
 Unit(float xpos, float ypos, int type) 
 {
   super(xpos, ypos);
   switch (type)
   {
     case 1:  //myImage = loadImage("base.gif"); break;
     case 2:
     case 3:
     case 4:
     default: break;
   
   }   
 }
 void display(float x, float y)
 {
   
 }
}
*/
class Obstacle extends GameObject{
  
  Obstacle(float xpos, float ypos)
  {
    super(xpos, ypos);
  }
}

class Unit{
  float x, y, light, radius;
  boolean lit = false;
  
  Unit(){
    radius = 8;
    x = random(0+radius,width-radius);//spawn it somewhere on the screen
    y = random(0+radius,height-radius);
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

class LightSource extends Unit{
  float radius;
  
  LightSource(){
  radius = 20;
  radius = 120;
  }
  
  void update(){}
  
  void draw(){
    color cl;
    
    //Light Ring
    cl = color(255,255,255,100);
    fill(cl);
    ellipse(x,y,radius*2,radius*2);
    noStroke();
    
    //Bulb
    cl = color(255, 255, 0);
    fill(cl);
    stroke(2);
    ellipse(x, y, radius*2, radius*2);
    noStroke();
    
    noFill();  
  }

}//end Light Source

class Sprite extends Unit{
}

class Prism extends Unit{
}


class Shade extends Unit{
}

class Eye extends Unit{
}



