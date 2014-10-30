void backToMenu() {
  selectedScreen = SCREEN_MENU;
  forceScreenUpdate = true;
}

void showAboutScreen() {
  selectedScreen = SCREEN_ABOUT;
  forceScreenUpdate = true;
  if (infoTxt == null) {
    infoTxt = loadFileAsString(infoTxtFile);
  }
}

void showScoreScreen() {
  selectedScreen = SCREEN_SCORES;
  forceScreenUpdate = true;
}

