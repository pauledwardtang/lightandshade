class Obstacle extends GameObject {
  
  // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;
  float j,k,w,h;
  ArrayList surface;

  Obstacle(float x_,float y_, float w_, float h_) {
    //super(x_, y_, w_, h_);
    
    surface = new ArrayList();
    
    x = x_;
    y = y_;
    w = w_;
    h = h_;    

    EdgeChainDef edges = new EdgeChainDef();
    
            
               Vec2 screenEdge,edge;


                // The edge point in our window
    		screenEdge = new Vec2(random(x+40,x+90),y);//Vec2(x+40,y);
    		// We store it for rendering
    		surface.add(screenEdge);
    		// Convert it to the box2d world and add it to our EdgeChainDef
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
               
    		screenEdge = new Vec2(x,y);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x-40,x-20),random(y+20,y+30));//Vec2(x-20,y+20);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
    

    		screenEdge = new Vec2(x,random(y+40,y+90));//new Vec2(x,y+40);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
    

    		screenEdge = new Vec2(random(x+10,x+30),random(y+50,y+90));//new Vec2(x+10,y+60);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x+40,x+70),random(y+40,y+70));//new Vec2(x+40,y+40);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x+60,x+70),random(y+10,y+40));//new Vec2(x+60,y-10);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = (Vec2)surface.get(0);  //new Vec2(x+40,y);
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);




    	edges.setIsLoop(true);   // We could make the edge a full loop
    	edges.friction = 0.3f;    // How much friction
        //edges.density = 0;
    	edges.restitution = 0.3f; // How bouncy
    	
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
		stroke(2);
		//noFill();
                fill(200);
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


