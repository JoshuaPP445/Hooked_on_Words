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
    drawEnvironment();
    drawFisherman();
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
    text("Waiting for a bite...", width/2, height/2 + 100);

    if (waitTimer <= 0) {
      spawnFish();
    }
  }

  void drawFisherman() {
    stroke(0);
    strokeWeight(2);
    float bodyX = 100;
    float bodyY = 240;
    line(bodyX, bodyY, bodyX, bodyY + 40);
    line(bodyX, bodyY + 10, bodyX - 15, bodyY + 25);
    line(bodyX, bodyY + 10, bodyX + 15, bodyY + 25);
    line(bodyX, bodyY + 40, bodyX - 10, bodyY + 60);
    line(bodyX, bodyY + 40, bodyX + 10, bodyY + 60);
    fill(255);
    ellipse(bodyX, bodyY - 10, 20, 20);

    strokeWeight(4);
    stroke(100, 50, 0);
    line(bodyX + 10, bodyY + 20, bodyX + 60, bodyY - 40);

    strokeWeight(1);
    stroke(0);
    if (gameState == 1 && currentFish != null) {
      // Offset the connection point to the left edge of the fish image (X - 24)
      float hookX = currentFish.fishX - 24;
      float hookY = 350; 
      
      line(bodyX + 60, bodyY - 40, hookX, hookY);
    } else {
      // String hangs loosely during waiting/fishing phases
      line(bodyX + 60, bodyY - 40, bodyX + 60, bodyY + 20);
      strokeWeight(1);
      stroke(0);
      fill(255, 0, 0);
      arc(bodyX + 60, bodyY + 20, 12, 12, PI, TWO_PI, CHORD);
      fill(255);
      arc(bodyX + 60, bodyY + 20, 12, 12, 0, PI, CHORD);
    }

    noStroke();
  }

  void drawEnvironment() {
    fill(100, 150, 255);
    rect(0, 300, width, 150); 
    fill(100, 70, 40);
    rect(0, 280, 150, 170); 
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
        startWaiting();
        return;
      }

      // Draw an underwater silhouette preview of our unique image
      if (currentFish.fishImg != null) {
        pushMatrix();
        translate(currentFish.fishX, 350);
        rotate(radians(-45));
        scale(-1, 1);
        imageMode(CENTER);
        tint(0, 50, 120, 100);
        // Blue tint overlay for water silhouette effect
        image(currentFish.fishImg, 0, 0, 48, 48);
        noTint(); // Turn off tint so other imagery prints cleanly
        popMatrix();
        imageMode(CORNER);
      }
      
      // Draw the shadow
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

      // Calculate hookX based on the left edge of the fish
      float hookX = currentFish.fishX - 24;

      // Check success condition against the pier edge using hookX
      if (hookX <= 150) {
        score += currentFish.fishScore; 
        startWaiting();
        return;
      }

      // Check failure boundary condition using hookX
      if (hookX >= 750) {
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
    
    if ((gameState == 0 || gameState == 1) && currentFish != null) {
      textAlign(RIGHT);
      text(currentFish.name.toUpperCase() + " [" + currentFish.fishDiff.toUpperCase() + "]", width - 20, 40);
    }
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
