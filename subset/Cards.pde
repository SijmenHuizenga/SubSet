void addCardToScreen() {
  if (stack.size() == 0)
    return;
  String card = stack.get(stack.size() - 1);
  stack.remove(stack.size() - 1);
  int cardID = getEmptyCardID();
  Rectangle rect = getDefaultCardLocation(cardID / 3, cardID % 3);
  addButton(card, cardIdToButtonId(cardID), SCREEN_GAME, rect.x, rect.y, rect.width, 
  rect.height, 255, 0);
}
int buttonIdToCardID(int buttonID) {
  return buttonID - 100;
}
void cardDragAction() {
  if (gameStatus == GAME_OVER)
    return;
  if (draggingCard == null || draggingCardOriginalPos[1] == getSelectedCardLocation(0).y)
    return;
  draggingCard[BUTTON_X] = constrain(mouseX - draggingMarge[0], 270, 
  790 - draggingCard[BUTTON_WIDTH]);
  draggingCard[BUTTON_Y] = constrain(mouseY - draggingMarge[1], 5, 
  595 - draggingCard[BUTTON_HEIGHT]);
  forceScreenUpdate = true;
}

int cardIdToButtonId(int cardID) {
  return cardID + 100;
}
void cardPressAction(int[] but) {
  if (gameStatus == GAME_OVER)
    return;
  if (draggingCard == null) {
    draggingCard = but;
    draggingCardOriginalPos = new int[] { 
      but[BUTTON_X], but[BUTTON_Y]
    };
    draggingMarge = new int[] { 
      mouseX - but[BUTTON_X], mouseY - but[BUTTON_Y]
    };
  }
}
void cardReleaseAction() {
  if (gameStatus == GAME_OVER)
    return;
  int[] but = draggingCard;
  if (but == null)
    return;

  // how far has the card beend dragged.
  int dx = abs(but[BUTTON_X] - draggingCardOriginalPos[0]);
  int dy = abs(but[BUTTON_Y] - draggingCardOriginalPos[1]);
  // was a small drag, handle as click
  if (sqrt(dx * dx + dy * dy) < 10) {
    // already selected?
    if (but[BUTTON_Y] == getSelectedCardLocation(0).y) {
      removeSelectedCard(but);
    } else {// not selected
      if (isSelectedSpotFree())// but still a spot free?
        addSelectedCard(but); // lets add that bich.
    }
    forceScreenUpdate = true;
  }

  draggingCard = null;
  draggingCardOriginalPos = null;
  draggingMarge = null;
}

void drawCard(int dataLocation) {
  int[] but = buttonData[dataLocation];
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
  stroke(0);
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
  int amount = Integer.parseInt(card.replaceAll("\\D+", ""));
  for (int i = 0; i < amount; i++) {

    int centerX = but[BUTTON_X] + but[BUTTON_WIDTH] / 2;
    int centerY = but[BUTTON_Y] + but[BUTTON_HEIGHT] / 4 * (i + 1);
    int hei = but[BUTTON_HEIGHT] / 5;
    int wid = but[BUTTON_HEIGHT] / 3;

    if (card.indexOf(C_SHAPE_ELLIPSE) != -1) {
      ellipseMode(CENTER);
      ellipse(centerX, centerY, wid, hei);
    } else if (card.indexOf(C_SHAPE_QUAD) != -1) {
      rectMode(CENTER);
      rect(centerX, centerY, wid, hei);
    } else if (card.indexOf(C_SHAPE_TRINAGLE) != -1) {
      triangle(centerX, centerY - hei / 2, centerX - wid / 2, centerY + hei / 2, centerX
        + wid / 2, centerY + hei / 2);
    } else
      println("ERROR: IMPPSSOBLE!");
  }
}

StringList getCardStack(boolean simple) {
  StringList out = new StringList();
  for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
      for (int k = 1; k <= 3; k++) {
        if (simple) {
          out.append(makeCard(i, j, k, 4));
        } else {
          for (int l = 1; l <= 3; l++) {
            out.append(makeCard(i, j, k, l));
          }
        }
      }
    }
  }
  return out;
}

