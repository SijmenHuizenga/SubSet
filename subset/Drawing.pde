void drawAbout() {
  background(bgColor);
  fill(textColor);
  textAlign(LEFT, TOP);
  textSize(15);
  text(infoTxt, 5, 5, 790, 500);
}

void drawMenu() {
  background(bgColor);
  fill(textColor);
  textSize(70);
  textAlign(CENTER);
  text("Ultimate Subset", width / 2, 90);
  textSize(30);
  text("Door Sijmen Huizenga", width / 2, 125);
}

void drawPopupScreen() {
  fill(color(43, 53, 255, 160));
  rectMode(CORNER);
  rect(0, 0, width - 1, height - 1);

  textAlign(CENTER, CENTER);
  textSize(50);
  fill(textColor);
  text(popupTxt, width / 2, height / 2);
}
void drawScreen() {
  switch (selectedScreen) {
  case SCREEN_MENU:
    drawMenu();
    break;
  case SCREEN_GAME:
    drawGame();
    break;
  case SCREEN_SCORES:
    drawScoreScreen();
    break;
  case SCREEN_ABOUT:
    drawAbout();
    break;
  }
}

