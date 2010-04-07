
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

//small unit, can manipulate blinded units
//can only move when light > 0
class Sprite extends Particle{
  
  DistanceSpring spring = new DistanceSpring();
  
  Sprite(float x, float y, int id)
  {
    super(x, y, 10, id, "player");
//    changeColor(0,g,0);
  }
  //redefine light when hit by a light particle
  void changeLight()
  {
    light = light + 10;
  }
  void update()
  {
    super.update();
    blind = false;
    if(light > -255)
    {
      light = light - 1;
    }
    if(light <= 0)
    {
      blind = true;
      spring.destroy();
    }
    col = color(light, light, 0);
  }
  
  void moveShade(Shade sh)
  {
    if(this.blind == false)
    {
     spring.bind(this, sh);
     spring.update(this, sh);
    }
  }
  
  boolean done()
  {
    return false;
  }
}

//Redirects light particles
class Prism extends Particle{
    Prism(float x, float y, int id)
  {
      super(x, y, 20, id, "player");
      changeColor(255,255,100);
  }
  boolean done()
  {
    return false;
  }
}

//small unit, can manipulate blinded units
class Shade extends Particle{
  //can only move when light < 255
  DistanceSpring spring = new DistanceSpring();
  
  Shade(float x, float y, int id)
  {
      super(x, y, 10, id, "enemy");
  }
  //redefine light when hit by a light particle
  void changeLight()
  {
    light = light + 10;
  }
  void moveSprite(Sprite spr)
  {
    if(this.blind == false)
    {
      spring.bind(this, spr);
      spring.update(this, spr);
    }
  }
  void update()
  {
    super.update();
    blind = false;
    if(light >= 255)
    {
      blind = true;
      spring.destroy();
    }
    col = color(255, light, light);
  }
    boolean done()
  {
    return false;
  }
}

//They're just there to be blinded. They each control their own troops
class Eye extends Particle{
  
  Eye(float x, float y, int id)
  {
      super(x, y, 30, id, "enemy");
      changeColor(50,50,50);
  }
  boolean done()
  {
    return false;
  }
}
/*Each particle, when selected, needs to find out who it's owned by and whether it is blinded or not*/
