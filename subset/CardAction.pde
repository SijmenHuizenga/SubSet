void cardPressAction(int id){
  int[] but = getButton(id);
  
  if(selectedCards < 3){
    Rectangle place = getSelectedCardLocation(selectedCards);
    but[BUTTON_X] = place.x;
    but[BUTTON_Y] = place.y;
    but[BUTTON_WIDTH] = place.width;
    but[BUTTON_HEIGHT] = place.height;
    forceScreenUpdate = true;
  }
  selectedCards++;
}
