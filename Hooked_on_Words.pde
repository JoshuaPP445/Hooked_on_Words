GameManager gm;
final int WAITING = 4;
PImage bgImage; // Add a variable for your background

void setup() {
  size(800, 450);
  
  // Load your new 800x450 background image from the 'data' folder
  bgImage = loadImage("background.jpg"); 
  
  gm = new GameManager();
}

void draw() {
  // Draw your background image at the top-left corner (0,0)
  if (bgImage != null) {
    image(bgImage, 0, 0);
  } else {
    background(200, 230, 255); // Fallback color if image is missing
  }
  
  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
