final int SCREEN_MENU = 0;
final int SCREEN_GAME = 1;
final int SCREEN_SCORES = 2;
final int SCREEN_ABOUT = 3;

final int BUTTON_ID = 0;
final int BUTTON_SCREEN = 1;
final int BUTTON_X = 2;
final int BUTTON_Y = 3;
final int BUTTON_WIDTH = 4;
final int BUTTON_HEIGHT = 5;
final int BUTTON_BGCOLOR = 6;
final int BUTTON_FGCOLOR = 7;

final int COL_RED = color(228, 33, 31);
final int COL_BLUE = color(53, 76, 152);
final int COL_YELLOW = color(245, 230, 5);

final int BG_ORANGE = color(244, 150, 16);
final int BG_GREEN = color(79, 169, 45);
final int BG_PURPLE = color(107, 55, 138);
final int BG_NONE = color(200, 200, 200);

final int GAME_OFF = 0;
final int GAME_SIMPLE = 1;
final int GAME_ORIGINAL = 2;

final char C_COL_RED = 'R';
final char C_COL_BLUE = 'B';
final char C_COL_YELLOW = 'C';
final char C_SHAPE_ELLIPSE = 'E';
final char C_SHAPE_QUAD = 'Q';
final char C_SHAPE_TRINAGLE = 'T';
final char C_AMOUNT_1 = '1';
final char C_AMOUNT_2 = '2';
final char C_AMOUNT_3 = '3';
final char C_BG_ORANGE = 'O';
final char C_BG_GREEN = 'G';
final char C_BG_PURPLE = 'P';
final char C_BG_NONE = 'N';

String scoresFile;
int selectedScreen = SCREEN_MENU;
int gameStatus = GAME_OFF;
boolean forceScreenUpdate = true;
String[] cardStack = null;

int buttonAmount = 200;
int[][] buttonData = new int[buttonAmount][];
String[] buttonTxt = new String[buttonAmount];

StringList stack, onTable;
float gameTime = -1;
int timerStartTime;
String highScore;
int foundSets, cardsInStack, possibleSets, wrongSets;

String[][][] scoreBoard;

PImage star;

void setup() {
  scoresFile = dataPath("high.scores");
  star = loadImage(dataPath("ster.png"));
  initScoreBoard();
  size(800, 600);
  //menu buttons
  addButton("Start simple mode", 1, SCREEN_MENU, 40, 150, 350, 140, 255, 0);
  addButton("Start original mode", 2, SCREEN_MENU, 410, 150, 350, 140, 255, 0);
  addButton("ScoreBoard*", 3, SCREEN_MENU, 120, 340, 550, 100, color(160, 0, 0), 255);
  addButton("About and Rules", 4, SCREEN_MENU, 120, 450, 250, 100, color(160, 0, 0), 255);
  addButton("Load saved Game", 5, SCREEN_MENU, 420, 450, 250, 100, color(160, 0, 0), 255);
  //score board
  addButton("Back to Menu", 6, SCREEN_SCORES, 520, 470, 250, 100, color(160, 0, 0), 255);
  addButton("Clear Scores", 8, SCREEN_SCORES, 30, 470, 250, 100, color(160, 0, 0), 255);
  //about
  addButton("Back to Menu", 7, SCREEN_ABOUT, 520, 470, 250, 100, color(160, 0, 0), 255);
  //game
  addButton("Save and Quit", 9, SCREEN_GAME, 10, 220, 250, 40, color(160, 0, 0), 255);
  addButton("Order Cards", 10, SCREEN_GAME, 10, 270, 250, 40, color(160, 0, 0), 255);
  addButton("Hint", 11, SCREEN_GAME, 10, 320, 250, 40, color(160, 0, 0), 255);
  addButton("Give Up", 12, SCREEN_GAME, 10, 370, 250, 40, color(160, 0, 0), 255);
  addButton("Select Cards!", 13, SCREEN_GAME, 10, height-50, 250, 40, color(150, 150, 150), 255);
}

void draw() {
  updateGameTimer();
  if (forceScreenUpdate) {
    drawScreen();
    drawButtons();
    forceScreenUpdate = false;
  }
}

void mousePressed() {
  buttonPressCheck();
}

void exit(){
  saveScoreBoard(scoreBoard, scoresFile);
  super.exit();
}









