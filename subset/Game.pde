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
    case 1: out += "R"; break;
    case 2: out += "B"; break;
    case 3: out += "Y"; break;
  }
  switch(shape){
    case 1: out += "E"; break;
    case 2: out += "Q"; break;
    case 3: out += "T"; break;
  }
  switch(shape){
    case 1: out += "O"; break;
    case 2: out += "G"; break;
    case 3: out += "P"; break;
    case 4: out += "N"; break;
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
  gameTime = round(minutes + (secs/100f), 2);
  forceScreenUpdate = true;
}
