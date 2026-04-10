// Game State Constants
final int FISHING = 0;
final int REELING = 1;
final int GAME_OVER = 2;

// Core Variables
int gameState = FISHING;
int score = 0;
int lives = 3;
float fishX, fishY;
float pierX = 150;
float escapeX = 750;

// Movement Variables
float standardStruggle = 0.6;
float currentStruggle = 0.6;

// Typing Logic
String[] fishNames = {"Tuna", "Salmon", "Bass", "Mackerel", "Snapper"};
String[] sentences = {
  "Tuna is a delicious fish", 
  "The ocean is deep and blue", 
  "Keep reeling it in",
  "The line is under a lot of tension",
  "Dont let the big one get away"
};
String targetText = "";
String userInput = "";
boolean[] isCorrect;
int charIndex = 0;

void setup() {
  size(800, 450);
  spawnShadow();
}

void draw() {
  background(200, 230, 255); 
  drawEnvironment();
  
  if (gameState == FISHING) {
    drawFishingPhase();
  } else if (gameState == REELING) {
    drawReelingPhase();
  } else if (gameState == GAME_OVER) {
    drawGameOver();
  }
  
  drawUI();
}

void drawEnvironment() {
  fill(100, 150, 255); 
  rect(0, 300, width, 150);
  fill(100, 70, 40); 
  rect(0, 280, pierX, 170);
}

void drawFishingPhase() {
  fill(50, 50, 50, 150);
  ellipse(fishX, 350, 50, 30);
  
  // Speech Bubble
  fill(255);
  stroke(0);
  rect(100, 50, 200, 50, 15);
  triangle(160, 100, 180, 100, 170, 120);
  
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  // Display what the user is currently typing
  text(userInput + "|", 200, 75);
  
  // Target Name Tag (Hint for the player)
  fill(255);
  textSize(16);
  text(targetText, fishX, 380);
}

void drawReelingPhase() {
  // --- SUDDEN LUNGE MECHANIC ---
  // 0.5% chance per frame (approx once every 3-4 seconds) to jump right
  if (random(100) < 0.5) {
    currentStruggle = 25.0; // The massive sudden move
  } else {
    currentStruggle = standardStruggle; // Back to normal
  }
  
  fishX += currentStruggle;
  
  // Win/Loss check
  if (fishX <= pierX) { 
    score += 10; 
    spawnShadow(); 
  } else if (fishX >= escapeX) { 
    lives--; 
    checkGameOver(); 
  }
  
  // Draw Fish (changes color to Red during a lunge)
  if (currentStruggle > standardStruggle) fill(255, 0, 0); 
  else fill(50, 80, 150);
  ellipse(fishX, 350, 40, 25);
  
  drawSentenceUI();
}

void keyPressed() {
  if (key == ESC) key = 0; 
  
  if (gameState == FISHING) {
    handleFishingInput();
  } else if (gameState == REELING) {
    handleReelingInput();
  } else if (gameState == GAME_OVER && key == ' ') {
    resetGame();
  }
}

void handleFishingInput() {
  if (key == BACKSPACE) {
    if (userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
  } 
  else if (key == ENTER || key == RETURN) {
    // Check the word only when Enter is pressed
    if (userInput.equalsIgnoreCase(targetText)) {
      userInput = ""; // Clear for next use
      startReeling();
    } else {
      userInput = ""; // Clear on failure
      reelTrash();
    }
  } 
  else if (key != CODED && key != ESC) {
    // Add typed character to our input string
    userInput += key;
  }
}

void handleReelingInput() {
  if (charIndex < targetText.length()) {
    char expected = Character.toLowerCase(targetText.charAt(charIndex));
    char typed = Character.toLowerCase(key);
    
    if (typed == expected) {
      fishX -= 25; 
      isCorrect[charIndex] = true;
    } else {
      fishX += 35; 
      isCorrect[charIndex] = false;
    }
    
    charIndex++;
    if (charIndex >= targetText.length()) {
      targetText = sentences[(int)random(sentences.length)];
      isCorrect = new boolean[targetText.length()];
      charIndex = 0;
    }
  }
}

void spawnShadow() {
  fishX = random(400, 600);
  targetText = fishNames[(int)random(fishNames.length)];
  charIndex = 0;
  gameState = FISHING;
}

void startReeling() {
  targetText = sentences[(int)random(sentences.length)];
  isCorrect = new boolean[targetText.length()];
  charIndex = 0;
  gameState = REELING;
}

void reelTrash() {
  lives--;
  checkGameOver();
  if (gameState != GAME_OVER) spawnShadow();
}

void checkGameOver() {
  if (lives <= 0) gameState = GAME_OVER;
}

void drawSentenceUI() {
  textAlign(LEFT);
  textSize(28);
  float startX = width/2 - (textWidth(targetText) / 2);
  
  for (int i = 0; i < targetText.length(); i++) {
    float charOffset = textWidth(targetText.substring(0, i));
    if (i < charIndex) {
      fill(isCorrect[i] ? color(0, 150, 0) : color(255, 0, 0));
    } else {
      fill(150);
    }
    text(targetText.charAt(i), startX + charOffset, 160);
    
    if (i == charIndex && frameCount % 40 < 20) {
      fill(0, 100, 255);
      rect(startX + charOffset - 2, 135, 3, 30);
    }
  }
}

void drawUI() {
  fill(0);
  textAlign(LEFT);
  textSize(20);
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

void resetGame() {
  score = 0;
  lives = 3;
  spawnShadow();
}
