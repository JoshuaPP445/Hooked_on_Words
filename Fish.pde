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
  float targetBobberX;
  float stopPointX;

  Fish(float bobberX) {
    initialFishX = random(600, 700);
    fishX = entryX;
    name = names[(int)random(names.length)];

    targetBobberX = bobberX + random(-20, 20);
    stopPointX = targetBobberX + 60;

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
      fishX = lerp(fishX, stopPointX, 0.03);
      // Once it gets close enough, lock it into place and activate gameplay
      if (abs(fishX - stopPointX) < 5.0) {
        //fishX = initialFishX;
        fishX = stopPointX;
        isReady = true;
      }
    }
  }

  void updateStruggle() {
    fishX += struggle;
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
