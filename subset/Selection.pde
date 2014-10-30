boolean isSelectedSpotFree() {
  for (int i = 0; i < selectedCards.length; i++) {
    if (selectedCards[i] == 0) {
      return true;
    }
  }
  return false;
}

void removeAllSelectedCards() {
  for (int buttonID : selectedCards) {
    if (buttonID == 0)
      continue;
    int[] button = buttonData[buttonIdToLocation(buttonID)];
    Rectangle rect = getDefaultCardLocation(buttonIdToCardID(buttonID) / 3, 
    buttonIdToCardID(buttonID) % 3);

    button[BUTTON_X] = rect.x;
    button[BUTTON_Y] = rect.y;
    button[BUTTON_WIDTH] = rect.width;
    button[BUTTON_HEIGHT] = rect.height;
  }
  selectedCards = new int[3];
  forceScreenUpdate = true;
}

void removeSelectedCard(int[] button) {
  for (int i = 0; i < selectedCards.length; i++) {
    if (selectedCards[i] == button[BUTTON_ID]) {
      selectedCards[i] = 0;

      Rectangle place = getDefaultCardLocation(buttonIdToCardID(button[BUTTON_ID]) / 3, 
      buttonIdToCardID(button[BUTTON_ID]) % 3);
      button[BUTTON_X] = place.x;
      button[BUTTON_Y] = place.y;
      button[BUTTON_WIDTH] = place.width;
      button[BUTTON_HEIGHT] = place.height;
    }
  }
}

