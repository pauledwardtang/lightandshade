
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

class Obstacle extends GameObject{
  
  Obstacle(float xpos, float ypos)
  {
    super(xpos, ypos);
  }
}
