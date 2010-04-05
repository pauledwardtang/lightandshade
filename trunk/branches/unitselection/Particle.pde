// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A circular particle

class Particle extends GameObject{

  // We need to keep track of a Body and a radius
  Body body;
  
  //Status variables
  boolean isSelected;
  color col;
  float light, radius;
  boolean lit = false;
  String owner;
  int id;
  int groupID;
  boolean MOVE_MODE = false;
  
  //Movement variables
  Target target;
  float speed, naturalSpeed;
  
  
  Particle(float x, float y, float radius_, int id, String owner) {
    //super(x, y);
    radius = radius_;
    this.owner = owner;
    this.id = id;
    light = 1;
    speed = 1;
    target = new Target(x,y);
    
    // This function puts the particle in the Box2d world
    makeBody(x,y,radius);
    body.setUserData(this);
    
    col = color(150);
  }
  
  Particle(float x, float y, float radius_, int id, String owner, int gID) {
    //super(x, y);
    radius = radius_;
    this.owner = owner;
    this.id = id;
    light = 1;
    speed = 1;
    groupID = gID;
    target = new Target(x,y);
    
    // This function puts the particle in the Box2d world
    makeBody(x,y,radius,gID);
    body.setUserData(this);
    
    col = color(150);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  // Change color when hit
  void changeColor(int colVal) {
    col = color(colVal,0,0); 
  }
  
  void changeColor(int r, int g, int b) {
    col = color(r,g,b); 
  }
  
  public void update(int x_, int y_) {
   Vec2 mouseWorld = box2d.screenToWorld(x_,y_);
   x = x_;
   y = y_;
   body.setXForm(mouseWorld, 0);
      
  }
 
 //THIS NEEDS TO BE CHANGED(for color anyways)
    public void update() {
    Vec2 pos = box2d.getScreenPos(body);
    //A particle is selected
    if(isSelected)
    {
      changeColor(255);
      moveToward(mouseX, mouseY);
      //println("Particle selected");
    } 
    else  //A particle is deselected
    {       
      //changeColor(0,0,255);
      //println("Particle deselected");
    }
    
    //****Update target****    
    if(target.Dist((int) pos.x, (int) pos.y) >= 1)
    {
      MOVE_MODE = true;
      move();
    }  
    done();
  }
  
  //Returns true if the particle has been clicked on (Doesn't take into account being clicked on while the mouse is moving...)
  boolean pressed()
  {
    return (contains(mouseX, mouseY) && mousePressed);
  }
  
  //James's move towards method, but modified for particles
  //Change so it moves towards a location
  void moveToward(int xin, int yin){
    if(contains(xin,yin))
    {
        if(mouseX - x > 1)
          x = x + light;
        else if (mouseX-x<-1)
          x = x - light;     
          
        if(mouseY-y>1)
          y = y + light;
          else if (mouseY-y<-1)
          y = y - light;      
    }
  }
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getScreenPos(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+radius*2) {
      killBody();
      return true;
    }
    return false;
  }
  

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.screenToWorld(x, y);
    Shape s = body.getShapeList();
    boolean inside = s.testPoint(body.getMemberXForm(),worldPoint);
    return inside;
  }
  
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getScreenPos(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,radius*2,radius*2);
    // Let's add a line so we can see the rotation
    line(0,0,radius,0);
    popMatrix();
  }
  
  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float radius_) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(radius_);
    cd.density = 1.0f;
    cd.friction = 0.01f;
    cd.restitution = 0.3f; // Restitution is bounciness
    body.createShape(cd);

    // Always do this at the end
    body.setMassFromShapes();

    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    //body.setAngularVelocity(random(-10,10));
  }
  
  //For particles that need to have a groupIndex set
  void makeBody(float x, float y, float radius_, int groupID) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(radius_);
    cd.density = 1.0f;
    cd.friction = 0.01f;
    cd.restitution = 0.3f; // Restitution is bounciness
    cd.filter.groupIndex = groupID; //objects with same negative group index will not collide
    body.createShape(cd);

    // Always do this at the end
    body.setMassFromShapes();

    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    //body.setAngularVelocity(random(-10,10));
  }
  
  Body getBody()
  {
    return body;
  }
  
  //*****************Movement functions*******************
    //Moves the MovePiece towards the target at the movePiece's speed.
  void move()
  {
    Vec2 pos = box2d.getScreenPos(body);
    int xPos = (int) pos.x;
    int yPos = (int) pos.y;
    if (MOVE_MODE == true && target.Dist(xPos, yPos) >= speed)//If the MovePiece is at least one -speed- from the Target, move.
      {
        yPos += speed/target.Dist(xPos, yPos)*target.yDist(yPos);//y-velocity
        xPos += speed/target.Dist(xPos, yPos)*target.xDist(xPos);//x-velocity
      println("moving!" + millis());
      }
    
    if (target.Dist(xPos, yPos) < speed)//If the MovePiece is within one -speed- of the Target, move to the target and stop.
    {
        yPos += target.yDist(yPos);
        xPos += target.xDist(xPos);
    println("stopping!" + millis());
        MOVE_MODE= false;    
    }   
  }
  
  boolean MOUSE_HOVER()
  {
    Vec2 pos = box2d.getScreenPos(body);
    int xPos = (int) pos.x;
    int yPos = (int) pos.y;
    float halfWidth = radius;
    float halfHeight = radius;    
      if(mouseX>xPos-1-halfWidth && mouseX<xPos+1+halfWidth && mouseY>yPos-1-halfHeight && mouseY<yPos+1+halfHeight)//The pointer is over the ShipPiece
        return true;   
      if(((sBox.holdX>xPos-1-halfWidth && sBox.sizeX+sBox.holdX<xPos+1+halfWidth) || 
        (sBox.holdX<xPos+1+halfWidth && sBox.sizeX+sBox.holdX>xPos-1-halfWidth)) && 
        ((sBox.holdY>yPos-1-halfHeight && sBox.sizeY+sBox.holdY<yPos+1+halfHeight) || 
        (sBox.holdY<yPos+1+halfHeight && sBox.sizeY+sBox.holdY>yPos-1-halfHeight)))//Any part of the ShipPiece is within the SelectionBox.
        return true;
      else
        return false;
  }
  
  //*****************Target functions********************
  
    //called from mouseReleased(), sets the destination point of the MovePiece.
  void setTarget()
  {
    target.X = mouseX;
    target.Y = mouseY;
  }
  
  //called from mouseReleased, sets the destination point to a given coordinates.
  void setTarget(float x,float y)
  {
    target.X = x;
    target.Y = y;    
  }
  
  
  //Determines whether a particle will be selected within the selection box. If it is already selected it will be deselecte
  void selection()
  {              
    if (MOUSE_HOVER() == true && isSelected==false)
      isSelected = true;
    else
      isSelected = false;  
  }
  
}
