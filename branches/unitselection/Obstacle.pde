class Obstacle extends GameObject {
  
  // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;

  Obstacle(float x_,float y_, float w_, float h_) {
    super(x_, y_, w_, h_);

    // Figure out the box2d coordinates
    float box2dW = box2d.scaleScreenToWorld(w/2);
    float box2dH = box2d.scaleScreenToWorld(h/2);
    Vec2 center = new Vec2(x,y);

    // Define the polygon
    PolygonDef sd = new PolygonDef();
    sd.setAsBox(box2dW, box2dH);
    sd.density = 0;    // No density means it won't move!
    sd.friction = 0.3f;

    // Create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.screenToWorld(center));
    b = box2d.createBody(bd);
    b.createShape(sd);
  }
}


