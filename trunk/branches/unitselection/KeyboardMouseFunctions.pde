//Handles all actions when the mouse is clicked.
void mouseClicked()
{
  if(startButton.isPressed() && !gameEnable)
    {
      gameEnable = true;
      println("Game enabled");
    }
  if(debugButton.isPressed() && !debugEnable)
    {
      debugEnable = true;
      println("Debug enabled");
    }
  if(addObsButton.isPressed() && debugEnable)
    {
      gameState.randomizeObstacles();
      println("Randomized obstacles");
    }
   if(addUnitsButton.isPressed() && debugEnable)
    {
      gameState.createUnits();
      //gameState.createParticles();
      println("Added units");
    }
    
    if(addParticles.isPressed() && debugEnable)
    {
      source.spawn(20);
      source.displayParticles();
    }
    
    if(clearButton.isPressed() && debugEnable)
    {
       gameState.removeParticles();
       gameState.removeObstacles();
    }
    //println("Mouse clicked");
    
    //Update particle selection if the mouse is clicked. Doesn't select when dragged...
//    for(int i = 0; i < gameState.particles.size(); i++)
//     {
//        Particle temp = (Particle) gameState.particles.get(i);
//        
//        if(temp.contains(mouseX, mouseY))
//        {
//           if(temp.isSelected)
//             temp.isSelected = false;
//           else
//           {
//             temp.isSelected = true;             
//           }
//        }
//
//        //println("particle[" + i + "] selected: "+ temp.isSelected);
//     }
}

// When the mouse is pressed we. . .
void mousePressed() 
{
    sBox = new SelectionBox();
    sBox.setAnchor();//establish the anchor point for the box.
    if (mouseButton == RIGHT && L_MOUSE == false)
      {
        R_MOUSE = true;
        for(int i = 0; i < gameState.particles.size(); i++)
        {
            Particle temp = (Particle) gameState.particles.get(i);
            if (temp.isSelected == true)
              {
                  println("Setting target");
                  temp.setTarget();        
                  temp.body.setLinearVelocity(new Vec2(0,0));          
              }
          }
      }
      
    if(mouseButton == LEFT && R_MOUSE == false)
    {
       L_MOUSE = true;
       cursor(CROSS);//change the cursor as the box is being drawn.
    }
  }
    //Update particle selection if the mouse is pressed
//    for(int i = 0; i < gameState.selectedParticles.size(); i++)
//     {
//        Particle temp = (Particle) gameState.selectedParticles.get(i);
//        if(temp.contains(mouseX, mouseY))
//        {
//           spring.bind(mouseX,mouseY,temp);
//           attachedParticle = temp;
//        }      
//     }

void mouseDragged()
{
  if (L_MOUSE == true)
      sBox.adjust();//Adjust the size of the box as the mouse moves   
  
}

//Handles all actions when a mouse is released
  void mouseReleased()
  {
      attachedParticle.body.setLinearVelocity(new Vec2(0,0));
      spring.destroy();
      if(R_MOUSE==true)        
        R_MOUSE=false;
      
      if(L_MOUSE==true)
      {  
         for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
               temp.selection();       
        }
     }    
        L_MOUSE = false;  
         
      cursor(ARROW);//Go back to the normal cursor when box selection is over.
      sBox.sizeX=sBox.sizeY=0;
      sBox.holdX=sBox.holdY=-100;//move the SelectionBox off the screen
//      }
  }
