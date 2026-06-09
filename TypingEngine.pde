class TypingEngine {
  String target;
  String input = "";
  int index = 0;
  boolean[] isCorrect;
  boolean failed = false;

  StringList easySentences;
  StringList mediumSentences;
  StringList hardSentences;

  TypingEngine() {
    easySentences = new StringList("Easy does it", "Hold the line", "Fish on", "Lucky Catch", "Tight line", "hooked");
    mediumSentences = new StringList("Keep reeling it in", "Dont let it get away", "Pull it closer", "One more cast");
    hardSentences = new StringList("The ocean is deep and blue", "Fighting a monster of the deep", "Hold on for dear life", "The fish pulls hard", "One chance one catch");
  }

  void addCustomSentence(String sentence, String diff) {
    if (sentence.trim().length() == 0) return;
    
    if (diff.equals("easy")) {
      easySentences.append(sentence);
    } else if (diff.equals("medium")) {
      mediumSentences.append(sentence);
    } else if (diff.equals("hard")) {
      hardSentences.append(sentence);
    }
  }

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

  void checkReelingInput(Fish f, GameManager gm) {
    if (freeTypeMode) {
      if (key == BACKSPACE && input.length() > 0) {
        input = input.substring(0, input.length() - 1);
      } else if (key == ENTER || key == RETURN) {
        if (input.trim().length() > 0) {
          float pullPower = input.trim().length() * 25;
          f.fishX -= pullPower; 
          input = ""; 
        }
      } else if (key != CODED && key != ESC && key != BACKSPACE) {
        input += key;
      }
    } else {
      float totalDistance = f.fishX - gm.fishCaughtX;
      int remainingChars = max(1, target.length() - index);
      float step = totalDistance / remainingChars;

      if (index < target.length()) {
        if (Character.toLowerCase(key) == Character.toLowerCase(target.charAt(index))) {
          f.fishX -= step;
          isCorrect[index] = true;
          index++;
        } else {
          f.fishX += 35;
          if (index >= 0 && index < isCorrect.length) {
            isCorrect[index] = false;
          }
        }
      }
    }
  }

  void displayBubble() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(50, 100, 200, 50, 15);
    noStroke();

    fill(0);
    textAlign(CENTER);
    if (input.length() == 0) {
      textSize(16);
      fill(160);
      text("Input fish name", 150, 129);
    } else {
      textSize(18);
      fill(0);
      text(input + "|", 150, 132);
    }
  }

  void displaySentence() {
    if (freeTypeMode) {
      displayFreeType();
      return;
    }

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

  void displayFreeType() {
    textAlign(CENTER);
    textSize(22);
    fill(0, 102, 204);
    text("FREE REELING MODE: Type anything to pull!", width/2, 110);
    
    stroke(50, 120, 200);
    strokeWeight(2);
    fill(245, 250, 255);
    rect(width/2 - 250, 135, 500, 45, 10);
    noStroke();
    
    fill(0);
    textSize(24);
    textAlign(LEFT, CENTER);
    text(input + (frameCount % 45 < 22 ? "|" : ""), width/2 - 230, 155);
    
    textAlign(CENTER);
    textSize(13);
    fill(100);
    text("Press ENTER to execute pull strength based on word length!", width/2, 205);
  }

  String getRandomSentence(String diff) {
    if (diff.equals("easy")) {
      int r = (int)random(easySentences.size());
      return easySentences.get(r);
    } else if (diff.equals("medium")) {
      int r = (int)random(mediumSentences.size());
      return mediumSentences.get(r);
    } else {
      int r = (int)random(hardSentences.size());
      return hardSentences.get(r);
    }
  }
}
