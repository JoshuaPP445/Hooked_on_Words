class Fish {
  float fishX, initialFishX;
  String name;
  float struggle;
  int fishScore;
  String fishDiff;
  String[] names = {"Tuna", "Salmon", "Bass", "Trout", "Snapper"};
  PImage fishImg;
  
  float entryX = 850;
  boolean isReady = false;

  Fish() {
    initialFishX = random(600, 700);
    fishX = entryX;
    name = names[(int)random(names.length)];
    
    fishImg = loadImage(name.toLowerCase() + ".png");
    
    if (name.equals("Bass")) {
      fishDiff = "easy";
      fishScore = 10;
      struggle = 1.5;
    } else if (name.equals("Trout") || name.equals("Snapper")) {
      fishDiff = "medium";
      fishScore = 25;
      struggle = 2.2;
    } else { 
      fishDiff = "hard";
      fishScore = 50;
      struggle = 2.7;
    }
  }
  
  void swimIn() {
    if (!isReady) {
      // lerp(current, target, speed) smoothly eases the fish into position
      fishX = lerp(fishX, initialFishX, 0.05);
      
      // Once it gets close enough, lock it into place and activate gameplay
      if (abs(fishX - initialFishX) < 1.0) {
        fishX = initialFishX;
        isReady = true;
      }
    }
  }

  void updateStruggle() {
    float move = (random(100) < 0.5) ? 25.0 : struggle;
    fishX += move;
  }

  void displayShadow() {
    fill(50, 50, 50, 150);
    ellipse(fishX, 380, 50, 30);
  }

  void displayFish() {
    if (fishImg != null) {
      pushMatrix();
      translate(fishX, 380);
      imageMode(CENTER);
      
      // Resizing 1280x1280 down to 64x64 on the fly for better visibility
      image(fishImg, 0, 0, 64, 64);
      popMatrix();
      imageMode(CORNER);
    } else {
      fill(50, 80, 150);
      ellipse(fishX, 380, 40, 25);
    }
  }
}
