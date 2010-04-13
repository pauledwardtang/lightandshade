class Obstacle extends GameObject {
  
  // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;
  ArrayList surface;

  Obstacle(float x_,float y_) {
    
    surface = new ArrayList();
    
    x = x_;
    y = y_;
     
        EdgeChainDef edges = new EdgeChainDef();
            
               Vec2 screenEdge,edge;


                // The edge point in our window
    		screenEdge = new Vec2(random(x+80,x+200),random(y-80,y+110));
    		// We store it for rendering
    		surface.add(screenEdge);
    		// Convert it to the box2d world and add it to our EdgeChainDef
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
               
    		screenEdge = new Vec2(random(x-120,x-40),random(y-80,y+120));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x-200,x-40),random(y+120,y+200));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
    

    		screenEdge = new Vec2(random(x-140,x-100),random(y+200,y+220));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
    

    		screenEdge = new Vec2(random(x+100,x+130),random(y+220,y+250));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x+160,x+170),random(y+180,y+250));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = new Vec2(random(x+180,x+220),random(y+180,y+240));
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);


    		screenEdge = (Vec2)surface.get(0);  
    		surface.add(screenEdge);
    		edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);
    
  


    	edges.setIsLoop(true);   // We could make the edge a full loop
    	edges.friction = 0.3f;    // How much friction
        edges.density = 0;
    	edges.restitution = 0.3f; // How bouncy
    	
    	// The edge chain is now a body!
		BodyDef bd = new BodyDef();
		bd.position.set(0.0f,0.0f);
		b = box2d.world.createBody(bd);
		b.createShape(edges);
                b.setUserData(this);

  }
  


// A simple function to just draw the edge chain as a series of vertex points
	void display() {
		strokeWeight(2);
		stroke(2);
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

class Edge
{
  Body body;
  float w;
  float h;

  Edge(int x, int y, int w, int h)
  {
    this.w = w;
    this.h = h;
    makeBody(x,y,w,h);
    body.setUserData(this);
  }
  void display()
  {
    Vec2 pos = box2d.getScreenPos(body);
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    fill(0);
    rect(0, 0, w, h);
    popMatrix();
  }
  void makeBody(int x, int y, int w_, int h_)
  {
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.screenToWorld(x,y);
    body = box2d.world.createBody(bd);
    
    PolygonDef sd = new PolygonDef();
    float boxW = box2d.scaleScreenToWorld(w);
    float boxH = box2d.scaleScreenToWorld(h);
    sd.setAsBox(boxW, boxH);
    
    body.createShape(sd);
    body.setMassFromShapes();
  }
}
