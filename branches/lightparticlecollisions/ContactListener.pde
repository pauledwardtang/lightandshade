// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// ContactListener to listen for collisions!

class CustomListener implements ContactListener {
  
  DistanceSpring spring = new DistanceSpring();
      
  CustomListener(){

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
    if(c1.contains("LightParticle") && (c2.contains("Sprite") || c2.contains("Shade")))
    {
      Sprite sp;
      Shade sh;
      if(c2.contains("Sprite"))
      {
        sp = (Sprite)o2;
        sp.changeLight();
      }
      else
      {
        sh = (Shade)o2;
        sh.changeLight();
      }
      LightParticle lParticle = (LightParticle) o1;
      lParticle.kill();
    }
    else if(c2.contains("LightParticle") && (c1.contains("Sprite") || c1.contains("Shade")))
    {
      Sprite sp;
      Shade sh;
      if(c1.contains("Sprite"))
      {
        sp = (Sprite) o1;
        sp.changeLight();
      }
      else
      {
        sh = (Shade) o1;
        sh.changeLight();
      }
      LightParticle lParticle = (LightParticle) o2;
      lParticle.kill();
    }
    
    
    Sprite spr;
    Shade sh;
    
    if(c1.contains("Sprite") && c2.contains("Shade"))
    {
      spr = (Sprite) o1;
      sh = (Shade) o2;
    }
    else if(c2.contains("Sprite") && c1.contains("Shade"))
    {
      spr = (Sprite) o2;
      sh = (Shade) o1;
    }
    else return;
    
    //Shades that are blinded get moved by sprites.
    //Sprites that are blinded get moved by shades.
    if(spr.isBlind())
    {
       sh.moveSprite(spr);
    }
    else if(sh.isBlind())
    {
      spring.bind(sh, spr);
      spring.update(sh, spr);
    }
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






