class GameManager {
  int gameState;
  int score, lives;
  Fish currentFish;
  TypingEngine typer;
  int waitTimer = 0;
  int fishingTimer = 0;
  int fishingDuration = 300; // 5 seconds at 60fps

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 3;
  }

  // Replace spawnFish() calls in reeling success or life loss with this:
  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(120, 300); // Random wait time between 1-3 seconds
    currentFish = null; // Remove the fish from the screen
  }

  void spawnFish() {
    currentFish = new Fish();
    typer.setTarget(currentFish.name, true);
    fishingTimer = 0; // Reset the timer
    gameState = 0; // FISHING phase
  }

  void run() {
    drawEnvironment();
    drawFisherman();
    drawUI();

    switch(gameState) {
    case WAITING:
      updateWaiting(); // New logic to count down the timer
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

    // Stickman Body
    float bodyX = 100;
    float bodyY = 240;
    line(bodyX, bodyY, bodyX, bodyY + 40); // Torso
    line(bodyX, bodyY + 10, bodyX - 15, bodyY + 25); // Left Arm
    line(bodyX, bodyY + 10, bodyX + 15, bodyY + 25); // Right Arm
    line(bodyX, bodyY + 40, bodyX - 10, bodyY + 60); // Left Leg
    line(bodyX, bodyY + 40, bodyX + 10, bodyY + 60); // Right Leg
    fill(255);
    ellipse(bodyX, bodyY - 10, 20, 20); // Head

    // The Fishing Rod
    strokeWeight(4);
    stroke(100, 50, 0); // Brown rod
    line(bodyX + 10, bodyY + 20, bodyX + 60, bodyY - 40); // Rod

    // The Fishing Line (String)
    strokeWeight(1);
    stroke(0);

    // ADD THE NULL CHECK HERE
    if (gameState == 1 && currentFish != null) {
      // Attach string to the fish position during reeling
      line(bodyX + 60, bodyY - 40, currentFish.x, 350);
    } else {
      // String hangs loosely during waiting/fishing phases
      line(bodyX + 60, bodyY - 40, bodyX + 60, bodyY + 20);

      strokeWeight(1);
      stroke(0);
      fill(255, 0, 0); // Red top
      arc(bodyX + 60, bodyY + 20, 12, 12, PI, TWO_PI, CHORD);
      fill(255);       // White bottom
      arc(bodyX + 60, bodyY + 20, 12, 12, 0, PI, CHORD);
    }

    noStroke(); // Reset stroke for other shapes
  }

  void drawEnvironment() {
    fill(100, 150, 255);
    rect(0, 300, width, 150); // Water
    fill(100, 70, 40);
    rect(0, 280, 150, 170); // Pier
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      fishingTimer++;
      
      // If 5 seconds pass without entering the name
      if (fishingTimer >= fishingDuration) {
        startWaiting(); // Fish disappears and new waiting begins
        return;
      }

      currentFish.displayShadow();
      typer.displayBubble();
      fill(255);
      textSize(16);
      text(currentFish.name, currentFish.x, 380);
    }
  }

  void drawReelingPhase() {
    if (currentFish != null) {
      currentFish.updateStruggle();
      currentFish.displayFish();
      typer.displaySentence();

      if (currentFish.x <= 150) {
        score += 10;
        startWaiting();
        return; // EXIT IMMEDIATELY to avoid the next if-statement
      }

      // This line would cause the crash without the 'return' above
      // because startWaiting() just set currentFish to null
      if (currentFish.x >= 750) {
        loseLife();
        return; // EXIT IMMEDIATELY
      }
    }
  }

  void loseLife() {
    lives--;
    if (lives <= 0) gameState = 2;
    else startWaiting(); // Fixed: Don't spawn immediately
  }

  void handleInput() {
    if (gameState == 0) {
      if (typer.checkBubbleInput()) {
        gameState = 1;
        typer.setTarget(typer.getRandomSentence(), false);
      } else if (typer.failed) {
        loseLife();
      }
    } else if (gameState == 1 && currentFish != null) { // Added check
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
