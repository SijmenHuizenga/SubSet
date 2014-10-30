void addScoreEntry(int board, String name, String score) {
  String[][] newList = new String[scoreBoard[board].length + 1][];
  int i;
  for (i = 0; i < scoreBoard[board].length; i++) {
    newList[i] = scoreBoard[board][i];
  }
  newList[i] = new String[] { 
    name, score
  };
  scoreBoard[board] = newList;
}

void clearScores() {
  scoreBoard = new String[2][0][0];
  forceScreenUpdate = true;
}

void drawScoreList(String[][] list, int x, int y, int wid, int size) {
  fill(255);
  textSize(size);
  for (int i = 0; i < list.length; i++) {
    String name = list[i][0];
    String score = list[i][1];
    textAlign(LEFT);
    if (i == 0) {
      text("    " + name, x, y + (i * (size + 10)));
      image(star, x - 6, y - size + 6, size, size);
    } else {
      text((i + 1) + ". " + name, x, y + (i * (size + 10)));
    }
    textAlign(RIGHT);
    text(score, x + wid, y + (i * (size + 10)));
  }
}

void drawScoreScreen() {
  background(bgColor);
  String[][] simpleScores = scoreBoard[0];
  String[][] originalScores = scoreBoard[1];
  // background
  textSize(50);
  fill(textColor);
  textAlign(CENTER);
  int marge = 25;
  text("Easy Mode", width / 4, height / 10);
  text("Original Mode", width / 4 * 3, height / 10);
  stroke(255);
  line(width / 2, 0, width / 2, height / 2 + marge * 2);

  if (simpleScores.length == 0) {
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("No scores saved!", width / 4, height / 4);
  } else {
    drawScoreList(simpleScores, marge, 120, width / 2 - marge * 2, 40);
  }

  if (originalScores.length == 0) {
    fill(255);
    textSize(30);
    textAlign(CENTER);
    text("No scores saved!", width / 4 * 3, height / 4);
  } else {
    drawScoreList(originalScores, width / 2 + marge, 120, width / 2 - marge * 2, 40);
  }
}

void initScoreBoard() {
  if (!new File(scoresFile).exists()) {
    scoreBoard = new String[2][0][0];
    return;
  }
  scoreBoard = loadScoreBoard(scoresFile);
  orderScoreBoard(scoreBoard);
}

String[][][] loadScoreBoard(String file) {
  String[] in = loadStrings(file);
  String[][][] out = new String[2][][];
  int list = 0;
  for (String line : in) {
    String[] vals = line.split(";");
    out[list] = new String[vals.length / 2][];
    String name = null;
    int person = 0;
    for (String val : vals) {
      if (name == null) {
        name = val;
      } else {
        out[list][person] = new String[] { 
          name, val
        };
        person++;
        name = null;
      }
    }
    list++;
  }
  for (int i = 0; i < out.length; i++) {
    if (out[i] == null)
      out[i] = new String[0][];
  }
  return out;
}

void maximizeScoreBoard(String[][][] board) {
  for (int i = 0; i < board.length; i++) {
    if (board[i].length > 5) {
      board[i] = Arrays.copyOf(board[i], 5);
    }
  }
}

void orderScoreBoard(String[][][] board) {
  for (String[][] list : board) {
    if (list == null || list.length == 0)
      continue;
    boolean swiched = false;
    do {
      swiched = false;
      for (int i = 0; i < list.length - 1; i++) {
        if (list[i][1].compareTo(list[i + 1][1]) > 0) {
          String[] keep = list[i];
          list[i] = list[i + 1];
          list[i + 1] = keep;
          swiched = true;
        }
      }
    } 
    while (swiched);
  }
}
void saveScoreBoard(String[][][] board, String file) {
  String[] out = new String[board.length];
  int i = 0;
  for (String[][] list : board) {
    if (list == null) {
      out[i] = "\n";
    } else {
      out[i] = "";
      for (String[] person : list) {
        if (person == null)
          continue;
        out[i] += person[0] + ";";
        out[i] += person[1] + ";";
      }
    }
    i++;
  }
  saveStrings(file, out);
}

void addSelectedCard(int[] button) {
  for (int i = 0; i < selectedCards.length; i++) {
    if (selectedCards[i] == 0) {
      selectedCards[i] = button[BUTTON_ID];

      Rectangle place = getSelectedCardLocation(i);
      button[BUTTON_X] = place.x;
      button[BUTTON_Y] = place.y;
      button[BUTTON_WIDTH] = place.width;
      button[BUTTON_HEIGHT] = place.height;

      return;
    }
  }
  throw new IllegalArgumentException("Could not do stuff");
}

