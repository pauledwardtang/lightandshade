//Handles all actions when the mouse is clicked.
void mouseClicked()
{
  if(startButton.isPressed() && game_display == STARTUP)
    {
      game_display =INSTRUCTIONS;
      println("Instructions");
    }
  if(debugButton.isPressed() && game_display != DEBUG)
    {
      game_display = DEBUG;
      println("Debug enabled");
    }
  if(addObsButton.isPressed() && game_display == DEBUG)
    {
      gameState.randomizeObstacles();
      println("Randomized obstacles");
    }
   if(addUnitsButton.isPressed() && game_display == DEBUG)
    {
      gameState.createUnits();
      //gameState.createParticles();
      println("Added units");
    }
    
    if(addParticles.isPressed() && game_display == DEBUG)
    {
      //gameState.createLightParticles();
    }
    
    if(clearButton.isPressed() && game_display == DEBUG)
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
        for(int i = 0; i < gameState.selectedParticles.size(); i++)
        {
            Particle temp = (Particle) gameState.selectedParticles.get(i);
            temp.setTarget();        
            temp.MOVE_MODE = true;
            temp.threshold = gameState.selectedParticles.size();
            temp.body.setLinearVelocity(new Vec2(0,0));     //Reset velocity when selecting a new location
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
      if(R_MOUSE==true){
         for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.MOUSE_HOVER())
            {
              for(int j = 0; j < gameState.particles.size(); j++){
                    Particle temp2 = (Particle)gameState.particles.get(j);
                if (temp2.isSelected && temp2 instanceof Manipulator)//tell all selected manipulators to attach to temp
                  {
                    Manipulator manipulator = (Manipulator)gameState.particles.get(j);
                    if(manipulator.canGrab(temp)){//if not on the list
                      manipulator.grab(temp);
                    }
                    else
                      manipulator.release(temp);
                  }
              }
            }    
         }
      }        
        R_MOUSE=false;
      
      if(L_MOUSE==true)
      {  
         for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.owner.equals("player") || game_display == DEBUG)
               temp.selection();     
        }
     }    
        L_MOUSE = false;  
         
      cursor(ARROW);//Go back to the normal cursor when box selection is over.
      sBox.sizeX=sBox.sizeY=0;
      sBox.holdX=sBox.holdY=-100;//move the SelectionBox off the screen
//      }
  }
  
void keyPressed()
{
  if (keyPressed&&key=='d')//Detach spring
    {
         for(int i = 0; i < gameState.selectedParticles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.body.getUserData().getClass().getName().contains("Sprite"))
              ((Sprite)temp).spring.destroy();
        }
    } 
    if (keyPressed&&key=='q')//Switch game mode
    {
        gameState = new GameState(WIDTH, HEIGHT);
        game_display = STARTUP;
    }
    
    //SKIP THE INTSTRUCTIONS SCREEN
    if (keyPressed&&keyCode == ENTER && game_display == INSTRUCTIONS)//Change the Light sources spawning angle
    {
         game_display = MAIN_GAME;
         println("Game started");
    }  
    
   //START UP THE PAUSE SCREEN
    if (keyPressed&&keyCode == ENTER && game_display == PAUSE)//Change the Light sources spawning angle
    {
         game_display = MAIN_GAME;
         println("GAME UNPAUSED");
    }  
    //START UP THE PAUSE SCREEN
    if (keyPressed&&key == 'p' && game_display == MAIN_GAME)//Change the Light sources spawning angle
    {
         game_display = PAUSE;
         println("GAME PAUSED");
    }  
    

    //Changes the Light source spawning direction in clockwise direction
    if (keyPressed&&(key =='d' || keyCode == RIGHT))//Change the Light sources spawning angle
    {
      for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.body.getUserData().getClass().getName().contains("LightSource")||temp.body.getUserData().getClass().getName().contains("Prism"))
            {
               if (((LightSource)temp).isSelected)
               {
                  float spawnAngle = ((LightSource)temp).getSpawnAngle();
                  spawnAngle += 50;
                  ((LightSource)temp).setSpawnAngle(spawnAngle);
               }
            }
        } 
    }
    
    //Changes the Light Source spawning direction in counterclock wise direction
    if(keyPressed && (key =='a' || keyCode == LEFT))
    {
      for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.body.getUserData().getClass().getName().contains("LightSource")||temp.body.getUserData().getClass().getName().contains("Prism"))
            {
              if (((LightSource)temp).isSelected){
                float spawnAngle = ((LightSource)temp).getSpawnAngle();
                spawnAngle -= 50;
                ((LightSource)temp).setSpawnAngle(spawnAngle);
              }
            }
        } 
      
    }
    
    if(keyPressed && (key =='w' || keyCode == UP))
    {
      for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.body.getUserData().getClass().getName().contains("LightSource")||temp.body.getUserData().getClass().getName().contains("Prism"))
            {
              if (((LightSource)temp).isSelected){
                ((LightSource)temp).increaseSpawnSpread();//wider "beam"
              }
            }
        } 
      
    }

    if(keyPressed && (key =='s' || keyCode == DOWN))
    {
      for(int i = 0; i < gameState.particles.size(); i++)
         {
            Particle temp = (Particle) gameState.particles.get(i);
            if(temp.body.getUserData().getClass().getName().contains("LightSource")||temp.body.getUserData().getClass().getName().contains("Prism"))
            {
              if (((LightSource)temp).isSelected){
                ((LightSource)temp).decreaseSpawnSpread();//narrower "beam"
              }
            }
        } 
      
    }
    
}
