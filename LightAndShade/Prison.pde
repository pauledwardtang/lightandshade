class Prison extends GameObject {
  
   // An Obstacle is a simple rectangle with x,y,width,and height
  // But we also have to make a body for box2d to know about it
  Body b;
  ArrayList surface;

  Prison(float x_,float y_) {
    
    surface = new ArrayList();
    
    x = x_;
    y = y_;
     
        EdgeChainDef edges = new EdgeChainDef();
     
       // Perlin noise argument
    	float xoff = 0.0f;
    	
    	// This has to go backwards so that the objects  bounce off the top of the surface
    	// This "edgechain" will only work in one direction!
    	//for (float i = width+10; i > -10; i -= 5) {
      
        for (float i = x+80; i > x-80; i -= 2.5) {
    		
    		// Doing some stuff with perlin noise to calculate a surface that points down on one side
    		// and up on the other
    		float k;
    		
                  if (i > x) {
                     k = 150 + (x-i)*1.1f + map(noise(xoff),0,1,0,40);
                        	
    		} else { 
                     k = 150 +(i - x)*1.1f + map(noise(xoff),0,1,0,40);
            		}
    		
    		// The edge point in our window
    		Vec2 screenEdge = new Vec2(i,k);
    		// We store it for rendering
    		surface.add(screenEdge);
    		
    		// Convert it to the box2d world and add it to our EdgeChainDef
    		Vec2 edge = box2d.screenToWorld(screenEdge);
    		edges.addVertex(edge);

    		// Move through perlin noise
    		xoff += 0.1;

    	}
    

            Vec2 screenEdge = (Vec2)surface.get(0) ;
            surface.add(screenEdge);
            Vec2 edge = box2d.screenToWorld(screenEdge);
            edges.addVertex(edge);
            
        }
        
    
    
    // A simple function to just draw the edge chain as a series of vertex points
	void display() {
		strokeWeight(2);
		stroke(2);
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
