void initScoreBoard(){
  String file = dataPath("high.scores");
  if(!new File(file).exists()){
    scoreBoard = new String[2][0][0];
    return;
  }
  scoreBoard = loadScoreBoard(file);
}

void saveScoreBoard(String[][][] board, String file){
  String[] out = new String[board.length];
  int i = 0;
  for(String[][] list : board){
    if(list == null)
      continue;
    out[i] = "";
    for(String[] person : list){
     if(person == null)
        continue;
     out[i] += person[0] + ";";
     out[i] += person[1] + ";";
    }
    i++;
  }
  saveStrings(file, out);
}

String[][][] loadScoreBoard(String file){
  String[] in = loadStrings(file);
  String[][][] out = new String[in.length][][];
  int list = 0;
  for(String line : in){
    String[] vals = line.split(";");
    out[list] = new String[vals.length/2][];
    String name = null;
    int person = 0;
    for(String val : vals){
      if(name == null){
        name = val;
      }else{
        out[list][person] = new String[]{name, val};
        person++;
        name = null;
      }
    }
    list++;
  }
  return out;
}
