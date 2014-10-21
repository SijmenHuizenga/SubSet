void drawButtons(){
  for(int i = 0; i < buttonData.length; i++){
    int[] but = buttonData[i];
    String txt = buttonTxt[i];
    if(but == null || but[BUTTON_SCREEN] != selectedScreen)
      continue;
    if(but[BUTTON_ID] >100 && but[BUTTON_ID] < 200)
      drawCard(but[BUTTON_ID]);
    boolean doStar = txt.contains("*");
    txt = txt.replace("*", "");
    if(but == null)
      continue;
    fill(but[BUTTON_BGCOLOR]);
    noStroke();
    rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);
    
    textSize(but[BUTTON_HEIGHT]/4);
    
    fill(but[BUTTON_FGCOLOR]);
    textAlign(CENTER);
    text(txt, but[BUTTON_X]+(but[BUTTON_WIDTH]/2), but[BUTTON_Y]+(but[BUTTON_HEIGHT]/2)+(but[BUTTON_HEIGHT]/16));
    if(doStar){
      image(star, but[BUTTON_X]+10, but[BUTTON_Y]+12, but[BUTTON_HEIGHT]-20, but[BUTTON_HEIGHT]-20);
      image(star, but[BUTTON_X]+but[BUTTON_WIDTH]-but[BUTTON_HEIGHT]+12, but[BUTTON_Y]+10, but[BUTTON_HEIGHT]-20, but[BUTTON_HEIGHT]-20);
    }
  }
}

void drawCard(int dataLocation){
}

void drawScreen(){
   switch(selectedScreen){
     case SCREEN_MENU: drawMenu(); break;
     case SCREEN_GAME: drawGame(); break;
     case SCREEN_SCORES: drawScores(); break;
     case SCREEN_ABOUT: drawAbout(); break;
   }
}

void drawMenu(){
  background(0);
  fill(255);
  textSize(70);
  textAlign(CENTER);
  text("Ultimate Subset", width/2, 90);
  textSize(30);
  text("Door Sijmen Huizenga", width/2, 125);
}
void drawGame(){
  background(0);
}
void drawScores(){  
  background(0);
  String[][] simpleScores = scoreBoard[0];
  String[][] originalScores = scoreBoard[1];
  fill(255);
  if(simpleScores.length == 0 && originalScores.length == 0){
    textSize(30);
    textAlign(CENTER);
    text("No scores saved!", width/2, height/2);
  }else{
    textSize(50);
    fill(255);
    textAlign(CENTER);
    int marge = 25;
    text("Easy Mode", width/4, height/10);
    text("Original Mode", width/4*3, height/10);
    stroke(255);
    line(width/2, 0, width/2, height/2+marge*2);
    drawScoreList(simpleScores, marge, 120, width/2-marge*2, 40);
    drawScoreList(originalScores, width/2+marge, 120, width/2-marge*2, 40);
  }
}
void drawScoreList(String[][] list, int x, int y, int wid, int size){
  fill(255);
  textSize(size);
  for(int i = 0; i < list.length; i++){
    String name = list[i][0];
    String score = list[i][1];
    textAlign(LEFT);
    if(i == 0){
      text("    " + name, x, y+(i*(size+10)));
      image(star, x-6, y-size+6, size, size);
    }else{
      text((i+1) + ". " + name, x, y+(i*(size+10)));
    }
    textAlign(RIGHT);
    text(score, x+wid, y+(i*(size+10)));
  }
}
void drawAbout(){
  background(0);
}
