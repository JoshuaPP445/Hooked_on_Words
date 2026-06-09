class GameManager {
  int gameState;
  int score, lives;
  Fish currentFish;
  TypingEngine typer;
  int waitTimer = 0;
  int fishingTimer = 0;
  int fishingDuration = 400;
  int fishCaughtX = 215;

  float bobberX;
  float bobberY;

  String[] introMonologue = {
    "My breath grows shallow... the hospital room fades away...",
    "If this is the end, let me return to where I felt most alive.",
    "Back to the crisp mornings on the water...",
    "Hold on, I can almost hear the ripples of the lake..."
  };
  int introIndex = 0;
  String thoughtBubble = "Ah, the calm waters... just like when I was twenty. Let's see if they're biting.";

  String customInputText = "";
  String customDifficultyTarget = "easy";
  
  float btnX = 300, btnY = 320, btnW = 200, btnH = 40;
  
  // Mode toggle button coordinates (Title screen)
  float modeBtnX = 300, modeBtnY = 260, modeBtnW = 200, modeBtnH = 40;
  
  // Exit 'X' button coordinates (Active gameplay screens)
  float exitBtnX = 750, exitBtnY = 15, exitBtnW = 35, exitBtnH = 35;

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 6;
  }

  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(30, 60);
    currentFish = null;
    
    float r = random(1);
    if (r < 0.3) {
      thoughtBubble = "The air smells exactly like it did fifty years ago...";
    } else if (r < 0.6) {
      thoughtBubble = "Patience... that's the first thing my grandfather taught me here.";
    } else {
      thoughtBubble = "My hands used to be so steady back then.";
    }
  }

  void triggerCast() {
    gameState = CASTING;
    currentFrame = 0;
    castFrameCounter = 0;
  }

  void finishCasting() {
    spawnFish();
  }

  void spawnFish() {
    currentFish = new Fish(650);
    typer.setTarget(currentFish.name, true);
    fishingTimer = 0;
    gameState = 0;
    
    if (currentFish.fishDiff.equals("easy")) {
      thoughtBubble = "Feels like a small one. A nice easy catch to start the morning.";
    } else if (currentFish.fishDiff.equals("medium")) {
      thoughtBubble = "Ah, it's got some weight to it! Don't lose it now.";
    } else {
      thoughtBubble = "Good heavens, this pull... it's a monster! Just like the one that got away in '74!";
    }
  }

  void run() {
    if (gameState == 6) {
      drawIntroScreen();
      return;
    }
    
    if (gameState == 7) {
      drawCustomWordScreen();
      return;
    }

    updateBobberPosition();
    drawUI();
    
    if (gameState == WAITING || gameState == 0 || gameState == 1) {
      drawMemoryBubble();
      drawExitButton();
    }

    switch(gameState) {
    case WAITING:
      updateWaiting();
      break;
    case CASTING:
      break;
    case 0:
      drawFishingPhase();
      break;
    case 1:
      drawReelingPhase();
      break;
    case 2:
      drawGameOver();
      break;
    case 3:
      drawStartScreen();
      break;
    }
    if (gameState != 2) {
      drawFishingLine();
    }
  }

  void drawIntroScreen() {
    background(0);
    textAlign(CENTER, CENTER);
    fill(220, 220, 220);
    textSize(22);
    text(introMonologue[introIndex], width/2, height/2 - 20);
    
    fill(120);
    textSize(14);
    text("[ Press SPACE to continue memory ]", width/2, height/2 + 60);
  }

  void drawMemoryBubble() {
    pushStyle();
    stroke(100, 150, 200, 150);
    strokeWeight(2);
    fill(245, 245, 250, 220);
    
    rect(240, 15, 480, 50, 15);
    
    noStroke();
    fill(245, 245, 250, 220);
    ellipse(230, 55, 12, 12);
    ellipse(215, 68, 7, 7);
    
    fill(50, 60, 70);
    textAlign(LEFT, CENTER);
    textSize(13);
    text(thoughtBubble, 255, 20, 450, 40);
    popStyle();
  }

  void drawExitButton() {
    pushStyle();
    if (mouseX >= exitBtnX && mouseX <= exitBtnX + exitBtnW && mouseY >= exitBtnY && mouseY <= exitBtnY + exitBtnH) {
      fill(220, 60, 60); 
    } else {
      fill(180, 50, 50); 
    }
    stroke(255);
    strokeWeight(1.5);
    rect(exitBtnX, exitBtnY, exitBtnW, exitBtnH, 6);
    
    stroke(255);
    strokeWeight(2.5);
    line(exitBtnX + 10, exitBtnY + 10, exitBtnX + exitBtnW - 10, exitBtnY + exitBtnH - 10);
    line(exitBtnX + exitBtnW - 10, exitBtnY + 10, exitBtnX + 10, exitBtnY + exitBtnH - 10);
    popStyle();
  }

  void updateWaiting() {
    waitTimer--;
    textAlign(CENTER);
    fill(0, 100);
    text("Waiting for a bite... [" + waitTimer/10 + "]", width/2, height/2 + 50);

    if (waitTimer <= 0) {
      triggerCast();
    }
  }

  void updateBobberPosition() {
    float[] tipXCoordinates = { 242, 189, 171, 242 };
    float[] tipYCoordinates = { 215, 171, 126, 215 };
    float rodTipX = tipXCoordinates[currentFrame];
    float rodTipY = tipYCoordinates[currentFrame];
    if (gameState == WAITING || gameState == 3) {
      bobberX = rodTipX + sin(frameCount * 0.05) * 2;
      bobberY = rodTipY + 25 + cos(frameCount * 0.07) * 3;
    } else if (gameState == CASTING) {
      float progress = currentFrame / 3.0;
      bobberX = lerp(rodTipX, 650, progress);
      bobberY = lerp(rodTipY, 380, progress);
    } else if (gameState == 0) {
      bobberX = 650 + sin(frameCount * 0.05) * 10;
      bobberY = 380 + cos(frameCount * 0.07) * 4;
    } else if (gameState == 1 && currentFish != null) {
      bobberX = currentFish.fishX - 24;
      bobberY = 380 + sin(frameCount * 0.2) * 3;
    }
  }

  void drawFishingLine() {
    float[] tipXCoordinates = { 242, 189, 171, 242 };
    float[] tipYCoordinates = { 215, 171, 126, 215 };
    float rodTipX = tipXCoordinates[currentFrame];
    float rodTipY = tipYCoordinates[currentFrame];

    strokeWeight(1);
    stroke(0);

    if (gameState == 1 && currentFish != null) {
      float hookX = currentFish.fishX - 24;
      float hookY = 380;
      line(rodTipX, rodTipY, hookX, hookY);
    } else {
      line(rodTipX, rodTipY, bobberX, bobberY);
      stroke(0);
      strokeWeight(1);
      fill(255, 0, 0);
      arc(bobberX, bobberY, 12, 12, PI, TWO_PI, CHORD);
      fill(255);      
      arc(bobberX, bobberY, 12, 12, 0, PI, CHORD);
    }
    noStroke();
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      currentFish.swimIn();

      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
        thoughtBubble = "Drifted away... my focus isn't what it used to be.";
        startWaiting();
        return;
      }

      if (currentFish.fishImg != null) {
        pushMatrix();
        translate(currentFish.fishX, 380);
        imageMode(CENTER);
        tint(0, 50, 120, 100);
        image(currentFish.fishImg, 0, 0, 64, 64);
        noTint();
        popMatrix();
        imageMode(CORNER);
      }

      currentFish.displayShadow();

      if (currentFish.isReady) {
        typer.displayBubble();
      }

      textAlign(CENTER);
      fill(255);
      textSize(16);
      text(currentFish.name, currentFish.fishX, 410);
      textAlign(LEFT);
    }
  }

  void drawReelingPhase() {
    if (currentFish != null) {
      currentFish.updateStruggle();
      currentFish.displayFish();
      typer.displaySentence();

      float hookX = currentFish.fishX - 24;
      if (hookX <= fishCaughtX) {
        score += currentFish.fishScore;
        hookSfx.play();
        thoughtBubble = "Yes! Reeled it in perfectly. The thrill is exactly the same.";
        startWaiting();
        return;
      }

      if (hookX >= width && currentFish.isReady) {
        loseLife();
        return;
      }
    }
  }

  void loseLife() {
    lives--;
    if (lives <= 0) {
      gameState = 2;
      bgm.stop();
      if (!gameOver.isPlaying()) {
        gameOver.play();
      }
    } else {
      loseFish.play();
      thoughtBubble = "Blast it, it snapped the line! I'm getting weak...";
      startWaiting();
    }
  }

  void drawCustomWordScreen() {
    background(30, 45, 60);
    
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(28);
    text("ADD CUSTOM SENTENCE", width/2, 60);
    
    textSize(14);
    fill(180);
    text("Select difficulty target pool by clicking below:", width/2, 120);
    
    String[] options = {"easy", "medium", "hard"};
    for (int i=0; i<3; i++) {
      if (customDifficultyTarget.equals(options[i])) {
        fill(100, 180, 255);
        stroke(255);
      } else {
        fill(60, 80, 100);
        stroke(100);
      }
      rect(180 + (i * 160), 150, 120, 35, 5);
      fill(255);
      textSize(16);
      text(options[i].toUpperCase(), 240 + (i * 160), 167);
    }
    
    fill(15);
    stroke(150);
    rect(150, 230, 500, 50, 8);
    
    fill(255);
    textSize(18);
    textAlign(LEFT, CENTER);
    text(customInputText + "|", 170, 255);
    
    textAlign(CENTER);
    textSize(14);
    fill(150);
    text("Type phrase, then press ENTER to save changes.", width/2, 320);
    text("Press ESCAPE to return to Title Screen without saving.", width/2, 350);
  }

  void handleInput() {
    if (gameState == 7) {
      if (key == ESC) {
        key = 0;
        gameState = 3;
      } else if (key == BACKSPACE && customInputText.length() > 0) {
        customInputText = customInputText.substring(0, customInputText.length() - 1);
      } else if (key == ENTER || key == RETURN) {
        typer.addCustomSentence(customInputText, customDifficultyTarget);
        customInputText = ""; 
        gameState = 3; 
      } else if (key != CODED && key != BACKSPACE) {
        customInputText += key;
      }
      return;
    }

    if (gameState == 6) {
      if (key == ' ') {
        introIndex++;
        if (introIndex >= introMonologue.length) {
          gameState = 3;
        }
      }
      return;
    }

    if (gameState == 0) {
      if (currentFish != null && !currentFish.isReady) return;
      if (typer.checkBubbleInput()) {
        gameState = 1;
        if (freeTypeMode) {
          typer.setTarget("", true);
        } else {
          typer.setTarget(typer.getRandomSentence(currentFish.fishDiff), false);
        }
      } else if (typer.failed) {
        loseLife();
      }
    } else if (gameState == 1 && currentFish != null) {
      typer.checkReelingInput(currentFish, this);
    } else if (gameState == 2 && key == ' ') {
      reset();
    } else if (gameState == 3 && key == ' ') {
      gameState = WAITING;
    }
  }

  void handleMouse() {
    // Handle gameplay exit click
    if (gameState == WAITING || gameState == 0 || gameState == 1) {
      if (mouseX >= exitBtnX && mouseX <= exitBtnX + exitBtnW && mouseY >= exitBtnY && mouseY <= exitBtnY + exitBtnH) {
        // Stop active gameplay metrics and switch screens properly
        reset(); 
        gameState = 3; 
        return;
      }
    }

    if (gameState == 3) {
      if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH) {
        customInputText = "";
        gameState = 7;
      }
      
      if (mouseX >= modeBtnX && mouseX <= modeBtnX + modeBtnW && mouseY >= modeBtnY && mouseY <= modeBtnY + modeBtnH) {
        freeTypeMode = !freeTypeMode; 
      }
    } else if (gameState == 7) {
      for (int i=0; i<3; i++) {
        float tX = 180 + (i * 160);
        float tY = 150;
        if (mouseX >= tX && mouseX <= tX + 120 && mouseY >= tY && mouseY <= tY + 35) {
          String[] options = {"easy", "medium", "hard"};
          customDifficultyTarget = options[i];
        }
      }
    }
  }

  void drawUI() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, 20, 40);
    text("LIVES: " + lives, 20, 70);
  }

  void drawGameOver() {
    textAlign(CENTER);
    fill(200, 0, 0);
    textSize(40);
    text("THE MEMORY FADES", width/2, height/2);
    fill(0);
    textSize(20);
    text("Press SPACE to Remember Again", width/2, height/2 + 50);
  }

  void drawStartScreen() {
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("HOOKED ON WORDS", width/2, height/2 - 65);
    textSize(18);
    fill(60);
    text("A Dying Man's Reflection", width/2, height/2 - 30);
    textSize(20);
    fill(0);
    text("Press SPACE to Start the Dream", width/2, height/2 + 10);
    
    pushStyle();
    if (mouseX >= modeBtnX && mouseX <= modeBtnX + modeBtnW && mouseY >= modeBtnY && mouseY <= modeBtnY + modeBtnH) {
      fill(60, 160, 120);
    } else {
      fill(45, 125, 95);
    }
    stroke(255);
    strokeWeight(1);
    rect(modeBtnX, modeBtnY, modeBtnW, modeBtnH, 8);
    
    fill(255);
    textSize(14);
    String activeModeLabel = freeTypeMode ? "Mode: FREE TYPE" : "Mode: NORMAL";
    text(activeModeLabel, modeBtnX + modeBtnW/2, modeBtnY + modeBtnH/2 + 5);
    
    if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH) {
      fill(40, 140, 220);
    } else {
      fill(50, 100, 180);
    }
    rect(btnX, btnY, btnW, btnH, 8);
    
    fill(255);
    text("Add Custom Sentences", btnX + btnW/2, btnY + btnH/2 + 5);
    popStyle();
  }

  void reset() {
    score = 0;
    lives = 3;
    introIndex = 0;
    thoughtBubble = "Ah, back at the banks again. Let's make it count.";
    if (!bgm.isPlaying()) {
      bgm.loop();
    }
  }
}
