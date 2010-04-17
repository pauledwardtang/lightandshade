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
    
//    if(c1.contains("Sprite") && c2.contains("$Shade"))
//    {
//      spr = (Sprite) o1;
//      sh = (Shade) o2;
//      //Shades that are blinded get moved by sprites.
//      //Sprites that are blinded get moved by shades.
//      if(spr.isBlind())
//      {
//         sh.moveSprite(spr);
//      }
//      else if(sh.isBlind())
//      {
//         spr.moveShade(sh);
//      }
//    }
//    else if(c2.contains("Sprite") && c1.contains("$Shade"))
//    {
//      spr = (Sprite) o2;
//      sh = (Shade) o1;
//      //Shades that are blinded get moved by sprites.
//      //Sprites that are blinded get moved by shades.
//      if(spr.isBlind())
//      {
//         sh.moveSprite(spr);
//      }
//      else if(sh.isBlind())
//      {
//         spr.moveShade(sh);
//      }
//    }

//    LightParticle p;
//    Prism pr;
//    if((c2.contains("$LightParticle") && c1.contains("$Prism")) || (c2.contains("$Prism") && c1.contains("$LightParticle")))
//    {
//      if(c2.contains("$LightParticle"))
//      {
//          p = (LightParticle) o2;
//          pr = (Prism) o1;
//      }
//      else
//      {
//         p = (LightParticle) o1;
//         pr = (Prism) o2;
//      }
//      p.alive = false;
//      pr.changeLight();
//    }
    
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

