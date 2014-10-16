void drawButtons(){
  for(int i = 0; i < buttonData.length; i++){
    int[] but = buttonData[i];
    String txt = buttonTxt[i];
    if(but[BUTTON_ID] >100 && but[BUTTON_ID] < 200)
      drawCard(but[BUTTON_ID]);
    boolean doStar = txt.contains("*");
    txt = txt.replace("*", "");
    if(but == null)
      continue;
    fill(but[BUTTON_BGCOLOR]);
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
}
void drawScores(){  
}
void drawAbout(){
}
