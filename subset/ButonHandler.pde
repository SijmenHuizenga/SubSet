void doButtonAction(int buttonID){
      switch(buttonID){
           case 1: startGame(false); break;
           case 2: startGame(true); break;
           case 3: showScoreScreen();break;
           case 4: showAboutScreen();break;
           case 5: loadGame();break;
           case 6: backToMenu();break;    //deze staat er twee keer in omdat er twee verschillende 
           case 7: backToMenu();break;  // knoppen zijn die deze actie uitvoeren.
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

void cardClickedAction(int id){
}

void startGame(boolean original){
}
void showScoreScreen(){
}
void showAboutScreen(){
}
void loadGame(){
}
void backToMenu(){
}
void clearScores(){
}
void saveAndQuit(){
}
void orderCards(){
}
void giveHint(){
}
void giveUp(){
}
void validInvalidSet(){
}
