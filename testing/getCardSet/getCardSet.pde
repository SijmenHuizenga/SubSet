String[] getCardSet(boolean simple) {
  String[] out = new String[simple ? 27 : 81];
  int counter  = 0;
  for (int i = 1; i <=3; i++) {
    for (int j = 1; j <=3; j++) {
      for (int k = 1; k <=3; k++) {
        if (simple) {
          out[counter] = makeCardString(i, j, k, 4);
          counter++;
        } else {
          for (int l = 1; l <=3; l++) {
            out[counter] = makeCardString(i, j, k, l);
            counter++;
          }
        }
      }
    }
  }
  return out;
}

String makeCardString(int i, int j, int k, int l){
  println(i, j, k, l);
  return "";
}

void setup(){
  getCardSet(false);
}
