
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
    super(x, y, 9, id, "player", 4);
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
      col = color(100, 100, 100);
      spring.destroy();
    }
    col = color(light, light, 100);
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
void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    //float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    //rotate(a);
    fill(col);
    if(isSelected)
    {
      stroke(0,255,0);
      strokeWeight(2);
    }
    else{
      stroke(255);
      strokeWeight(1);
     }
    
    ellipse(0,0,radius*2,radius*2);
    popMatrix();
  } 
  
}

//Redirects light particles
class Prism extends Particle{
    Prism(float x, float y, int id)
  {
      super(x, y, 18, id, "player", 4);
      changeColor(255,255,100);
  }
  boolean done()
  {
    return false;
  }
    void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    //float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    //rotate(a);
    fill(col,50);
    if(isSelected)
    {
      stroke(0,255,0);
      strokeWeight(4);
    }
    else
      stroke(200,200,255);
      strokeWeight(2);
    
    ellipse(0,0,radius*2,radius*2);
    noStroke();
    fill(255);
    ellipse(0,0, radius,radius);
    popMatrix();
  }//end display 
  
}// end prism

//small unit, can manipulate blinded units
class Shade extends Particle{
  //can only move when light < 255
  DistanceSpring spring = new DistanceSpring();
  
  Shade(float x, float y, int id)
  {
      super(x, y, 7, id, "enemy", 8);
  }
  //redefine light when hit by a light particle
  void changeLight()
  {
    if(light < 610)
    {
      light = light + 10;
    }
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
      col = color(200, 200, 200);
      spring.destroy();
    }
    col = color(200, light, light);
  }
    boolean done()
  {
    return false;
  }
    void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    //float a = body.getAngle();
    pushMatrix();
    //rotate(a);
    fill(col);
    if(isSelected)
    {
      stroke(0);
      strokeWeight(2);
    }
    else
    {  
      stroke(0);
      strokeWeight(2);
    }
    //translate(oldPos.x, oldPos.y);  
   //ellipse(0,0,radius*1.5,radius*1.5);//old position
    translate(pos.x,pos.y);
    ellipse(0,0,radius*2,radius*2);//current position
    
    popMatrix();
  }
}//end shade

//They're just there to be blinded. They each control their own troops
class Eye extends Particle{
  float a, s;//used in animation
  Eye(float x, float y, int id)
  {
      super(x, y, 24, id, "enemy", 8);
      changeColor(50,50,50);
      a = s = 0.0;
  }
  boolean done()
  {
    return false;
  }
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    //float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    //rotate(a);
    if(isSelected)
    {
      stroke(255,0,0);
      strokeWeight(2);
    }
    else
      noStroke();
    
    fill(100,0,0);
    ellipse(0,0,radius*2,radius*2);//outer circle
    a = a + random(0.16);
    s = cos(a)*1.5;    
    
    fill(155,100,50);
    ellipse(0,0, radius*1.7+2*s, radius*1.9+s);//inner ellipse
    
    s = cos(a)*2;   
    fill(0);
    ellipse(0,0, radius*0.3-s, radius*1.5+s*2);//slit
    popMatrix();
  }//end display
  
}
/*Each particle, when selected, needs to find out who it's owned by and whether it is blinded or not*/
