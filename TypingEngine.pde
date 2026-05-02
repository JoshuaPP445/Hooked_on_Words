class TypingEngine {
  String target;
  String input = "";
  int index = 0;
  boolean[] isCorrect;
  boolean failed = false;
  String[] sentences = {"Keep reeling it in", "The ocean is deep and blue", "Dont let it get away"};

  void setTarget(String t, boolean clearInput) {
    target = t;
    index = 0;
    failed = false;
    if (clearInput) input = "";
    isCorrect = new boolean[target.length()];
  }

  boolean checkBubbleInput() {
    if (key == BACKSPACE && input.length() > 0) input = input.substring(0, input.length()-1);
    else if (key == ENTER || key == RETURN) {
      if (input.equalsIgnoreCase(target)) return true;
      else failed = true;
    } else if (key != CODED && key != ESC) input += key;
    return false;
  }

  void checkReelingInput(Fish f) {
    if (index < target.length()) {
      if (Character.toLowerCase(key) == Character.toLowerCase(target.charAt(index))) {
        f.x -= 25;
        isCorrect[index] = true;
      } else {
        f.x += 35;
        isCorrect[index] = false;
      }
      index++;
      if (index >= target.length()) setTarget(getRandomSentence(), false);
    }
  }

  void displayBubble() {
    fill(255);
    rect(100, 50, 200, 50, 15);
    fill(0);
    textAlign(CENTER);
    text(input + "|", 200, 82);
  }

  void displaySentence() {
    textAlign(LEFT);
    textSize(28);
    float startX = width/2 - (textWidth(target)/2);
    for (int i=0; i<target.length(); i++) {
      fill(i < index ? (isCorrect[i] ? color(0, 150, 0) : color(255, 0, 0)) : 150);
      text(target.charAt(i), startX + textWidth(target.substring(0, i)), 160);
      if (i == index && frameCount % 40 < 20) {
        fill(0, 100, 255);
        rect(startX + textWidth(target.substring(0, i)), 135, 3, 30);
      }
    }
  }

  String getRandomSentence() {
    return sentences[(int)random(sentences.length)];
  }
}
