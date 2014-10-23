void addButton(String naam, int id, int menu, int x, int y, int wid, int hei, int bgCol, int fgCol){
  int loc = getEmptyButtonLocation();
  buttonData[loc] = new int[] {
    id, menu, x, y, wid, hei, bgCol, fgCol
  };
  buttonTxt[loc] = naam;
}

int getEmptyButtonLocation(){
  for(int i = 0; i < buttonData.length; i++)
    if(buttonData[i] == null)
       return i;
  println("Not enough space in button data array!");
  return -1;
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
}

//Button Actions \/
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
  println(id);
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
  gameTime = 0;
  highScore = null;
  foundSets = 0;
  cardsInStack = 0;
  possibleSets = 0;
  wrongSets = 0;
  for(int i = 0; i < buttonData.length; i++)
    if(buttonData[i] != null)
        if(buttonData[i][BUTTON_ID] >=100 && buttonData[i][BUTTON_ID] <200){
           buttonData[i] = null;
           buttonTxt[i] = null;
        }
}
void orderCards(){
}
void giveHint(){
}
void giveUp(){
}
void validInvalidSet(){
}
