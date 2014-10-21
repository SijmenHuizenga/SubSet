void initScoreBoard(){
  if(!new File(scoresFile).exists()){
    scoreBoard = new String[2][0][0];
    return;
  }
  scoreBoard = loadScoreBoard(scoresFile);
  orderScoreBoard(scoreBoard);
}

void saveScoreBoard(String[][][] board, String file){
  String[] out = new String[board.length];
  int i = 0;
  for(String[][] list : board){
    if(list == null){
      out[i] = "\n";
    }else{
      out[i] = "";
      for(String[] person : list){
       if(person == null)
          continue;
       out[i] += person[0] + ";";
       out[i] += person[1] + ";";
      }
    }
    i++;
  }
  saveStrings(file, out);
}

String[][][] loadScoreBoard(String file){
  String[] in = loadStrings(file);
  String[][][] out = new String[2][][];
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
  for(int i = 0; i < out.length; i++){
    if(out[i] == null)
       out[i] = new String[0][];
  }
  return out;
}

void orderScoreBoard(String[][][] board){
  for(String[][] list : board){
    if(list == null || list.length == 0)
       continue;
    boolean swiched = false;
    do{
      swiched = false;
      for(int i = 0; i < list.length-1; i++){
        if(float(list[i][1].replace(":", ".")) > float(list[i+1][1].replace(":", "."))){
          String[] keep = list[i];
          list[i] = list[i+1];
          list[i+1] = keep;
          swiched = true;
        }
      }
    }while(swiched);
  }
}
