class Particle extends GameObject{

  // We need to keep track of a Body and a radius
  Body body;
  
  //Status variables
  boolean isSelected;
  boolean blind;
  int light;
  float radius;
  color col;
  boolean lit = false;
  String owner;
  int id;
  int groupID;
  boolean MOVE_MODE = false;
  int threshold;
  
  //Movement variables
  Target target;
  float speed, naturalSpeed;
  
    //for particles with their own makeBody method
  Particle(int rad, int idNum, color aCol, String owner)
  {
    radius = rad;
    id = idNum;
    col = aCol;
    light = 1;
    speed = 1;
    target = new Target(x,y);
    blind = false;
    this.owner = owner;
  }
  
    Particle(float x, float y, float radius_, float density, int id, String owner, int categoryBits) {
    //super(x, y);
    radius = radius_;
    this.owner = owner;
    this.id = id;
    light = 1;
    speed = 1;
    target = new Target(x,y);
    
    // This function puts the particle in the Box2d world
    makeBody(x,y,radius, density, categoryBits);
    body.setUserData(this);
    col = color(100, 100, 100);
    blind = false;
    }
    
  // Change color when hit
  void changeColor(int colVal) 
  {

    col = color(colVal,0,0); 
  }
  
  void changeColor(int r, int g, int b) 
  {

    col = color(r,g,b); 
  }
  
  //change light value
  void changeLight()
  {
    if (light<=170)
      light = light + 10;
    else if (light > 170 && light < 180)
      light = 180;//set to max
    else if (light <= 0)
      light = 0;//zero is minimum
  }
  
  public void update(int x_, int y_) {
   Vec2 mouseWorld = box2d.screenToWorld(x_,y_);
   x = x_;
   y = y_;
   body.setXForm(mouseWorld, 0);
  }
  
  public void update() {
    Vec2 pos = box2d.getScreenPos(body);

    if(MOVE_MODE == false || blind)
      setTarget(pos.x, pos.y);
      
    move();
    
    body.setAngularVelocity(0);
  }
   //Returns true if the particle has been clicked on (Doesn't take into account being clicked on while the mouse is moving...)
  boolean pressed()
  {
    return (contains(mouseX, mouseY) && mousePressed);
  }
    // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getScreenPos(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+radius ||  pos.y < -radius || pos.x > width+radius || pos.x < -radius) {
      killBody();
      println("killed particle");
      return true;
    }
    return false;
  }
  
  //This function removes the particle from the box2d world
  void killBody(){
    box2d.destroyBody(body);  
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
    //float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    //rotate(a);
    fill(col);
    if(isSelected)
    {
      stroke(2);
      strokeWeight(2);
    }
    else
      noStroke();
    
    ellipse(0,0,radius*2,radius*2);
    popMatrix();
  }
  
    // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float radius_, float density, int categoryBits) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    bd.linearDamping = 1;
    bd.angularDamping = 1;

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(radius_);
    cd.density = 4.0f;
    cd.friction = 0.01f;
    cd.restitution = .3f; // Restitution is bounciness
    cd.filter.maskBits = 0xffff ^ categoryBits; //categoryBits;
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
  
  boolean isBlind()
  {
     return blind;
  }
  
    //*****************Movement functions*******************
    //Moves the MovePiece towards the target at the movePiece's speed.
  void move()
  {

      Vec2 pos = box2d.getScreenPos(body);
      int xPos = (int) pos.x;
      int yPos = (int) pos.y;
      if(target.Dist(xPos, yPos) < 1.5*radius*threshold) //This line needs to change: threshold is being changed constantly! (if there is nothing selected then it will never stop!)
      {        
        body.setLinearVelocity(new Vec2(0,0));
        body.setAngularVelocity(0);
        setTarget(pos.x, pos.y);
        MOVE_MODE = false;
      }  
      else
        body.applyForce(new Vec2(-(pos.x - target.X), (pos.y - target.Y)), new Vec2(0,0));
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
  
  
  //Determines whether a particle will be selected within the selection box.
  void selection()
  {              
    if (MOUSE_HOVER() == true)
      isSelected = true;
    else 
      isSelected = false;
  }
  
}
//**************************Target Class*****************************
//Holds the coordinates of the Particles's destination.
  class Target{
    public float X, Y;
    
    Target(float x,float y)
    {
      X = x;
      Y = y;
    }
    
    float Dist(int xPos, int yPos)
    {
      return sqrt(sq(xDist(xPos))+sq(yDist(yPos)));    
    }
    
    float xDist(int xPos)
    {
      return X-xPos;
    }
    
    float yDist(int yPos)
    {
      return Y-yPos;
    }    
  }
