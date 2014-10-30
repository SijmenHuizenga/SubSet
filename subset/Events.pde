public void draw() {
  if (forceScreenUpdate || lastTime != getTimeSeconds()) {
    drawScreen();
    drawButtons();
    lastTime = getTimeSeconds();
    if (popupTxt != null) {
      drawPopupScreen();
    }
    forceScreenUpdate = false;
  }
}

public void keyPressed() {
  if (debug) {
    if (key == 'h')
      giveHint(3);
    if (key == 'g')
      handInSet();
  }
}

public void mousePressed() {
  if (popupTxt != null) {
    if (popupTxt.startsWith(gameOverTxt))
      quitGame();
    popupTxt = null;
    forceScreenUpdate = true;
    return;
  }
  int[] but = getButtonAtLocation(mouseX, mouseY, selectedScreen);
  if (but == null)
    return;
  if (but[BUTTON_ID] >= 100 && but[BUTTON_ID] < 200)
    cardPressAction(but);
  else
    doButtonAction(but[BUTTON_ID]);
}

public void mouseDragged() {
  if (selectedScreen == SCREEN_GAME)
    cardDragAction();
}

public void mouseReleased() {
  if (selectedScreen == SCREEN_GAME)
    cardReleaseAction();
}

public void exit() {
  saveScoreBoard(scoreBoard, scoresFile);
  super.exit();
}

