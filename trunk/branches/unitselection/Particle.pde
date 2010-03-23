// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A circular particle

class Particle extends Unit{

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  boolean isSelected;
  boolean mouseLock = true;
  
  color col;

  
  Particle(float r_) {
    super();
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
    body.setUserData(this);
    
    col = color(150);
  }
  
  Particle(float x, float y, float r_) {
    super(x, y);
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
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
  
  public void update(int x_, int y_) {
   Vec2 mouseWorld = box2d.screenToWorld(x_,y_);
   x = x_;
   y = y_;
   body.setXForm(mouseWorld, 0);
  }
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getScreenPos(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
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
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleDef cd = new CircleDef();
    cd.radius = box2d.scaleScreenToWorld(r);
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






}
