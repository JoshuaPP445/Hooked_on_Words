class TypingEngine {
  String target;
  String input = "";
  int index = 0;
  boolean[] isCorrect;
  boolean failed = false;

  // Categorized sentence pools
  String[] easySentences = {"Easy does it", "Hold the line", "Fish on", "Lucky Catch", "Tight line", "hooked"};
  String[] mediumSentences = {"Keep reeling it in", "Dont let it get away", "Pull it closer", "One more cast"};
  String[] hardSentences = {"The ocean is deep and blue", "Fighting a monster of the deep", "Hold on for dear life", "The fish pulls hard", "One chance one catch"};

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
  // Calculate total distance the fish needs to travel to reach the caught zone
  float totalDistance = f.initialFishX - gm.fishCaughtX;
  
  if (index < target.length()) {
    // Each character represents 1 / target.length() of that total distance
    float step = totalDistance / target.length(); 
    
    if (Character.toLowerCase(key) == Character.toLowerCase(target.charAt(index))) {
      f.fishX -= step; // Pulls closer by exactly 1 fraction of the distance
      isCorrect[index] = true;
    } else {
      f.fishX += step * 3; // Incorrect stroke penalizes by 3 fractions backward
      isCorrect[index] = false;
    }
    index++;
    
    // Pull next sentence from the specific difficulty pool if this one is finished
    if (index >= target.length()) {
      setTarget(getRandomSentence(f.fishDiff), false);
    }
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

  // Gets a random sentence based on the passed difficulty string
  String getRandomSentence(String diff) {
    if (diff.equals("easy")) {
      return easySentences[(int)random(easySentences.length)];
    } else if (diff.equals("medium")) {
      return mediumSentences[(int)random(mediumSentences.length)];
    } else {
      return hardSentences[(int)random(hardSentences.length)];
    }
  }
}
