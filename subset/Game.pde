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
  int idCounter = 100;
  for(int i = 1; i <= (original ? 4 : 3); i++){
    for(int j = 1; j <= 3; j++){
       addCardToScreen(idCounter, i-1, j-1);
       idCounter++;
    }
  }
}

/**
 * de x en y zijn 0 based.
 */
Rectangle getDefaultCardLocation(int x, int y){
  return new Rectangle(x*80+370, y*170+55, 77, 150);
}

/**
 * het nr is tussen 1 tm 3
 */
Rectangle getSelectedCardLocation(int nr){
  return new Rectangle(10+nr*89, 420, 71, 120);
}

void addCardToScreen(int cardID, int x, int y){
  String card = stack.get(stack.size()-1);
  stack.remove(stack.size()-1);
  Rectangle rect = getDefaultCardLocation(x, y);
  addButton(card, cardID, SCREEN_GAME, rect.x, rect.y, rect.width, rect.height, 255, 0);
}

StringList getCardSet(boolean simple) {
  StringList out = new StringList();
  for (int i = 1; i <=3; i++) {
    for (int j = 1; j <=3; j++) {
      for (int k = 1; k <=3; k++) {
        if (simple) {
          out.append(makeCard(i, j, k, 4));
        } else {
          for (int l = 1; l <=3; l++) {
            out.append(makeCard(i, j, k, l));
          }
        }
      }
    }
  }
  return out;
}

String makeCard(int col, int shape, int amount, int background){
  String out = "";
  switch(col){
    case 1: out += C_COL_RED; break;
    case 2: out += C_COL_BLUE; break;
    case 3: out += C_COL_YELLOW; break;
  }
  switch(shape){
    case 1: out += C_SHAPE_ELLIPSE; break;
    case 2: out += C_SHAPE_QUAD; break;
    case 3: out += C_SHAPE_TRINAGLE; break;
  }
  switch(background){
    case 1: out += C_BG_ORANGE; break;
    case 2: out += C_BG_GREEN; break;
    case 3: out += C_BG_PURPLE; break;
    case 4: out += C_BG_NONE; break;
  }
  return out+=amount;
}

void saveGame(){
  
}
void shuffleStack(StringList in){
  for(int i = 0; i < in.size()-1; i++){
    int toSwich = floor(random(in.size()));
    if(i == toSwich)
        continue;
    String tmp = in.get(i);
    in.set(i, in.get(toSwich));
    in.set(toSwich, tmp);
  }
}



void updateGameTimer(){
  if(gameTime == -1)
    return;
  int time = (getUnixTime() - timerStartTime);
  int minutes = (int)time/60;
  int secs = time - (minutes*60);
  float newGameTime = round(minutes + (secs/100f), 2);
  if(newGameTime != gameTime){
    gameTime = newGameTime;
    forceScreenUpdate = true;
  }
}
