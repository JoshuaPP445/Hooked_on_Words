GameManager gm;
final int WAITING = 4;

void setup() {
  size(800, 450);
  //pixelDensity(1);
  gm = new GameManager();
}

void draw() {
  background(200, 230, 255);
  gm.run();
}

void keyPressed() {
  gm.handleInput();
}
