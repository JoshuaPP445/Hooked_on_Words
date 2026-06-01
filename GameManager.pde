class GameManager {
  int gameState;
  int score, lives;
  Fish currentFish;
  TypingEngine typer;
  int waitTimer = 0;
  int fishingTimer = 0;
  int fishingDuration = 300; 

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 3;
  }

  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(120, 300); 
    currentFish = null;
  }

  void spawnFish() {
    currentFish = new Fish();
    typer.setTarget(currentFish.name, true);
    fishingTimer = 0; 
    gameState = 0;
  }

  void run() {
    drawFishingLine();
    
    drawUI();
    switch(gameState) {
    case WAITING:
      updateWaiting();
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
  }

  void updateWaiting() {
    waitTimer--;
    textAlign(CENTER);
    fill(0, 100);
    text("Waiting for a bite...", width/2, height/2 + 50);

    if (waitTimer <= 0) {
      spawnFish();
    }
  }

  void drawFishingLine() {
    // 1. Define our new fixed rod tip anchor points
    float rodTipX = 242;
    float rodTipY = 215;

    strokeWeight(1);
    stroke(0); // Black fishing line
    
    if (gameState == 1 && currentFish != null) {
      // Reeling Phase: Line connects from the rod tip straight to the fish
      // Offset the connection point to the left edge of the fish image (X - 32 for our 64x64 scale)
      float hookX = currentFish.fishX - 24;
      float hookY = 350;
      
      line(rodTipX, rodTipY, hookX, hookY);
      
    } else {
      // Waiting/Fishing Phases: String hangs straight down from the rod tip into the water [cite: 18]
      // Let's drop it down to Y = 320 so it rests nicely just under the water surface
      float lineDropY = 320; 
      
      line(rodTipX, rodTipY, rodTipX, lineDropY);
      
      // Draw the red and white bobber floating at the end of the line
      strokeWeight(1);
      stroke(0);
      
      // Top red half of bobber
      fill(255, 0, 0);
      arc(rodTipX, lineDropY, 12, 12, PI, TWO_PI, CHORD);
      
      // Bottom white half of bobber
      fill(255);
      arc(rodTipX, lineDropY, 12, 12, 0, PI, CHORD);
    }

    noStroke(); // cite: 21
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
        startWaiting();
        return;
      }

      if (currentFish.fishImg != null) {
        pushMatrix();
        translate(currentFish.fishX, 350);
        imageMode(CENTER);
        tint(0, 50, 120, 100); // Blue silhouette effect
        
        // Render 1280x1280 image gracefully down to 64x64 (or 48x48)
        image(currentFish.fishImg, 0, 0, 64, 64); 
        
        noTint();
        popMatrix();
        imageMode(CORNER);
      }
      
      currentFish.displayShadow();
      typer.displayBubble();
      fill(255);
      textSize(16);
      text(currentFish.name, currentFish.fishX, 380);
    }
  }

  void drawReelingPhase() {
    if (currentFish != null) {
      currentFish.updateStruggle();
      currentFish.displayFish();
      typer.displaySentence();

      // Adjust bounding checks if your new background structure implies different boundaries
      float hookX = currentFish.fishX - 32; 
      if (hookX <= 215) {
        score += currentFish.fishScore;
        startWaiting();
        return;
      }

      if (hookX >= width) {
        loseLife();
        return;
      }
    }
  }

  void loseLife() {
    lives--;
    if (lives <= 0) gameState = 2;
    else startWaiting();
  }

  void handleInput() {
    if (gameState == 0) {
      if (typer.checkBubbleInput()) {
        gameState = 1;
        typer.setTarget(typer.getRandomSentence(currentFish.fishDiff), false);
      } else if (typer.failed) {
        loseLife();
      }
    } else if (gameState == 1 && currentFish != null) {
      typer.checkReelingInput(currentFish);
    } else if (gameState == 2 && key == ' ') {
      reset();
    } else if (gameState == 3 && key == ' ') {
      gameState = WAITING;
    }
  }

  void drawUI() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, 20, 40);
    text("LIVES: " + lives, 20, 70);
    
    //if ((gameState == 0 || gameState == 1) && currentFish != null) {
    //  textAlign(RIGHT);
    //  text(currentFish.name.toUpperCase() + " [" + currentFish.fishDiff.toUpperCase() + "]", width - 20, 40);
    //}
  }

  void drawGameOver() {
    textAlign(CENTER);
    fill(200, 0, 0);
    textSize(40);
    text("GAME OVER", width/2, height/2);
    fill(0);
    textSize(20);
    text("Press SPACE to Restart", width/2, height/2 + 50);
  }

  void drawStartScreen() {
    textAlign(CENTER);
    fill(0);
    textSize(40);
    text("HOOKED ON WORDS", width/2, height/2);
    textSize(20);
    text("Press SPACE to Start", width/2, height/2 + 50);
  }

  void reset() {
    score = 0;
    lives = 3;
    startWaiting();
  }
}
