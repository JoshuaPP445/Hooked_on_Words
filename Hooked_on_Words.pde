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
  
  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
