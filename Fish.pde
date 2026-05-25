class Fish {
  float fishX;
  String name;
  float struggle;
  int fishScore;
  String fishDiff;
  String[] names = {"Tuna", "Salmon", "Bass", "Trout", "Snapper"};
  PImage fishImg; // Holds the unique image for this fish

  Fish() {
    fishX = random(400, 600);
    name = names[(int)random(names.length)];
    
    // Load the unique image based on the lowercase name of the fish
    // Ensure these files (e.g., "bass.png") exist in your sketch's 'data' folder!
    fishImg = loadImage(name.toLowerCase() + ".png");
    
    if (name.equals("Bass")) {
      fishDiff = "easy";
      fishScore = 5;
      struggle = 0.4;
    } else if (name.equals("Mackerel") || name.equals("Snapper")) {
      fishDiff = "medium";
      fishScore = 15;
      struggle = 0.9;
    } else { 
      fishDiff = "hard";
      fishScore = 40;
      struggle = 1.4;
    }
  }

  void updateStruggle() {
    float move = (random(100) < 0.5) ? 25.0 : struggle;
    fishX += move;
  }

  void displayShadow() {
    fill(50, 50, 50, 150);
    ellipse(fishX, 350, 50, 30);
  }

  void displayFish() {
    if (fishImg != null) {
      pushMatrix();
      // Move origin to the fish's current position
      translate(fishX, 350); 
      
      // Apply 45-degree rotation
      rotate(radians(-45));
      
      // Flip vertically: X stays normal (1), Y is inverted (-1)
      scale(-1, 1); 
      
      // Center image alignment mode for rotation accuracy
      imageMode(CENTER); 
      
      // Draw the image resized to 48x48 pixels at local origin (0,0)
      image(fishImg, 0, 0, 48, 48); 
      popMatrix();
      
      // Reset imageMode back to default CORNER so it doesn't mess up UI components elsewhere
      imageMode(CORNER); 
    } else {
      // Fallback shape in case the image fails to load
      fill(50, 80, 150);
      ellipse(fishX, 350, 40, 25);
    }
  }
}
