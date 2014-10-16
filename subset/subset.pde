
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


int backgroundColor = 0;
int selectedScreen = SCREEN_MENU;
boolean forceScreenUpdate = true;
String[] cardStack = null;

int buttonAmount = 5;
int[][] buttonData = new int[buttonAmount][];
String[] buttonTxt = new String[buttonAmount];

PImage star;

void setup() {
  star = loadImage("ster.png");

  size(800, 600);
  buttonData[0] = new int[] {
    1, SCREEN_MENU, 40, 150, 350, 140, 255, 0
  };
  buttonTxt[0] = "Start simple mode";

  buttonData[1] = new int[] {
    2, SCREEN_MENU, 410, 150, 350, 140, 255, 0
  };
  buttonTxt[1] = "Start original mode";

  buttonData[2] = new int[] {
    3, SCREEN_MENU, 120, 340, 550, 100, color(160, 0, 0), 255
  };
  buttonTxt[2] = "ScoreBoard*";

  buttonData[3] = new int[] {
    4, SCREEN_MENU, 120, 450, 250, 100, color(160, 0, 0), 255
  };
  buttonTxt[3] = "About and Rules";

  buttonData[4] = new int[] {
    4, SCREEN_MENU, 420, 450, 250, 100, color(160, 0, 0), 255
  };
  buttonTxt[4] = "Load saved Game";
}

void draw() {
  if (forceScreenUpdate) {
    drawScreen();
    drawButtons();
    forceScreenUpdate = false;
  }
}

void mouseClicked() {
  for (int[] but : buttonData) {  
    if (but[BUTTON_SCREEN] != selectedScreen) {
      continue;
    }
    if (mouseX > but[BUTTON_X] && mouseX < (but[BUTTON_X]+but[BUTTON_WIDTH])
      && mouseY > but[BUTTON_Y] && mouseY < (but[BUTTON_Y] + but[BUTTON_HEIGHT])) {
      doButtonAction(but[BUTTON_ID]);
    }
  }

}









