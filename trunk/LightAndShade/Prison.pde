class Prison extends GameObject {

  // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;
  ArrayList surface;
  int type;

  Prison(int type_) {

    surface = new ArrayList();

    type = type_;

    EdgeChainDef edges = new EdgeChainDef();

    float k;

    if(type == 1)
      k = width;
    else
      k = 0;

    if(type == 1){
    for (float i = height; i > 0; i -= 10) {
      // Doing some stuff with perlin noise to calculate a surface that points down on one side
      // and up on the other
        if (i > height/2 + 100) {
            k -= 3;  
        } 
        else if(i < height/2 + 100 && i > height/2-100){
          k = k;
        } 
        else { 
            k += 3; 
        }
        
        // The edge point in our window
      Vec2 screenEdge = new Vec2(k,i);
      // We store it for rendering
      surface.add(screenEdge);
      // Convert it to the box2d world and add it to our EdgeChainDef
      Vec2 edge = box2d.screenToWorld(screenEdge);
      edges.addVertex(edge);
      
        }
    }
    else if (type == 0){
      for (float i = 0; i < height; i += 10) {
      // Doing some stuff with perlin noise to calculate a surface that points down on one side
      // and up on the other
        if (i < height/2 - 100) {
            k += 3;  
        } 
        else if(i < height/2 + 100 && i > height/2-100){
          k = k;    
        } 
        else { 
            k -= 3; 
        }
        
        // The edge point in our window
      Vec2 screenEdge = new Vec2(k,i);
      // We store it for rendering
      surface.add(screenEdge);
      // Convert it to the box2d world and add it to our EdgeChainDef
      Vec2 edge = box2d.screenToWorld(screenEdge);
      edges.addVertex(edge);
      
        }
    
    }
      

    Vec2 screenEdge = (Vec2)surface.get(0) ;
    surface.add(screenEdge);
    Vec2 edge = box2d.screenToWorld(screenEdge);
    edges.addVertex(edge);


    edges.setIsLoop(true);   // We could make the edge a full loop
    edges.friction = 0.3f;    // How much friction
    edges.density = 0;
    edges.restitution = 0.3f; // How bouncy
    if(type == 0)//Player Prison
      edges.filter.categoryBits = 0x0004;
    else if(type == 1)//Enemy Prison
      edges.filter.categoryBits = 0x0008; //has to be multiple of two. 
    
    
    // The edge chain is now a body!
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);//box2d.screenToWorld(new Vec2(j,k)));//0.0f,0.0f);
    b = box2d.world.createBody(bd);
    b.createShape(edges);
    b.setUserData(this);

  }



  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(2);
    //stroke(200);
    stroke(204, 102, 0);
    //fill(100);
    noFill();
    shapeMode(CENTER);
    beginShape();
    for (int i = 0; i < surface.size(); i++) {
      Vec2 v = (Vec2) surface.get(i);
      vertex(v.x,v.y);
    }
    endShape();
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(b);
  }

}

class PlayerPrison extends Prison{

  PlayerPrison(int type){
    super(type);  
  }

}

class EnemyPrison extends Prison{

  EnemyPrison(int type){
    super(type);
  }

}


