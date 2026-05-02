class Fish {
  float x;
  String name;
  float struggle;
  String[] names = {"Tuna", "Salmon", "Bass", "Mackerel", "Snapper"};

  Fish() {
    x = random(400, 600);
    name = names[(int)random(names.length)];
    struggle = 0.6;
  }

  void updateStruggle() {
    float move = (random(100) < 0.5) ? 25.0 : struggle; // Lunge logic
    x += move;
  }

  void displayShadow() {
    fill(50, 50, 50, 150);
    ellipse(x, 350, 50, 30);
  }

  void displayFish() {
    fill(50, 80, 150);
    ellipse(x, 350, 40, 25);
  }
}
