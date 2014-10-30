void drawGame() {
  updateGameInfo();

  background(bgColor);
  stroke(150, 150, 150);
  noFill();
  rectMode(CORNER);
  rect(270, 5, 520, 590);
  for (int i = 0; i < 3; i++) {
    Rectangle place = getSelectedCardLocation(i);
    rect(place.x, place.y, place.width - 1, place.height - 1);
  }
  String stats = "";
  stats += "Current Time: \t" + getTimerString() + "\n";
  stats += "Found Sets: " + foundSets + "\n";
  stats += "Cards in Stacdk: " + stack.size() + "\n";
  stats += "High Score: " + highScore + "\n";
  stats += "Possible Sets: " + possibleSets + "\n";
  textSize(20);
  textAlign(LEFT, TOP);
  fill(textColor);
  text(stats, 10, 10);
}

void giveHint(int amount) {
  timerStartTime -= 30 * amount;
  removeAllSelectedCards();
  if (hintSet == null)
    return;
  for (int i = 0; i < amount; i++)
    addSelectedCard(buttonData[hintSet[i]]);
  forceScreenUpdate = true;
}

void handInSet() {
  if (isSelectedSpotFree())
    return; // still a spot left in the selected cards space.
  if (!isSetSelected())
    return; // it is not a set.
  for (int id : selectedCards) {
    int loc = buttonIdToLocation(id);
    buttonData[loc] = null;
    buttonTxt[loc] = null;
    addCardToScreen();
  }
  foundSets++;
  selectedCards = new int[3];
  forceScreenUpdate = true;
  possibleSets = getPossibleSets();
}

void loadGame(String fileName) {
  if (!new File(fileName).exists()) {
    JOptionPane.showMessageDialog(this, "No saved file.", "Error", 
    JOptionPane.ERROR_MESSAGE);
    return;
  }
  selectedScreen = SCREEN_GAME;
  stack = new StringList();

  String[] in = loadStrings(fileName);
  for (String line : in) {
    if (line.startsWith("gameType:")) {
      line = line.substring(9);
      gameStatus = (line.equals("0") ? GAME_SIMPLE : GAME_ORIGINAL);
    } else if (line.startsWith("time:")) {
      line = line.substring(5);
      timerStartTime = getUnixTime() - Integer.parseInt(line);
    } else if (line.startsWith("name:")) {
      line = line.substring(5);
      playerName = line;
    } else if (line.startsWith("cardsOnScreen:")) {
      line = line.substring(14);
      String[] cards = line.split(";");
      for (String card : cards) {
        stack.append(card);
        addCardToScreen();
      }
    } else if (line.startsWith("cardsInStack:")) {
      line = line.substring(13);
      String[] cards = line.split(";");
      for (String card : cards) {
        stack.append(card);
      }
    }
  }

  if (scoreBoard[gameStatus == GAME_ORIGINAL ? 1 : 0].length > 0) {
    highScore = scoreBoard[gameStatus == GAME_ORIGINAL ? 1 : 0][0][1];
  } else {
    highScore = "-";
  }

  possibleSets = getPossibleSets();

  forceScreenUpdate = true;
}

void quitGame() {
  backToMenu();
  stack = null;
  timerStartTime = 0;
  highScore = null;
  foundSets = 0;
  possibleSets = 0;
  for (int i = 0; i < buttonData.length; i++)
    if (buttonData[i] != null)
      if (buttonData[i][BUTTON_ID] >= 100 && buttonData[i][BUTTON_ID] < 200) {
        buttonData[i] = null;
        buttonTxt[i] = null;
      }
  selectedCards = new int[3];
}

void saveGame(String fileName) {
  if (gameStatus == GAME_OVER)
    return;
  String[] out = new String[6];
  out[0] = "time:" + (getUnixTime() - timerStartTime);
  out[1] = "gameType:" + (gameStatus == GAME_ORIGINAL ? 1 : 0);
  out[2] = "name:" + playerName;
  out[3] = "cardsOnScreen:";
  int buttonIdCounter = cardIdToButtonId(0);
  int butLoc;
  while ( (butLoc = buttonIdToLocation (buttonIdCounter)) != -1) {
    out[3] += buttonTxt[butLoc] + ";";
    buttonIdCounter++;
  }
  out[4] = "cardsInStack:";
  for (String card : stack) {
    out[4] += card + ";";
  }
  saveStrings(fileName, out);
  JOptionPane.showMessageDialog(this, "Game is saved.", "Done", 
  JOptionPane.INFORMATION_MESSAGE);
}

void startGame(boolean original) {
  playerName = JOptionPane.showInputDialog(this, "What  is your name?", "Before we start...", 
  JOptionPane.QUESTION_MESSAGE);
  if (playerName == null || playerName.equals("") || playerName.length() > 8
    || playerName.contains(";") || playerName.contains(":")) {
    playerName = null;
    return;
  }
  gameStatus = (original ? GAME_ORIGINAL : GAME_SIMPLE);
  selectedScreen = SCREEN_GAME;
  forceScreenUpdate = true;

  stack = getCardStack(!original);
  shuffleStack(stack);

  timerStartTime = getUnixTime();

  if (scoreBoard[original ? 1 : 0].length > 0) {
    highScore = scoreBoard[original ? 1 : 0][0][1];
  } else {
    highScore = "-";
  }
  for (int i = 0; i < (original ? 4 : 3); i++) {
    for (int j = 0; j < 3; j++) {
      addCardToScreen();
    }
  }
  possibleSets = getPossibleSets();
}
void updateGameInfo() {
  int loc = buttonIdToLocation(13);

  if (!isSelectedSpotFree()) {
    if (isSetSelected()) {
      buttonData[loc][BUTTON_BGCOLOR] = color(0, 255, 0);
      buttonTxt[loc] = "Set! Hand in.";
    } else {
      buttonData[loc][BUTTON_BGCOLOR] = color(160, 0, 0);
      buttonTxt[loc] = "No set.";
    }
  } else {
    buttonData[loc][BUTTON_BGCOLOR] = color(150, 150, 150);
    buttonTxt[loc] = "";
  }

  // no set possible: GAME OVER!
  if (possibleSets == 0 && gameStatus != GAME_OVER) {
    addScoreEntry(gameStatus == GAME_ORIGINAL ? 1 : 0, playerName, getTimerString());
    orderScoreBoard(scoreBoard);
    maximizeScoreBoard(scoreBoard);
    saveScoreBoard(scoreBoard, scoresFile);

    popupTxt = gameOverTxt + "!\nScore: " + getTimerString();

    forceScreenUpdate = true;
    gameStatus = GAME_OVER;
  }
}

