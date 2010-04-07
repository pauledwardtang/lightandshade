class DistanceSpring {

  // This is the box2d object we need to create
  DistanceJoint distanceJoint;

  DistanceSpring() {
    // At first it doesn't exist
    distanceJoint = null;
  }

  //if it exists initialize with both particles 
  void update(Particle p1, Particle p2) {
    if (distanceJoint != null) {
      JointUtils.createDistanceJoint(p1.body, p1.body);
    }
  }

  void display() {
    if (distanceJoint != null) {
      // We can get the two anchor points
      Vec2 v1 = distanceJoint.getAnchor1();
      Vec2 v2 = distanceJoint.getAnchor2();
      // Convert them to screen coordinates
      v1 = box2d.worldToScreen(v1);
      v2 = box2d.worldToScreen(v2);
      // And just draw a line
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }
  
   void bind(Particle p1, Particle p2) {
     distanceJoint = JointUtils.createDistanceJoint(p1.body, p2.body);
  }

  void destroy() {
    // We can get rid of the joint
    if (distanceJoint != null) {
      box2d.world.destroyJoint(distanceJoint);
      distanceJoint = null;
    }
  }
  
//  void destroy(DistanceSpring joint) {
//    // We can get rid of the joint
//    if(joint != null) {
//      box2d.world.destroyJoint(joint.);
//      joint = null;
//    }
//  }

}
