void addButton(String naam, int id, int menu, int x, int y, int wid, int hei, int bgCol, 
int fgCol) {
  int loc = getEmptyButtonLocation();
  buttonData[loc] = new int[] { 
    id, menu, x, y, wid, hei, bgCol, fgCol
  };
  buttonTxt[loc] = naam;
}
int buttonIdToLocation(int id) {
  for (int i = 0; i < buttonData.length; i++)
    if (buttonData[i] != null && buttonData[i][BUTTON_ID] == id)
      return i;
  return -1;
}
void doButtonAction(int buttonID) {
  switch (buttonID) {
  case 1:
    startGame(false);
    break;
  case 2:
    startGame(true);
    break;
  case 3:
    showScoreScreen();
    break;
  case 4:
    showAboutScreen();
    break;
  case 5:
    loadGame(gameFile);
    break;
  case 6:
    backToMenu();
    break; // deze staat er twee keer in omdat er twee verschillende
  case 7:
    backToMenu();
    break; // knoppen zijn die deze actie uitvoeren.
  case 8:
    clearScores();
    break;
  case 9:
    saveGame(gameFile);
    quitGame();
    break;
  case 10:
    orderCards();
    break;
  case 11:
    giveHint(2);
    break;
  case 12:
    quitGame();
    break;
  case 13:
    handInSet();
    break;
  case 14:
    doSuperSecretStuff();
    break;
  default:
    println("ERRRORORROR: could not start action of button " + buttonID);
  }
}

void drawButtons() {
  rectMode(CORNER);
  for (int i = 0; i < buttonData.length; i++) {
    int[] but = buttonData[i];
    String txt = buttonTxt[i];
    if (but == null || but[BUTTON_SCREEN] != selectedScreen)
      continue;
    if (but[BUTTON_ID] >= 100 && but[BUTTON_ID] < 200) {
      drawCard(i);
      continue;
    }
    boolean doStar = txt.contains("*");
    txt = txt.replace("*", "");
    fill(but[BUTTON_BGCOLOR]);
    noStroke();
    rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);

    textSize(27);

    fill(but[BUTTON_FGCOLOR]);
    textAlign(CENTER, CENTER);
    text(txt, but[BUTTON_X] + (but[BUTTON_WIDTH] / 2), but[BUTTON_Y]
      + (but[BUTTON_HEIGHT] / 2.3f));
    if (doStar) {
      image(star, but[BUTTON_X] + 10, but[BUTTON_Y] + 12, but[BUTTON_HEIGHT] - 20, 
      but[BUTTON_HEIGHT] - 20);
      image(star, but[BUTTON_X] + but[BUTTON_WIDTH] - but[BUTTON_HEIGHT] + 12, 
      but[BUTTON_Y] + 10, but[BUTTON_HEIGHT] - 20, but[BUTTON_HEIGHT] - 20);
    }
  }
}

int[] getButtonAtLocation(int x, int y, int screen) {
  for (int i = buttonData.length - 1; i >= 0; i--) {
    int[] but = buttonData[i];
    if (but == null)
      continue;
    if (but[BUTTON_SCREEN] != screen) {
      continue;
    }
    if (x > but[BUTTON_X] && x < (but[BUTTON_X] + but[BUTTON_WIDTH]) && y > but[BUTTON_Y]
      && y < (but[BUTTON_Y] + but[BUTTON_HEIGHT])) {
      return but;
    }
  }
  return null;
}

int getEmptyButtonLocation() {
  for (int i = 0; i < buttonData.length; i++)
    if (buttonData[i] == null)
      return i;
  println("Not enough space in button data array!");
  return -1;
}

