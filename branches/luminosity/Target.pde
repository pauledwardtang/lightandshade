//Holds the coordinates of the Particles's destination.
  class Target{
    float X, Y;
    
    Target(float x,float y)
    {
      X = x;
      Y = y;
    }
    
    float Dist(int xPos, int yPos)
    {
      return sqrt(sq(xDist(xPos))+sq(yDist(yPos)));    
    }
    
    float xDist(int xPos)
    {
      return X-xPos;
    }
    
    float yDist(int yPos)
    {
      return Y-yPos;
    }    
  }
