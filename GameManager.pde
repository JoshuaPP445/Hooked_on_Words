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

  GameManager() {
    score = 0;
    lives = 3;
    typer = new TypingEngine();
    startWaiting();
    gameState = 3;
  }

  void startWaiting() {
    gameState = WAITING;
    waitTimer = (int)random(30, 60);
    currentFish = null;
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
  }

  void run() {
    updateBobberPosition();

    drawUI();
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

  void updateWaiting() {
    waitTimer--;
    textAlign(CENTER);
    fill(0, 100);
    text("Waiting for a bite... [" + waitTimer/10 + "]", width/2, height/2 + 50);

    if (waitTimer <= 0) {
      //spawnFish();
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
    //line(rodTipX, rodTipY, bobberX, bobberY);

    //if (gameState != 1) {
    //  stroke(0);
    //  strokeWeight(1);
    //  fill(255, 0, 0); // red half
    //  arc(bobberX, bobberY, 12, 12, PI, TWO_PI, CHORD);
    //  fill(255);       // white half
    //  arc(bobberX, bobberY, 12, 12, 0, PI, CHORD);
    //  noStroke();
    //}

    if (gameState == 1 && currentFish != null) {
      float hookX = currentFish.fishX - 24;
      float hookY = 380;
      line(rodTipX, rodTipY, hookX, hookY);
    } else {
      // --- Floating Bobber Physics ---
      //float bobberSwingX = rodTipX + sin(frameCount * 0.05) * 15;
      //float lineDropY = 400 + cos(frameCount * 0.07) * 5;
      // Draw the fishing line shifting from the dynamic rod tip to the drifting bobber position
      line(rodTipX, rodTipY, bobberX, bobberY);
      stroke(0);
      strokeWeight(1);
      fill(255, 0, 0); // red
      arc(bobberX, bobberY, 12, 12, PI, TWO_PI, CHORD);
      fill(255);       // white
      arc(bobberX, bobberY, 12, 12, 0, PI, CHORD);
    }
    noStroke();
  }

  void drawFishingPhase() {
    if (currentFish != null) {
      currentFish.swimIn();

      fishingTimer++;
      if (fishingTimer >= fishingDuration) {
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

      // Adjust bounding checks if your new background structure implies different boundaries
      float hookX = currentFish.fishX - 24;
      if (hookX <= fishCaughtX) {
        score += currentFish.fishScore;
        hookSfx.play();
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
      startWaiting();
    }
  }

  void handleInput() {
    if (gameState == 0) {
      if (currentFish != null && !currentFish.isReady) return;
      if (typer.checkBubbleInput()) {
        gameState = 1;
        typer.setTarget(typer.getRandomSentence(currentFish.fishDiff), false);
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

  void drawUI() {
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("SCORE: " + score, 20, 40);
    text("LIVES: " + lives, 20, 70);

    // Test the Fish Type
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
    text("HOOKED ON WORDS", width/2, height/2 - 30);
    textSize(20);
    text("Press SPACE to Start", width/2, height/2 + 20);
  }

  void reset() {
    score = 0;
    lives = 3;
    bgm.loop();
    startWaiting();
  }
}
