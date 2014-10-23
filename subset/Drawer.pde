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
    if (but == null)
      continue;
    fill(but[BUTTON_BGCOLOR]);
    noStroke();
    rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);

    textSize(27);

    fill(but[BUTTON_FGCOLOR]);
    textAlign(CENTER, CENTER);
    text(txt, but[BUTTON_X]+(but[BUTTON_WIDTH]/2), but[BUTTON_Y]+(but[BUTTON_HEIGHT]/2.3));
    if (doStar) {
      image(star, but[BUTTON_X]+10, but[BUTTON_Y]+12, but[BUTTON_HEIGHT]-20, but[BUTTON_HEIGHT]-20);
      image(star, but[BUTTON_X]+but[BUTTON_WIDTH]-but[BUTTON_HEIGHT]+12, but[BUTTON_Y]+10, but[BUTTON_HEIGHT]-20, but[BUTTON_HEIGHT]-20);
    }
  }
}

void drawCard(int dataLocation) {
  int[] but = buttonData[dataLocation];
  int cardNr = buttonData[dataLocation][BUTTON_ID]-100;
  String card = buttonTxt[dataLocation];
  
  if (card.indexOf(C_BG_ORANGE) != -1)
    fill(BG_ORANGE);
  else if (card.indexOf(C_BG_GREEN) != -1)
    fill(BG_GREEN);
  else if (card.indexOf(C_BG_PURPLE) != -1)
    fill(BG_PURPLE);
  else
    fill(BG_NONE);
  rectMode(CORNER);
  rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);

  if (card.indexOf(C_COL_RED) != -1)
    fill(COL_RED);
  else if (card.indexOf(C_COL_BLUE) != -1)
    fill(COL_BLUE);
  else if (card.indexOf(C_COL_YELLOW) != -1)
    fill(COL_YELLOW);
  else
    println("ERROR: IMPPSSOBLE!");
  noStroke();
  int amount = int(card.replaceAll("\\D+", ""));
  for (int i = 0; i < amount; i++) {
    
    int centerX = but[BUTTON_X]+but[BUTTON_WIDTH]/2;
    int centerY = but[BUTTON_Y]+but[BUTTON_HEIGHT]/4*(i+1);
    int hei = but[BUTTON_HEIGHT]/5;
    int wid = but[BUTTON_HEIGHT]/3;
    
    if (card.indexOf(C_SHAPE_ELLIPSE) != -1) {
      ellipseMode(CENTER);
      ellipse(centerX, centerY, wid, hei);
    } else if (card.indexOf(C_SHAPE_QUAD) != -1) {
      rectMode(CENTER);
      rect(centerX, centerY, wid, hei);
    } else if (card.indexOf(C_SHAPE_TRINAGLE) != -1) {
      triangle(centerX, centerY-hei/2, centerX-wid/2, centerY+hei/2, centerX+wid/2, centerY+hei/2);
    } else
      println("ERROR: IMPPSSOBLE!");
  }
}

void drawScreen() {
  switch(selectedScreen) {
  case SCREEN_MENU: 
    drawMenu(); 
    break;
  case SCREEN_GAME: 
    drawGame(); 
    break;
  case SCREEN_SCORES: 
    drawScores(); 
    break;
  case SCREEN_ABOUT: 
    drawAbout(); 
    break;
  }
}

void drawMenu() {
  background(0);
  fill(255);
  textSize(70);
  textAlign(CENTER);
  text("Ultimate Subset", width/2, 90);
  textSize(30);
  text("Door Sijmen Huizenga", width/2, 125);
}
void drawGame() {
  background(0);
  stroke(150, 150, 150);
  noFill();
  rectMode(CORNER);
  rect(270, 5, 520, 590);
  for (int i = 0; i < 3; i++) {
    rect(10+i*89, 420, 71, 120);
  }
  String stats = "";
  stats += "Current Time: " + timeFloatToString(gameTime) + "\n";
  stats += "Found Sets: " + foundSets + "\n";
  stats += "Cards in Stacdk: " + cardsInStack + "\n";
  stats += "High Score: " + highScore + "\n";
  stats += "Possible Sets: " + possibleSets + "\n";
  stats += "Wrong Sets: " + wrongSets + "\n";
  textSize(20);
  textAlign(LEFT, TOP);
  fill(255);
  text(stats, 10, 10);
}
void drawScores() {  
  background(0);
  String[][] simpleScores = scoreBoard[0];
  String[][] originalScores = scoreBoard[1];
  //background
  textSize(50);
  fill(255);
  textAlign(CENTER);
  int marge = 25;
  text("Easy Mode", width/4, height/10);
  text("Original Mode", width/4*3, height/10);
  stroke(255);
  line(width/2, 0, width/2, height/2+marge*2);

  if (simpleScores.length == 0) {
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("No scores saved!", width/4, height/4);
  } else {
    drawScoreList(simpleScores, marge, 120, width/2-marge*2, 40);
  }

  if (originalScores.length == 0) {
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("No scores saved!", width/4*3, height/4);
  } else {
    drawScoreList(originalScores, width/2+marge, 120, width/2-marge*2, 40);
  }
}
void drawScoreList(String[][] list, int x, int y, int wid, int size) {
  fill(255);
  textSize(size);
  for (int i = 0; i < list.length; i++) {
    String name = list[i][0];
    String score = list[i][1];
    textAlign(LEFT);
    if (i == 0) {
      text("    " + name, x, y+(i*(size+10)));
      image(star, x-6, y-size+6, size, size);
    } else {
      text((i+1) + ". " + name, x, y+(i*(size+10)));
    }
    textAlign(RIGHT);
    text(score, x+wid, y+(i*(size+10)));
  }
}
void drawAbout() {
  background(0);
}

