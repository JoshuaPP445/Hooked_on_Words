import gifAnimation.*;

GameManager gm;
final int WAITING = 4;
PImage bgImgFront, bgImgBack;
Gif oceanGif;

void setup() {
  size(800, 450);
  
  bgImgBack = loadImage("background_1.jpg");
  bgImgFront = loadImage("background_2.png");
  
  oceanGif = new Gif(this, "ocean.gif");
  oceanGif.loop();
  
  gm = new GameManager();
}

void draw() {
  if (bgImgBack != null) {
    image(bgImgBack, 0, 0);
  } else {
    background(200, 230, 255);
  }
  
  if (oceanGif != null) {
    image(oceanGif, 0, 0);
  }
  
  if (bgImgFront != null) {
    image(bgImgFront, 0, 0);
  } else {
    background(200, 230, 255);
  }
  
  // ---------------------------------------------------------
  // DEBUG OVERLAY: Delete or comment this section out later!
  // ---------------------------------------------------------
  //// 1. Draw a red crosshair at the mouse position
  //stroke(255, 0, 0);
  //strokeWeight(1);
  //line(mouseX - 10, mouseY, mouseX + 10, mouseY);
  //line(mouseX, mouseY - 10, mouseX, mouseY + 10);
  
  //// 2. Display the coordinate text near the cursor
  //fill(0);
  //rect(mouseX + 15, mouseY - 25, 95, 22, 5); // Background box for readability
  //fill(255, 255, 0); // Bright yellow text
  //textSize(14);
  //textAlign(LEFT, CENTER);
  //text("X: " + mouseX + " Y: " + mouseY, mouseX + 20, mouseY - 15);
  // ---------------------------------------------------------
  
  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
