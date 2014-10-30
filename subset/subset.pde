import java.awt.Rectangle;
import java.io.File;
import java.util.Arrays;
import javax.swing.JOptionPane;

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
final int GAME_OVER = 3;

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

String scoresFile = "high.scores";
String gameFile = "saved.game";
String infoTxtFile = "info.txt";
String starFile = "star.png";

String infoTxt;

int backgroundColor = 0;
int selectedScreen = SCREEN_MENU;
int gameStatus = GAME_OFF;
boolean forceScreenUpdate = true;

int buttonAmount = 200;
int[][] buttonData = new int[buttonAmount][];
String[] buttonTxt = new String[buttonAmount];
String popupTxt;

int timerStartTime = 0;
int lastTime = 0;

StringList stack;
String highScore;
int foundSets, possibleSets;
int[] selectedCards = new int[3];
int[] hintSet;
String playerName;

int[] draggingCard;
int[] draggingCardOriginalPos;
int[] draggingMarge;

String[][][] scoreBoard;

PImage star;

//use this variable to test the thing.
boolean debug = false;

int screenWidth = 800, screenHeight = 600;

String gameOverTxt = "Game Over";
int textColor = 255;
int bgColor = 0;
                                                                                                                                                                                    String superSeceretString = "-1;-1;-65536;-65536;-65536;-65536;-65536;-65536;-1;-1;-1;-1;-1;-1;-1;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-1;-1;-1;-1;-1;-1;-1;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-718080;-65536;-65536;-16777216;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-16777216;-1;-1;-1;-1;-1;-1;-65536;-65536;-65536;-38400;-38400;-38400;-38400;-38400;-65536;-65536;-65536;-65536;-65536;-16777216;-5761;-5761;-30276;-30276;-30276;-30276;-5549569;-30276;-30276;-5549569;-30276;-30276;-30276;-5761;-5761;-5761;-16777216;-1;-1;-1;-1;-1;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-16777216;-5761;-30276;-30276;-5549569;-30276;-30276;-30276;-30276;-16777216;-16777216;-30276;-30276;-30276;-30276;-30276;-5761;-16777216;-1;-16777216;-16777216;-1;-1;-38400;-38400;-38400;-10240;-10240;-10240;-10240;-16777216;-16777216;-16777216;-16777216;-38400;-38400;-16777216;-5761;-30276;-30276;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-16777216;-30276;-30276;-5549569;-30276;-5761;-16777216;-16777216;-10395296;-10395296;-16777216;-1;-10240;-10240;-10240;-10240;-10240;-10240;-16777216;-10395296;-10395296;-10395296;-16777216;-16777216;-16777216;-16777216;-5761;-30276;-30276;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-16777216;-30276;-30276;-30276;-5761;-16777216;-10395296;-10395296;-10395296;-16777216;-1;-10240;-10240;-10240;-16711903;-16711903;-16711903;-16777216;-16777216;-10395296;-10395296;-10395296;-10395296;-10395296;-16777216;-5761;-30276;-30276;-30276;-5549569;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-10395296;-16777216;-16777216;-16777216;-16777216;-10395296;-10395296;-10395296;-10395296;-16777216;-1;-16711903;-16711903;-16711903;-16711903;-16711903;-16711903;-16711903;-16711903;-16777216;-16777216;-16777216;-16777216;-10395296;-16777216;-5761;-30276;-30276;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-16777216;-1;-16711903;-16711903;-16711903;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16777216;-16777216;-16777216;-5761;-30276;-30276;-30276;-30276;-5549569;-16777216;-10395296;-10395296;-10395296;-1;-16777216;-10395296;-10395296;-10395296;-10395296;-10395296;-1;-16777216;-10395296;-10395296;-16777216;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16777216;-5761;-30276;-5549569;-30276;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-16777216;-16777216;-10395296;-10395296;-10395296;-16777216;-10395296;-16777216;-16777216;-10395296;-10395296;-16777216;-16739073;-16739073;-16739073;-9160787;-9160787;-9160787;-9160787;-9160787;-16739073;-16739073;-16739073;-16739073;-16739073;-16777216;-5761;-30276;-30276;-30276;-5549569;-30276;-16777216;-10395296;-30276;-30276;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-30276;-30276;-16777216;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-16777216;-16777216;-5761;-5761;-30276;-5549569;-30276;-30276;-16777216;-10395296;-30276;-30276;-10395296;-16777216;-10395296;-10395296;-16777216;-10395296;-10395296;-16777216;-10395296;-30276;-30276;-16777216;-9160787;-9160787;-9160787;-1;-1;-1;-1;-1;-9160787;-9160787;-16777216;-16777216;-16777216;-16777216;-5761;-5761;-5761;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-10395296;-10395296;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-10395296;-10395296;-10395296;-16777216;-16777216;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-16777216;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-10395296;-10395296;-16777216;-1;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-16777216;-16777216;-1;-1;-1;-16777216;-10395296;-10395296;-16777216;-1;-1;-1;-16777216;-10395296;-10395296;-16777216;-1;-16777216;-10395296;-10395296;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-16777216;-16777216;-1;-1;-1;-1;-16777216;-16777216;-16777216;-1;-1;-16777216;-16777216;-16777216;-1;-1;-1;-1;-1;";                                                                                                                                      
public void setup() {
  scoresFile = dataPath(scoresFile);
  gameFile = dataPath(gameFile);
  star = loadImage(dataPath(starFile));
  infoTxtFile = dataPath(infoTxtFile);

  initScoreBoard();
  size(screenWidth, screenHeight);

  int redButtonColor = color(160, 0, 0);                              

  // menu buttons
  addButton("Start simple mode", 1, SCREEN_MENU, 40, 150, 350, 140, 255, 0);
  addButton("Start original mode", 2, SCREEN_MENU, 410, 150, 350, 140, 255, 0);
  addButton("About and Rules", 4, SCREEN_MENU, 120, 450, 250, 100, redButtonColor, textColor);
  addButton("ScoreBoard*", 3, SCREEN_MENU, 120, 340, 550, 100, redButtonColor, textColor);
  addButton("Load saved Game", 5, SCREEN_MENU, 420, 450, 250, 100, redButtonColor, textColor);
  // score board
  addButton("Back to Menu", 6, SCREEN_SCORES, 520, 470, 250, 100, redButtonColor, textColor);
  addButton("Clear Scores", 8, SCREEN_SCORES, 30, 470, 250, 100, redButtonColor, textColor);
  // about
  addButton("Back to Menu", 7, SCREEN_ABOUT, 520, 470, 250, 110, redButtonColor, textColor);
  // game
  addButton("Save & Quit", 9, SCREEN_GAME, 10, 220, 250, 40, redButtonColor, textColor);
  addButton("Order Cards", 10, SCREEN_GAME, 10, 270, 250, 40, redButtonColor, textColor);
  addButton("Hint", 11, SCREEN_GAME, 10, 320, 250, 40, redButtonColor, textColor);
  addButton("Give Up", 12, SCREEN_GAME, 10, 370, 250, 40, redButtonColor, textColor);
  addButton("", 13, SCREEN_GAME, 10, height - 50, 250, 40, redButtonColor, textColor);
  addButton("", 14, SCREEN_MENU, 10, 10, 10, 10, bgColor, 0);
}
