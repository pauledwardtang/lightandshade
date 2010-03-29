
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


class DarkUnit extends Unit{

  String owner;
  
  DarkUnit(){
    super();
    owner = "enemy";
  }
  
  DarkUnit(float x, float y)
  {
    super(x,y);
    owner = "enemy";
  }
  
  DarkUnit(float x, float y, String owner)
  {
    super(x,y);
    this.owner = owner;
  }
 
}//end EnemyUnit


class LightUnit extends Unit{

  String owner;
  
  LightUnit(){
    super();
    owner = "light";
  }
  
  LightUnit(float x, float y)
  {
    super(x,y);
    owner = "light";
  }
  
  LightUnit(float x, float y, String owner)
  {
    super(x,y);
    this.owner = owner;
  }
 
}//end LightUnit

//small unit, can manipulate blinded units
class Sprite extends LightUnit{
}

//Redirects light particles
class Prism extends LightUnit{
}

//small unit, can manipulate blinded units
class Shade extends DarkUnit{
}

//They're just there to be blinded. They each control their own troops
class Eye extends DarkUnit{
}



