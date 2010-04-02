// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A circular particle

class Particle extends GameObject{

  // We need to keep track of a Body and a radius
  Body body;
  boolean isSelected;
  color col;
  float light, radius;
  boolean lit = false;
  String owner;
  int id;
  int groupID;
  
  //for particles with their own makeBody method
  Particle(int rad, String own, int idNum, color aCol)
  {
    radius = rad;
    owner = own;
    id = idNum;
    col = aCol;
    light = 1;
  }

  Particle(float x, float y, float radius_, int id, String owner) {
    radius = radius_;
    this.owner = owner;
    this.id = id;
    light = 1;
    
    // This function puts the particle in the Box2d world
    makeBody(x,y,radius);
    body.setUserData(this);
    
    col = color(150);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
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
  
  public void update(int x_, int y_) {
   Vec2 mouseWorld = box2d.screenToWorld(x_,y_);
   x = x_;
   y = y_;
   body.setXForm(mouseWorld, 0);
      
  }
 
 //THIS NEEDS TO BE CHANGED(for color anyways)
  public void update() {
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
  
  Body getBody()
  {
    return body;
  }
}
