int buttonCounter = 0;
void addButton(String naam, int id, int menu, int x, int y, int wid, int hei, int bgCol, int fgCol){
  buttonData[buttonCounter] = new int[] {
    id, menu, x, y, wid, hei, bgCol, fgCol
  };
  buttonTxt[buttonCounter] = naam;
  buttonCounter++;
}

void doButtonAction(int buttonID){
      switch(buttonID){
           case 1: startGame(false); break;
           case 2: startGame(true); break;
           case 3: showScoreScreen();break;
           case 4: showAboutScreen();break;
           case 5: loadGame();break;
           case 6: backToMenu();break;    //deze staat er twee keer in omdat er twee verschillende 
           case 7: backToMenu();break;    // knoppen zijn die deze actie uitvoeren.
           case 8: clearScores();break;
           case 9: saveAndQuit();break;
           case 10: orderCards();break;
           case 11: giveHint();break;
           case 12: giveUp();break;
           case 13: validInvalidSet();break;
      }
    if(buttonID >100 && buttonID <200)
          cardClickedAction(buttonID);
}

void buttonPressCheck(){
  for (int[] but : buttonData) {  
    if(but == null)
      continue;
    if (but[BUTTON_SCREEN] != selectedScreen) {
      continue;
    }
    if (mouseX > but[BUTTON_X] && mouseX < (but[BUTTON_X]+but[BUTTON_WIDTH])
      && mouseY > but[BUTTON_Y] && mouseY < (but[BUTTON_Y] + but[BUTTON_HEIGHT])) {
      doButtonAction(but[BUTTON_ID]);
    }
  }
}

void startGame(boolean original){
  gameStatus = (original ? GAME_ORIGINAL : GAME_SIMPLE);
  selectedScreen = SCREEN_GAME;
  forceScreenUpdate = true;
  
  stack = getCardSet(!original);
  shuffleStack(stack);
  
  timerStartTime = getUnixTime();
  gameTime = 0;
  
  if(scoreBoard[original ? 1 : 0].length > 0){
    highScore = scoreBoard[original ? 1 : 0][0][1];
  }else{
    highScore = "-";
  }
}

void showScoreScreen(){
  selectedScreen = SCREEN_SCORES;
  forceScreenUpdate = true;
}
void showAboutScreen(){
  selectedScreen = SCREEN_ABOUT;
  forceScreenUpdate = true;
  saveScoreBoard(scoreBoard, dataPath("high.scores"));
}
void backToMenu(){
  selectedScreen = SCREEN_MENU;
  forceScreenUpdate = true;
}
void cardClickedAction(int id){
}
void loadGame(){
}
void clearScores(){
  scoreBoard = new String[2][0][0];
  forceScreenUpdate = true;
}
void saveAndQuit(){
  saveGame();
  backToMenu();
  stack = null;
  onTable = null;
  gameTime = 0;
  highScore = null;
  foundSets = 0;
  cardsInStack = 0;
  possibleSets = 0;
  wrongSets = 0;
}
void orderCards(){
}
void giveHint(){
}
void giveUp(){
}
void validInvalidSet(){
}
