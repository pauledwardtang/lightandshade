
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

interface Manipulator{
  boolean canGrab(Particle target);
  void grab(Particle target);
  void attach(Particle target);
  void release(Particle target);
}


//small unit, can manipulate blinded units
//can only move when light > 0
class Sprite extends Particle implements Manipulator{
  DistanceSpring spring = new DistanceSpring();
  ArrayList grabList = new ArrayList();
  
  Sprite(float x, float y, int id)
  {
    super(x, y, 8, 5, id, "player", 4);
//    changeColor(0,g,0);
  }
  void update()
  {
    super.update();
    manipulation();
    
    //decides color based on light
    if(light < 30)
    {
      blind = true;
      col = color(150, 55, light+100);
    }
    else
    {
      blind = false; 
      col = color(150, 255, light+100);
    }

    if (light > 0)//decrease light level
      light = light-1;
      
  }//end update
  
  //Handles manipulation-relted stuff. Mostly exists to clean up update()
  void manipulation(){
    
    Body target;
    if (spring.distanceJoint != null)
    {
      target = spring.distanceJoint.getBody2();
      Object obj = target.getUserData();
      for(int i=0;i <grabList.size();i++){
        Particle temp = (Particle)grabList.get(i);
          
        if (obj.getClass().getSuperclass().getName().contains("$Particle"))//check if connected thing is a particle
        {
          Particle p = (Particle) obj;
          if (!p.blind){
            spring.destroy();//if anything attached is blind, everything detaches...
          }
          if(!canGrab(p)){
            spring.destroy();//detaches if attached particle is not on the list
          }
        }
      } 
    }
    
    for(int i=0;i <grabList.size();i++){
      Particle temp = (Particle)grabList.get(i);
      if (!temp.blind)//not blind? get off my list!
        {
          grabList.remove(i);
        }    
    }    
    
    //clears manipulation list when blinded, destroys spring
    if (blind){
      grabList.clear();
      spring.destroy();
    }  
  }//end manipulation
  
  void moveShade(Shade sh)
  {
    if(this.blind == false)
    {
     spring.bind(this, sh);
     spring.update(this, sh);
    }
  }

  //manipulation method
  boolean canGrab(Particle target){
    return !grabList.contains(target);
  }
  
  //right now it seems possible to add the same unit multiple times. Not sure if that's a problem or not.
  void grab(Particle target){
    if (target.blind && !grabList.contains(target))//check if target is blind and if it is already on the list
    {
      grabList.add(target);
    }
  }

  //releases a particle from the grablist
  void release(Particle target){
    while (grabList.indexOf(target)!=-1){
      grabList.remove(grabList.indexOf(target));
    }
  }
  
  //manipulation method
    void attach(Particle target)
    {
      if(!blind && grabList.contains(target))
      {
       spring.bind(this, target);
       spring.update(this, target);
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
        stroke(90,255,255);
        strokeWeight(2);
      }
      else{
        stroke(255);
        strokeWeight(1);
       }
       
      fill(col,150); 
      ellipse(0,0,radius*2,radius*2);//outer circle
      fill(col);
      noStroke();
      ellipse(0,0,radius,radius);//inner circle
   
      popMatrix();
  } 
  
}//end Sprite


//small unit, can manipulate blinded units
class Shade extends Particle implements Manipulator{
  //can only move when light < 255
  DistanceSpring spring = new DistanceSpring();
  ArrayList grabList = new ArrayList();
  
  Shade(float x, float y, int id)
  {
      super(x, y, 8, 5, id, "enemy", 8);
  }

  void moveSprite(Sprite spr)
  {
    if(this.blind == false)
    {
      spring.bind(this, spr);
      spring.update(this, spr);
    }
  }
  
  //manipulation method
  boolean canGrab(Particle target){
    return !grabList.contains(target);
  }
  
  //right now it seems possible to add the same unit multiple times. Not sure if that's a problem or not.
  void grab(Particle target){
    if (target.blind && !grabList.contains(target))//check if target is blind and if it is already on the list
    {
      grabList.add(target);
    }
  }

  //releases a particle from the grablist
  void release(Particle target){
    while (grabList.indexOf(target)!=-1)
      grabList.remove(grabList.indexOf(target));
  }
  
  //manipulation method
    void attach(Particle target)
    {
      if(!blind && grabList.contains(target))
      {
       spring.bind(this, target);
       spring.update(this, target);
      }
    }  
  
  void update()
  {
    super.update();
    manipulation();
    
    if(light >= 60)
    {
      blind = true;
      col = color(10, 100, 100+light);
      spring.destroy();
    }
    else
    {
      blind = false; 
      col = color(10, 255, 100+light);
    }
    
    if (light > 0)//decides color based on light
      light = light-1;
  }
  
  //Handles manipulation-related stuff. Mostly exists to clean up update()
  void manipulation(){
    
    Body target;
    if (spring.distanceJoint != null)
    {
      target = spring.distanceJoint.getBody2();
      Object obj = target.getUserData();
      for(int i=0;i <grabList.size();i++){
        Particle temp = (Particle)grabList.get(i);//an item on the grab list
          
        if (obj.getClass().getSuperclass().getName().contains("$Particle"))//check if connected thing is a particle
        {
          Particle p = (Particle) obj;
          if (!p.blind)
          {
            spring.destroy();//if anything attached is blind, everything detaches...
          }
          if(!canGrab(p)){
            spring.destroy();//detaches if attached particle is not on the list
          }
        }
      } 
    }
    
    for(int i=0;i <grabList.size();i++){
      Particle temp = (Particle)grabList.get(i);
      if (!temp.blind)//not blind? get off my list!
        {
          grabList.remove(i);
        }    
    }
    
    //clears manipulation list when blinded, destroys spring
    if (blind){
      grabList.clear();
      spring.destroy();
    }  
  }//end manipulation
  
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
      stroke(10);
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
      super(x, y, 24, 50, id, "enemy", 8);
      changeColor(50,50,50);
      a = s = 0.0;
  }
  boolean done()
  {
    return false;
  }
  
  void update()
  {
    super.update();
    
    if(light >= 170)
    {
      blind = true;
    }
    else
    {
      blind = false; 
    }
    
    if (light > 1)
      light = light-2;
    else if (light > 0)
      light = light-1;
  }
  
  //change light value, overrides Particle's version
  void changeLight()
  {
    if (light<=290)
      light = light + 10;
    else if (light > 290 && light < 300)
      light = 300;//set to max
    else if (light <= 0)
      light = 0;//zero is minimum
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

    if(!blind)
    {
        fill(10,255,80+light/2);
        ellipse(0,0,radius*2,radius*2);//outer circle
        a = a + random(0.16);
        s = cos(a)*1.5;    
        
        fill(25,200,200+light/4);
        ellipse(0,0, radius*1.7+2*s, radius*1.8+s);//inner ellipse
        
        s = cos(a)*2;   
        fill(0);
        ellipse(0,0, radius*0.3-s, radius*1.5+s*2);//slit
    }
    else
    {
        fill(10,155,80+light/2);
        ellipse(0,0,radius*2,radius*2);//outer circle
        a = a + random(0.5);
        s = cos(a)*1.5;    
        
        fill(25,200,200+light/4);
        ellipse(0,0, radius*1.5+2*s, radius*1.6+s);//inner ellipse
        
        s = cos(a)*1.5;   
        fill(0);
        ellipse(0,0, radius*0.1-s, radius*1.1+s*2);//slit
    }
    popMatrix();
  }//end display
  
}
/*Each particle, when selected, needs to find out who it's owned by and whether it is blinded or not*/
