 // The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// ContactListener to listen for collisions!

class CustomListener implements ContactListener {
  
  DistanceSpring spring = new DistanceSpring();
      
  CustomListener(){

  }
  
  //checks against the list of particles that absorb
  boolean willAbsorb(String input){
    if(input.contains("Sprite")||input.endsWith("Shade")||input.contains("Prism")||input.contains("Eye"))
    {
      return true;
    }
    else 
      return false;
  }
    
  // This function is called when a new collision occurs
  void add(ContactPoint cp) {
    // Get both shapes
    Shape s1 = cp.shape1;
    Shape s2 = cp.shape2;
    // Get both bodies
    Body b1 = s1.getBody();
    Body b2 = s2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    
    // What class are they?
    String c1 = o1.getClass().getName();
    String c2 = o2.getClass().getName();
    
    //if a LightParticle is involved in a collision with another particle, kill it and increment the other's colour
    if(c1.contains("LightParticle") && willAbsorb(c2))
    {
        Particle particle;
        particle = (Particle)o2;
        particle.changeLight();
        
        LightParticle lParticle = (LightParticle) o1;
        lParticle.alive = false;
    }
    else if(c2.contains("LightParticle") && willAbsorb(c1))
    {
        Particle particle;
        particle = (Particle)o1;
        particle.changeLight();
        
        LightParticle lParticle = (LightParticle) o2;
        lParticle.alive = false;
    }
    
    
    //manipulation
    if ( (c1.contains("Sprite") || c1.endsWith("Shade")) && willAbsorb(c2) )
    {      
      Manipulator manipulator = (Manipulator)o1;
      Particle manipulatee = (Particle)o2;

      manipulator.attach(manipulatee);//attach. If it's not on the particle's list it is just ignored.  
    }
    if ( (c2.contains("Sprite") || c2.endsWith("Shade")) && willAbsorb(c1) )
    {      
      Manipulator manipulator = (Manipulator)o2;
      Particle manipulatee = (Particle)o1;

      manipulator.attach(manipulatee);//attach. If it's not on the particle's list it is just ignored.  
    }
    
    return;
  }

  // Contacts continue to collide - i.e. resting on each other
  void persist(ContactPoint cp)  {
    // Get both shapes
    Shape s1 = cp.shape1;
    Shape s2 = cp.shape2;
    // Get both bodies
    Body b1 = s1.getBody();
    Body b2 = s2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    // What class are they?
    String c1 = o1.getClass().getName();
    String c2 = o2.getClass().getName();
        //manipulation
    if ( (c1.contains("Sprite") || c1.endsWith("Shade")) && willAbsorb(c2) )
    {      
      Manipulator manipulator = (Manipulator)o1;
      Particle manipulatee = (Particle)o2;

      manipulator.attach(manipulatee);//attach. If it's not on the particle's list it is just ignored.  
    }
    if ( (c2.contains("Sprite") || c2.endsWith("Shade")) && willAbsorb(c1) )
    {      
      Manipulator manipulator = (Manipulator)o2;
      Particle manipulatee = (Particle)o1;

      manipulator.attach(manipulatee);//attach. If it's not on the particle's list it is just ignored.  
    }
    
    }

  // Objects stop touching each other
  void remove(ContactPoint cp)  { 
    // Get both shapes
    Shape s1 = cp.shape1;
    Shape s2 = cp.shape2;
    // Get both bodies
    Body b1 = s1.getBody();
    Body b2 = s2.getBody();
    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    
    // What class are they?  Box or Particle?
    String c1 = o1.getClass().getName();
    String c2 = o2.getClass().getName();
  }

  // Contact point is resolved into an add, persist etc
  void result(ContactResult cr) {

  }
}

