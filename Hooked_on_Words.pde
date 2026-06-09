import processing.sound.*;
SoundFile bgm;
SoundFile hookSfx;
SoundFile loseFish;
SoundFile gameOver;

import gifAnimation.*;

GameManager gm;
final int WAITING = 4;
final int CASTING = 5;
final int INTRO = 6;

// Global mode state flag managed here
boolean freeTypeMode = false; 

PImage bgImgBack;
PImage[] fishermanImg = new PImage[4];
int currentFrame = 0;
int castFrameCounter = 0;
Gif oceanGif;

void setup() {
  size(800, 450);

  bgImgBack = loadImage("background.png");
  fishermanImg[0] = loadImage("fisher_1.png");
  fishermanImg[1] = loadImage("fisher_2.png");
  fishermanImg[2] = loadImage("fisher_3.png");
  fishermanImg[3] = loadImage("fisher_4.png");

  oceanGif = new Gif(this, "ocean.gif");
  oceanGif.loop();
  bgm = new SoundFile(this, "bgm.mp3");
  bgm.loop();
  bgm.amp(0.3);

  hookSfx = new SoundFile(this, "hook.mp3");
  loseFish = new SoundFile(this, "lose.mp3");
  gameOver = new SoundFile(this, "over.mp3");

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

  if (gm.gameState == CASTING) {
    castFrameCounter++;
    if (castFrameCounter % 8 == 0) { 
      currentFrame++;
      if (currentFrame > 3) {
        currentFrame = 3; 
        gm.finishCasting();
      }
    } 
  } else if (gm.gameState == 1) {
    currentFrame = 2 + (frameCount / 10) % 2;
  } else {
    currentFrame = 0; 
  }

  if (fishermanImg[currentFrame] != null) {
    image(fishermanImg[currentFrame], 0, 0);
  }

  gm.run();
}

void keyPressed() {
  gm.handleInput();
}

void mousePressed() {
  gm.handleMouse();
}
