class Obstacle extends GameObject {
  
  // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;
  float x,y,w,h;
  float x1,x2;
  

  Obstacle(float x_,float y_, float w_, float h_) {
    //super(x_, y_, w_, h_);
    
//    x = x_;
//    y = y_;
//    w = random(w_-100 , w_);
//    h = random(h_-100, h_);
//    
//    
//
//    // Figure out the box2d coordinates
//    float box2dW = box2d.scaleScreenToWorld(w/2);
//    float box2dH = box2d.scaleScreenToWorld(h/2);
//    Vec2 center = new Vec2(x,y);
//
//    // Define the polygon
//    PolygonDef sd = new PolygonDef();
//    sd.filter.groupIndex = 2;
//    
//    sd.vertices.add(new Vec2(1.0f, 0.0f));
//    sd.vertices.add(new Vec2(1.0f, 0.0f));
//    sd.vertices.add(new Vec2(0.0f, 1.0f));
//    sd.vertices.add(new Vec2(1.0f, 1.0f));
//    sd.vertices.add(new Vec2(1.0f, 1.0f));
//    sd.vertices.add(new Vec2(1.0f, 2.0f));
//    sd.vertices.add(new Vec2(0.0f, 3.0f));
//    sd.vertices.add(new Vec2(0.0f, 4.0f));
//    
//     
//    
//
//   // PolygonShape polygon = new;
//    
//    sd.setAsBox(box2dW, box2dH);
//    sd.density = 0;    // No density means it won't move!
//    sd.friction = 0.3f;
//
//    // Create the body
//    BodyDef bd = new BodyDef();
//    bd.position.set(box2d.screenToWorld(center));
//    b = box2d.createBody(bd);
//    b.createShape(sd);
//    
//    b.setUserData(this);
  }
   
   // Drawing the box
  void display() {
//    // We look at each body and get its screen position
//    Vec2 pos = box2d.getScreenPos(b);
//    // Get its angle of rotation
//    float a = b.getAngle();
//
//    rectMode(CENTER);
//    pushMatrix();
//    translate(pos.x,pos.y);
//    rotate(a);
//    fill(0);
//    stroke(0);
//    rect(x,y,w,h);
//    popMatrix();

//    beginShape(TRIANGLE_STRIP);
//    vertex(30, 100);
//    vertex(35, 105);
//    vertex(45, 115);
//    vertex(35, 125);
//    vertex(30, 130);
//    vertex(25, 125);
//    vertex(15, 105);
//    endShape();



//    fill(100);
//    beginShape();
//    vertex(30, 15);
//    vertex(80, 20);
//    vertex(60, 30);
//    vertex(30, 40);
//    vertex(10, 30);
//    vertex(50, 20);
//    endShape(CLOSE);

     
    
  }
  
  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(b);
  }
}


