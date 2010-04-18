class SelectionBox{
  float holdX, holdY, sizeX, sizeY; 
  int alpha; 
  color boxColor;   
  
  //Constructor: default.
  SelectionBox()
  {
    alpha = 15;
    boxColor = color(0,255,0);
  }  
  
  //Constructor: takes a custom color and fill level
  SelectionBox(color colorIn, int alphaIn)
  {
    alpha = alphaIn;
    boxColor = colorIn;
  }
  
  //Resizes the box according to new mouse position. Called from mouseDragged()
  void adjust()
  {
    sizeX = mouseX-holdX;
    sizeY = mouseY-holdY;    
  }
  
  //Sets the corner of the box that does not move. Called from mousePressed()
  void setAnchor()
  {
    sizeX = sizeY = 0;
    holdX = mouseX;
    holdY = mouseY;  
  }

  //Updates box parameters and draws the box
  void updateBox()
  {
    fill(boxColor,alpha);
    stroke(boxColor);
    strokeWeight(2);
    if(sizeX>width - holdX - 1)
      sizeX = width - holdX - 1;
    if(sizeY>height - holdY - 1)
      sizeY = height - holdY - 1;
    
    if(sizeX<0 - holdX)
      sizeX=0 - holdX;
    if(sizeY<0 - holdY)
      sizeY=0 - holdY;
    
    if(mousePressed)  
      {
        rectMode(CORNER); 
        fill(100,255,200,50);
        stroke(90,255,200);
        rect(holdX,holdY,sizeX,sizeY);      
        noFill();
        noStroke();  
      }
  }
  
}// end SelectionBox