Rectangle getDefaultCardLocation(int x, int y) {
  return new Rectangle(x * 80 + 290, y * 170 + 55, 77, 150);
}

int getEmptyCardID() {
  for (int cardID = 0; cardID <= 100; cardID++) {
    if (buttonIdToLocation(cardIdToButtonId(cardID)) == -1) {
      return cardID;
    }
  }
  return -1;
}

/**
 * Het idee van
 * "het volgende loopje starten op de plek waar de vorigge loop is gestopt"
 * komt van Bram. Gewoon een super geniaal idee.
 */
int getPossibleSets() {
  hintSet = null;
  int out = 0;
  int max = gameStatus == GAME_SIMPLE ? 9 : 12;
  for (int a = 0; a < max; a++) {
    int locA = buttonIdToLocation(cardIdToButtonId(a));
    if (locA == -1)
      continue;
    for (int b = a + 1; b < max; b++) {
      int locB = buttonIdToLocation(cardIdToButtonId(b));
      if (locB == -1)
        continue;
      for (int c = b + 1; c < max; c++) {
        int locC = buttonIdToLocation(cardIdToButtonId(c));
        if (locC == -1 || locC == locB || locC == locA)
          continue;
        if (isSet(new String[] { 
          buttonTxt[locA], buttonTxt[locB], buttonTxt[locC]
        }
        )) {
          out++;
          if (out == 1) {
            hintSet = new int[] { 
              locA, locB, locC
            };
          }
        }
      }
    }
  }
  return out;
}

Rectangle getSelectedCardLocation(int nr) {
  return new Rectangle(10 + nr * 89, 420, 71, 120);
}

boolean isSet(String... cards) {
  for (int i = 0; i < cards[0].length (); i++) {
    String curCheck = "";
    for (int j = 0; j < cards.length; j++) {
      curCheck += cards[j].charAt(i);
    }
    boolean good = isSameOrDiff(curCheck);
    if (!good)
      return false;
  }
  return true;
}

boolean isSetSelected() {
  if (isSelectedSpotFree())
    return false;
  String[] cards = new String[selectedCards.length];
  for (int i = 0; i < cards.length; i++) {
    cards[i] = buttonTxt[buttonIdToLocation(selectedCards[i])];
  }
  return isSet(cards);
}

String makeCard(int col, int shape, int amount, int background) {
  String out = "";
  switch (col) {
  case 1:
    out += C_COL_RED;
    break;
  case 2:
    out += C_COL_BLUE;
    break;
  case 3:
    out += C_COL_YELLOW;
    break;
  }
  switch (shape) {
  case 1:
    out += C_SHAPE_ELLIPSE;
    break;
  case 2:
    out += C_SHAPE_QUAD;
    break;
  case 3:
    out += C_SHAPE_TRINAGLE;
    break;
  }
  switch (background) {
  case 1:
    out += C_BG_ORANGE;
    break;
  case 2:
    out += C_BG_GREEN;
    break;
  case 3:
    out += C_BG_PURPLE;
    break;
  case 4:
    out += C_BG_NONE;
    break;
  }
  return out += amount;
}

void orderCards() {
  removeAllSelectedCards();
  int buttonIdCounter = cardIdToButtonId(0);
  int butLoc;
  while ( (butLoc = buttonIdToLocation (buttonIdCounter)) != -1) {

    int[] button = buttonData[butLoc];

    Rectangle rect = getDefaultCardLocation(buttonIdToCardID(buttonIdCounter) / 3, 
    buttonIdToCardID(buttonIdCounter) % 3);

    button[BUTTON_X] = rect.x;
    button[BUTTON_Y] = rect.y;
    button[BUTTON_WIDTH] = rect.width;
    button[BUTTON_HEIGHT] = rect.height;
    buttonIdCounter++;
  }
  forceScreenUpdate = true;
}

void shuffleStack(StringList in) {
  for (int i = 0; i < in.size (); i++) {
    int toSwich = floor(random(in.size()-i))+i;
    String tmp = in.get(i);
    in.set(i, in.get(toSwich));
    in.set(toSwich, tmp);
  }
}

