//light source spawns light particles headed in a direction determined by its angle
//light source can be moved, and have its angle changed
class LightSource extends Particle{
  float spawnAngle;//direction of particles spawned
  float spawnSpread;//spread of spawn distribution
  float a, b, s;//used in animation
  
  LightSource(float x, float y, int id)
  {
    super(32, id, color(255, 175, 0), "player");
    makeBody(x, y, radius, 0x0002, 1.0);
    body.setUserData(this);
    target = new Target(x,y);
    a = b = s = 0.0;
    spawnSpread = .5;
  }
  
  LightSource(float x, float y, int radius, int id, int categoryBits, float density)
  {
    super(radius, id, color(255, 175, 0), "player");
    makeBody(x, y, radius, categoryBits, density);
    body.setUserData(this);
    target = new Target(x,y);
    a = b = s = 0.0;
    spawnSpread = .5;
  }

  //adds k new particles to the particle list.
  LightParticle spawn()
  {
    LightParticle particle;
    float dir = random((spawnAngle/2-spawnSpread), (spawnAngle/2+spawnSpread));
    float xin, yin;

    Vec2 pos = box2d.getScreenPos(body);
    //must be inside the LightSource
    xin = random(pos.x-(radius*0.25+spawnSpread*.9), pos.x+(radius*0.25+spawnSpread*.9));
    yin = random(pos.y-(radius*0.25+spawnSpread*.9), pos.y+(radius*0.25+spawnSpread*.9));
    particle = new LightParticle(xin, yin, dir, -1);

    return particle;
  } 
  
  //sets spawn angle
  void setSpawnAngle(float angle){
  
    spawnAngle = angle;
  }
  
  float getSpawnAngle(){
    return spawnAngle;
  }
  
  void increaseSpawnSpread()
  {
    if (spawnSpread<PI/2)
      spawnSpread+=PI/64;
  }
  
  void decreaseSpawnSpread()
  {
    if (spawnSpread>=PI/32)
      spawnSpread-=PI/64;
  }
  
   //Puts the LightSource in the world
  void makeBody(float x, float y, float radius_, int categoryBits, float density) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(radius_);
    cd.density = density;
    cd.friction = 0.01f;
    cd.restitution = 0.01f; // Restitution is bounciness
    cd.filter.categoryBits = categoryBits;
    cd.filter.maskBits = 0xffff ^ 0x0004; //Doesn't collide with players prison. But can trap in enemy prison
    body.createShape(cd);

    // Always do this at the end
    body.setMassFromShapes();
  }
    void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    //float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    
    stroke(200,200);
    strokeWeight(2);
    translate(sin(spawnAngle),cos(spawnAngle));

    noStroke();
    fill(0,0,200,200);
    quad(
         (radius*0.25+spawnSpread)*cos(-spawnAngle/2+PI/2),
         (radius*0.25+spawnSpread)*sin(-spawnAngle/2+PI/2),
         80*sin(spawnAngle/2+PI/2-spawnSpread),
         80*cos(spawnAngle/2+PI/2-spawnSpread),
         80*sin(spawnAngle/2+PI/2+spawnSpread),
         80*cos(spawnAngle/2+PI/2+spawnSpread),
         (radius*0.25+spawnSpread)*cos(-spawnAngle/2-PI/2),
         (radius*0.25+spawnSpread)*sin(-spawnAngle/2-PI/2)
         );//spread line   

    noStroke();    
    
    if(isSelected)
    {
      strokeWeight(3);
      stroke(90,255,255);
    }
    else
      noStroke();
     
     a = a + 0.08;
     b = b + 0.03/(spawnSpread+0.01); 
      
    fill(40,255,255,80);
    s = cos(a)*2;
    ellipse(0,0,radius*2-s,radius*2-s);//outer circle
    noStroke();

    s = cos(b)*4+8;
    fill(40,200,255,200);
    float inner = 30*spawnSpread+s;
    ellipse(0,0,inner,inner);//inner circle
    
    stroke(200,200,0);
//    line(0,0,80*sin(spawnAngle/2+PI/2+spawnSpread),80*cos(spawnAngle/2+PI/2+spawnSpread));//spread line
//    line(0,0,80*sin(spawnAngle/2+PI/2-spawnSpread),80*cos(spawnAngle/2+PI/2-spawnSpread));//spread line

    noStroke();
    popMatrix();
  }//end display  
}//end LightSource



//Redirects light particles
class Prism extends LightSource{
  int light;
  int catBits = int(pow(2,id+4));

  Prism(float x, float y, int id)
  {
      super(x, y, 20, id, int(pow(2,id+4)), 1.0);
      changeColor(255,255,100);
      light = 0;
  }
  
  void update()
  {
    super.update();
    if(light == 0)
    {
      blind = true;
      col = color(150, 55, 4*light);
      spring.destroy();
    }
    else
    {
      blind = false; 
      col = color(150, 255, 4*light);
    }
    
    if (light > 0 && light < 160)
      light = light-1;
      
  }  
  
  //change light value, overrides Particle's changeLight()
  void changeLight()
  {
    if (light<=1490)
      light = light + 15;// Yes, 50% more free!
    else if (light > 1490 && light < 1500)
      light = 1500;//set to max
    else if (light <= 0)
      light = 0;//zero is minimum
  }  
  
