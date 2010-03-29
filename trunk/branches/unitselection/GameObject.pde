
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
  }
}

//Redirects light particles
class Prism extends Particle{
    Prism(float x, float y, int id)
  {
      super(x, y, 20, id, "player");
  }
}

//small unit, can manipulate blinded units
class Shade extends Particle{
    Shade(float x, float y, int id)
  {
      super(x, y, 10, id, "enemy");
  }
}

//They're just there to be blinded. They each control their own troops
class Eye extends Particle{
  
  Eye(float x, float y, int id)
  {
      super(x, y, 30, id, "enemy");
  }
}