  //returns a live particle iff it has light
  LightParticle spawn()
  {
    light = light - 20;
    LightParticle particle;
    float dir = random((spawnAngle/2-spawnSpread), (spawnAngle/2+spawnSpread));
    float xin, yin;

    Vec2 pos = box2d.getScreenPos(body);
    xin = random(pos.x-(radius*0.25+spawnSpread*.9), pos.x+(radius*0.25+spawnSpread*.9));
    yin = random(pos.y-(radius*0.25+spawnSpread*.9), pos.y+(radius*0.25+spawnSpread*.9));
    particle = new LightParticle(xin, yin, dir, -1, catBits);
    //println(spawnSpread);
    return particle;
  }
  boolean done()
  {
    return false;
  }
    void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);

    pushMatrix();
    translate(pos.x,pos.y);
    
    stroke(200,200);
    strokeWeight(2);
    translate(sin(spawnAngle),cos(spawnAngle));
    
    noStroke();
    
    if(isSelected)//set stroke based on selection
    {
      stroke(90,255,255);
      strokeWeight(4);
    }
    else
      stroke(255,200);
      strokeWeight(2);
      
    fill(col,100);
    ellipse(0,0,radius*2,radius*2);//outer circle
    noStroke();
    fill(col);
    ellipse(0,0, radius,radius);//inner circle
    
    stroke(200,200);
    line(0,0,50*sin(spawnAngle/2+PI/2),50*cos(spawnAngle/2+PI/2));//direction line
    line(0,0,25*sin(spawnAngle/2+PI/2+spawnSpread),25*cos(spawnAngle/2+PI/2+spawnSpread));//spread line
    line(0,0,25*sin(spawnAngle/2+PI/2-spawnSpread),25*cos(spawnAngle/2+PI/2-spawnSpread));//spread line
    line(50*sin(spawnAngle/2+PI/2),
         50*cos(spawnAngle/2+PI/2),
         25*sin(spawnAngle/2+PI/2+spawnSpread),
         25*cos(spawnAngle/2+PI/2+spawnSpread));//spread line
    line(50*sin(spawnAngle/2+PI/2),
         50*cos(spawnAngle/2+PI/2),
         25*sin(spawnAngle/2+PI/2-spawnSpread),
         25*cos(spawnAngle/2+PI/2-spawnSpread));//spread line    
    noStroke();

    popMatrix();
  }//end display 
  
}// end prism

//light particles only interact with obstacles and units
//light particles are generated by light sources, and move at a uniform speed
class LightParticle extends Particle{
  
 // static final int lifeTime = 5000;
  int lifeTime = (int)random(1000,6000);
  float dir;
  boolean alive;
  float speed;
  float timer;
  float a, s;//used in animation;
  
  LightParticle(float xin, float yin, float dirIn, int gID){
    
    super(2, 2, color(255, 175, 0), "none");
    dir = dirIn;//direction
    alive = true;
    speed = 30 - random(5); //this is the speed of light!
    makeBody(xin, yin, 5, gID, 0x0000);
    body.setUserData(this);
    body.setLinearVelocity(velocity());
    timer = millis();
    a = s = random(1);//used in animation
    //println("Created a light particle");
  }
  
  LightParticle(float xin, float yin, float dirIn, int gID, int maskBits){
    super(2, 2, color(255, 175, 0), "none");
    dir = dirIn;//direction
    alive = true;
    speed = 30-random(5); //this is the speed of light!
    makeBody(xin, yin, 5, gID, maskBits);
    body.setUserData(this);
    body.setLinearVelocity(velocity());
    timer = millis();
    a = s = random(1);//used in animation
    //println("Created a light particle");
  }
  
  Vec2 velocity()
  {
    Vec2 aVector = new Vec2(speed*cos(dir), speed*sin(dir));
    return aVector;
  }
  
  boolean isAlive()
  {
    if(!alive)
      timer = -millis(); //Should kill the particle on the next update
    //println(timer);
    return alive;
  }
  
  void update(){
    Vec2 pos = box2d.getScreenPos(body);
    if(pos.x > width+radius || pos.x < 0-radius || pos.y > height+radius|| pos.y < 0-radius ||
       millis() - timer > lifeTime || alive == false)      {//exits bounds
        killBody();
        alive = false;
    }//end if
  }//end update()
  
void display()
  {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    int lifeTimeMod = int(255 - 255 * ( (millis()-timer) / (lifeTime) ));

    a = a+random(400)*0.001;
    pushMatrix();
    translate(pos.x,pos.y);
    fill(40,255,255,lifeTimeMod-100);
    strokeWeight(1);
    stroke(255,0,255,lifeTimeMod-100);
    s = cos(a)*2;
    ellipse(0,0,radius*2+s,radius*2+s);//outer circle
    
    fill(40,150,255,lifeTimeMod-50);
    s = cos(a)*3;
    ellipse(0,0,radius*1+s,radius*1+s);//inner circle
    popMatrix();
  }
  
  //puts the LightParticle into the world
  void makeBody(float x, float y, float radius_, int groupID, int maskBits) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(radius_);
    cd.density = 0.001f;
    cd.friction = 0.0f;
    cd.restitution = 1.0f; // Restitution is bounciness
    cd.filter.groupIndex = groupID; //objects with same negative group index will not collide
    cd.filter.maskBits = 0xffff ^ 0x0002 ^ maskBits; //0xffff collides with everything; 0x0002 is the categoryBits of the LightSource; will not collide with LightSource
    body.createShape(cd);

    // Always do this at the end
    body.setMassFromShapes();
  }
}
