package sijmen.test;

import java.awt.Rectangle;
import java.io.File;

import processing.core.*;
import processing.data.*;

@SuppressWarnings("serial")
public class SubSet extends PApplet {
	
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
	
	int backgroundColor = 0;
	int selectedScreen = SCREEN_MENU;
	int gameStatus = GAME_OFF;
	boolean forceScreenUpdate = true;
	String[] cardStack = null;
	
	int buttonAmount = 200;
	int[][] buttonData = new int[buttonAmount][];
	String[] buttonTxt = new String[buttonAmount];
	
	StringList stack;
	float gameTime = -1;
	int timerStartTime;
	String highScore;
	int foundSets, cardsInStack, possibleSets, wrongSets;
	int[] selectedCards = new int[3];
	
	int[] draggingCard = null;
	int[] draggingCardOriginalPos = null;
	int[] draggingMarge = null;
	
	String[][][] scoreBoard;
	
	PImage star;
	
	/*********************
	 * MAIN
	 **********************/
	public void setup() {
		scoresFile = dataPath("high.scores");
		star = loadImage(dataPath("ster.png"));
		initScoreBoard();
		size(800, 600);
		// menu buttons
		addButton("Start simple mode", 1, SCREEN_MENU, 40, 150, 350, 140, 255, 0);
		addButton("Start original mode", 2, SCREEN_MENU, 410, 150, 350, 140, 255, 0);
		addButton("ScoreBoard*", 3, SCREEN_MENU, 120, 340, 550, 100, color(160, 0, 0), 255);
		addButton("About and Rules", 4, SCREEN_MENU, 120, 450, 250, 100, color(160, 0, 0), 255);
		addButton("Load saved Game", 5, SCREEN_MENU, 420, 450, 250, 100, color(160, 0, 0), 255);
		// score board
		addButton("Back to Menu", 6, SCREEN_SCORES, 520, 470, 250, 100, color(160, 0, 0), 255);
		addButton("Clear Scores", 8, SCREEN_SCORES, 30, 470, 250, 100, color(160, 0, 0), 255);
		// about
		addButton("Back to Menu", 7, SCREEN_ABOUT, 520, 470, 250, 100, color(160, 0, 0), 255);
		// game
		addButton("Save and Quit", 9, SCREEN_GAME, 10, 220, 250, 40, color(160, 0, 0), 255);
		addButton("Order Cards", 10, SCREEN_GAME, 10, 270, 250, 40, color(160, 0, 0), 255);
		addButton("Hint", 11, SCREEN_GAME, 10, 320, 250, 40, color(160, 0, 0), 255);
		addButton("Give Up", 12, SCREEN_GAME, 10, 370, 250, 40, color(160, 0, 0), 255);
		addButton("Select Cards!", 13, SCREEN_GAME, 10, height - 50, 250, 40, color(150, 150, 150),
				255);
	}
	
	public void draw() {
		updateGameTimer();
		if (forceScreenUpdate) {
			drawScreen();
			drawButtons();
			forceScreenUpdate = false;
		}
	}
	
	public void mousePressed() {
		int[] but = getButtonAtLocation(mouseX, mouseY, selectedScreen);
		if(but == null)
			return;
		if (but[BUTTON_ID] >= 100 && but[BUTTON_ID] < 200)
			cardPressAction(but);
		else
			doButtonAction(but[BUTTON_ID]);
	}

	public void mouseDragged() {
		if(selectedScreen == SCREEN_GAME)
			cardDragAction();
	}
	
	public void mouseReleased() {
		int[] but = getButtonAtLocation(mouseX, mouseY, selectedScreen);
		if(but == null)
			return;
		if (but[BUTTON_ID] >= 100 && but[BUTTON_ID] < 200)
			cardReleaseAction();
	}

	public void exit() {
		saveScoreBoard(scoreBoard, scoresFile);
		super.exit();
	}
	
	/*********************
	 * BUTTON STUFF
	 **********************/
	void addButton(String naam, int id, int menu, int x, int y, int wid, int hei, int bgCol,
			int fgCol) {
		int loc = getEmptyButtonLocation();
		buttonData[loc] = new int[] { id, menu, x, y, wid, hei, bgCol, fgCol };
		buttonTxt[loc] = naam;
	}
	
	int getEmptyButtonLocation() {
		for (int i = 0; i < buttonData.length; i++)
			if (buttonData[i] == null)
				return i;
		println("Not enough space in button data array!");
		return -1;
	}
	
	int[] getButton(int id) {
		for (int i = 0; i < buttonData.length; i++)
			if (buttonData[i] != null && buttonData[i][BUTTON_ID] == id)
				return buttonData[i];
		return null;
	}
	
	void doButtonAction(int buttonID) {
		switch (buttonID) {
			case 1:
				startGame(false);
				break;
			case 2:
				startGame(true);
				break;
			case 3:
				showScoreScreen();
				break;
			case 4:
				showAboutScreen();
				break;
			case 5:
				loadGame();
				break;
			case 6:
				backToMenu();
				break; // deze staat er twee keer in omdat er twee verschillende
			case 7:
				backToMenu();
				break; // knoppen zijn die deze actie uitvoeren.
			case 8:
				clearScores();
				break;
			case 9:
				saveAndQuit();
				break;
			case 10:
				orderCards();
				break;
			case 11:
				giveHint();
				break;
			case 12:
				giveUp();
				break;
			case 13:
				validInvalidSet();
				break;
		}
	}
	
	int[] getButtonAtLocation(int x, int y, int screen){
		for (int i = buttonData.length - 1; i >= 0; i--) {
			int[] but = buttonData[i];
			if (but == null)
				continue;
			if (but[BUTTON_SCREEN] != screen) {
				continue;
			}
			if (x > but[BUTTON_X] && x < (but[BUTTON_X] + but[BUTTON_WIDTH])
					&& y > but[BUTTON_Y] && y < (but[BUTTON_Y] + but[BUTTON_HEIGHT])) {
				return but;
			}
		}
		return null;
	}
	
	/*********************
	 * BUTTON ACTIONS
	 **********************/
	void showScoreScreen() {
		selectedScreen = SCREEN_SCORES;
		forceScreenUpdate = true;
	}
	
	void showAboutScreen() {
		selectedScreen = SCREEN_ABOUT;
		forceScreenUpdate = true;
		saveScoreBoard(scoreBoard, dataPath("high.scores"));
	}
	
	void backToMenu() {
		selectedScreen = SCREEN_MENU;
		forceScreenUpdate = true;
	}
	
	void cardClickedAction(int id) {
		println(id);
	}
	
	void loadGame() {}
	
	void clearScores() {
		scoreBoard = new String[2][0][0];
		forceScreenUpdate = true;
	}
	
	void saveAndQuit() {
		saveGame();
		backToMenu();
		stack = null;
		gameTime = 0;
		highScore = null;
		foundSets = 0;
		cardsInStack = 0;
		possibleSets = 0;
		wrongSets = 0;
		for (int i = 0; i < buttonData.length; i++)
			if (buttonData[i] != null)
				if (buttonData[i][BUTTON_ID] >= 100 && buttonData[i][BUTTON_ID] < 200) {
					buttonData[i] = null;
					buttonTxt[i] = null;
				}
	}
	
	void orderCards() {
		
		
	}
	
	void giveHint() {}
	
	void giveUp() {}
	
	void validInvalidSet() {}
	
	/*********************
	 * DRAWING
	 **********************/
	
	void drawButtons() {
		rectMode(CORNER);
		for (int i = 0; i < buttonData.length; i++) {
			int[] but = buttonData[i];
			String txt = buttonTxt[i];
			if (but == null || but[BUTTON_SCREEN] != selectedScreen)
				continue;
			if (but[BUTTON_ID] >= 100 && but[BUTTON_ID] < 200) {
				drawCard(i);
				continue;
			}
			boolean doStar = txt.contains("*");
			txt = txt.replace("*", "");
			fill(but[BUTTON_BGCOLOR]);
			noStroke();
			rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);
			
			textSize(27);
			
			fill(but[BUTTON_FGCOLOR]);
			textAlign(CENTER, CENTER);
			text(txt, but[BUTTON_X] + (but[BUTTON_WIDTH] / 2), but[BUTTON_Y]
					+ (but[BUTTON_HEIGHT] / 2.3f));
			if (doStar) {
				image(star, but[BUTTON_X] + 10, but[BUTTON_Y] + 12, but[BUTTON_HEIGHT] - 20,
						but[BUTTON_HEIGHT] - 20);
				image(star, but[BUTTON_X] + but[BUTTON_WIDTH] - but[BUTTON_HEIGHT] + 12,
						but[BUTTON_Y] + 10, but[BUTTON_HEIGHT] - 20, but[BUTTON_HEIGHT] - 20);
			}
		}
	}
	
	void drawCard(int dataLocation) {
		int[] but = buttonData[dataLocation];
		String card = buttonTxt[dataLocation];
		
		if (card.indexOf(C_BG_ORANGE) != -1)
			fill(BG_ORANGE);
		else if (card.indexOf(C_BG_GREEN) != -1)
			fill(BG_GREEN);
		else if (card.indexOf(C_BG_PURPLE) != -1)
			fill(BG_PURPLE);
		else
			fill(BG_NONE);
		rectMode(CORNER);
		rect(but[BUTTON_X], but[BUTTON_Y], but[BUTTON_WIDTH], but[BUTTON_HEIGHT]);
		
		if (card.indexOf(C_COL_RED) != -1)
			fill(COL_RED);
		else if (card.indexOf(C_COL_BLUE) != -1)
			fill(COL_BLUE);
		else if (card.indexOf(C_COL_YELLOW) != -1)
			fill(COL_YELLOW);
		else
			println("ERROR: IMPPSSOBLE!");
		noStroke();
		int amount = Integer.parseInt(card.replaceAll("\\D+", ""));
		for (int i = 0; i < amount; i++) {
			
			int centerX = but[BUTTON_X] + but[BUTTON_WIDTH] / 2;
			int centerY = but[BUTTON_Y] + but[BUTTON_HEIGHT] / 4 * (i + 1);
			int hei = but[BUTTON_HEIGHT] / 5;
			int wid = but[BUTTON_HEIGHT] / 3;
			
			if (card.indexOf(C_SHAPE_ELLIPSE) != -1) {
				ellipseMode(CENTER);
				ellipse(centerX, centerY, wid, hei);
			} else if (card.indexOf(C_SHAPE_QUAD) != -1) {
				rectMode(CENTER);
				rect(centerX, centerY, wid, hei);
			} else if (card.indexOf(C_SHAPE_TRINAGLE) != -1) {
				triangle(centerX, centerY - hei / 2, centerX - wid / 2, centerY + hei / 2, centerX
						+ wid / 2, centerY + hei / 2);
			} else
				println("ERROR: IMPPSSOBLE!");
		}
	}
	
	void drawScreen() {
		switch (selectedScreen) {
			case SCREEN_MENU:
				drawMenu();
				break;
			case SCREEN_GAME:
				drawGame();
				break;
			case SCREEN_SCORES:
				drawScores();
				break;
			case SCREEN_ABOUT:
				drawAbout();
				break;
		}
	}
	
	void drawMenu() {
		background(0);
		fill(255);
		textSize(70);
		textAlign(CENTER);
		text("Ultimate Subset", width / 2, 90);
		textSize(30);
		text("Door Sijmen Huizenga", width / 2, 125);
	}
	
	void drawGame() {
		background(0);
		stroke(150, 150, 150);
		noFill();
		rectMode(CORNER);
		rect(270, 5, 520, 590);
		for (int i = 0; i < 3; i++) {
			Rectangle place = getSelectedCardLocation(i);
			rect(place.x, place.y, place.width - 1, place.height - 1);
		}
		String stats = "";
		stats += "Current Time: " + timeFloatToString(gameTime) + "\n";
		stats += "Found Sets: " + foundSets + "\n";
		stats += "Cards in Stacdk: " + cardsInStack + "\n";
		stats += "High Score: " + highScore + "\n";
		stats += "Possible Sets: " + possibleSets + "\n";
		stats += "Wrong Sets: " + wrongSets + "\n";
		textSize(20);
		textAlign(LEFT, TOP);
		fill(255);
		text(stats, 10, 10);
	}
	
	void drawScores() {
		background(0);
		String[][] simpleScores = scoreBoard[0];
		String[][] originalScores = scoreBoard[1];
		// background
		textSize(50);
		fill(255);
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
	
	/*********************
	 * GAME
	 **********************/
	
	void drawAbout() {
		background(0);
	}
	
	void startGame(boolean original) {
		gameStatus = (original ? GAME_ORIGINAL : GAME_SIMPLE);
		selectedScreen = SCREEN_GAME;
		forceScreenUpdate = true;
		
		stack = getCardSet(!original);
		shuffleStack(stack);
		
		timerStartTime = getUnixTime();
		gameTime = 0;
		
		if (scoreBoard[original ? 1 : 0].length > 0) {
			highScore = scoreBoard[original ? 1 : 0][0][1];
		} else {
			highScore = "-";
		}
		int idCounter = 100;
		for (int i = 1; i <= (original ? 4 : 3); i++) {
			for (int j = 1; j <= 3; j++) {
				addCardToScreen(idCounter, i - 1, j - 1);
				idCounter++;
			}
		}
		for (int i = 0; i < selectedCards.length; i++) {
			selectedCards[i] = -1;
		}
	}
	
	Rectangle getDefaultCardLocation(int x, int y) {
		return new Rectangle(x * 80 + 370, y * 170 + 55, 77, 150);
	}
	
	Rectangle getSelectedCardLocation(int nr) {
		return new Rectangle(10 + nr * 89, 420, 71, 120);
	}
	
	int addSelectedCard(int cardID) {
		for (int i = 0; i < selectedCards.length; i++) {
			if (selectedCards[i] == -1) {
				selectedCards[i] = cardID;
				return i;
			}
		}
		return -1;
	}
	
	void removeSelectedCard(int cardID) {
		for (int i = 0; i < selectedCards.length; i++) {
			if (selectedCards[i] == cardID) {
				selectedCards[i] = -1;
			}
		}
	}
	
	/*********************
	 * CARDS
	 **********************/
	
	void addCardToScreen(int cardID, int x, int y) {
		String card = stack.get(stack.size() - 1);
		stack.remove(stack.size() - 1);
		Rectangle rect = getDefaultCardLocation(x, y);
		addButton(card, cardID, SCREEN_GAME, rect.x, rect.y, rect.width, rect.height, 255, 0);
	}
	
	StringList getCardSet(boolean simple) {
		StringList out = new StringList();
		for (int i = 1; i <= 3; i++) {
			for (int j = 1; j <= 3; j++) {
				for (int k = 1; k <= 3; k++) {
					if (simple) {
						out.append(makeCard(i, j, k, 4));
					} else {
						for (int l = 1; l <= 3; l++) {
							out.append(makeCard(i, j, k, l));
						}
					}
				}
			}
		}
		return out;
	}
	
	String makeCard(int col, int shape, int amount, int background) {
		String out = "";
		switch (col) {
			case 1:
				out += C_COL_RED;
				break;
			case 2:
				out += C_COL_BLUE;
				break;
			case 3:
				out += C_COL_YELLOW;
				break;
		}
		switch (shape) {
			case 1:
				out += C_SHAPE_ELLIPSE;
				break;
			case 2:
				out += C_SHAPE_QUAD;
				break;
			case 3:
				out += C_SHAPE_TRINAGLE;
				break;
		}
		switch (background) {
			case 1:
				out += C_BG_ORANGE;
				break;
			case 2:
				out += C_BG_GREEN;
				break;
			case 3:
				out += C_BG_PURPLE;
				break;
			case 4:
				out += C_BG_NONE;
				break;
		}
		return out += amount;
	}
	
	void saveGame() {
		
	}
	
	void shuffleStack(StringList in) {
		for (int i = 0; i < in.size() - 1; i++) {
			int toSwich = floor(random(in.size()));
			if (i == toSwich)
				continue;
			String tmp = in.get(i);
			in.set(i, in.get(toSwich));
			in.set(toSwich, tmp);
		}
	}
	
	void cardPressAction(int[] but) {
		if(draggingCard == null){
			draggingCard = but;
			draggingCardOriginalPos = new int[]{but[BUTTON_X], but[BUTTON_Y]};
			draggingMarge = new int[]{mouseX-but[BUTTON_X], mouseY-but[BUTTON_Y]};
		}
	}
	
	void cardReleaseAction(){
		
		int[] but = draggingCard;
		if(but == null)
			return;

		//how far has the card beend dragged.
		int dx = abs(but[BUTTON_X] - draggingCardOriginalPos[0]);
		int dy = abs(but[BUTTON_Y] - draggingCardOriginalPos[1]);
		//was a drag action, do nothing.
		if(sqrt(dx*dx+dy*dy) > 10){
			draggingCard = null;
			draggingCardOriginalPos = null;
			draggingMarge = null;
			return;
		}
		
		//already selected?
		if (but[BUTTON_Y] == getSelectedCardLocation(0).y) {
			removeSelectedCard(but[BUTTON_ID]);
			Rectangle place = getDefaultCardLocation(0, 0);
			but[BUTTON_X] = place.x;
			but[BUTTON_Y] = place.y;
			but[BUTTON_WIDTH] = place.width;
			but[BUTTON_HEIGHT] = place.height;
			forceScreenUpdate = true;
			
			draggingCard = null;
			draggingCardOriginalPos = null;
			draggingMarge = null;
			return;
		}
		int loc = addSelectedCard(but[BUTTON_ID]);
		//and there is place in the selection bar?
		if (loc != -1) {
			//select it!
			Rectangle place = getSelectedCardLocation(loc);
			but[BUTTON_X] = place.x;
			but[BUTTON_Y] = place.y;
			but[BUTTON_WIDTH] = place.width;
			but[BUTTON_HEIGHT] = place.height;
			forceScreenUpdate = true;
		}
		draggingCard = null;
		draggingCardOriginalPos = null;
		draggingMarge = null;
	}
	
	void cardDragAction() {
		if(draggingCard == null || draggingCardOriginalPos[1] == getSelectedCardLocation(0).y)
			return;
		draggingCard[BUTTON_X] = mouseX-draggingMarge[0];
		draggingCard[BUTTON_Y] = mouseY-draggingMarge[1];
		forceScreenUpdate = true;
	}
	
	/*********************
	 * TIMER
	 **********************/
	
	void updateGameTimer() {
		if (gameTime == -1)
			return;
		int time = (getUnixTime() - timerStartTime);
		int minutes = (int) time / 60;
		int secs = time - (minutes * 60);
		float newGameTime = round(minutes + (secs / 100f), 2);
		if (newGameTime != gameTime) {
			gameTime = newGameTime;
			forceScreenUpdate = true;
		}
	}
	
	/*********************
	 * SCORE BOARD
	 **********************/
	void initScoreBoard() {
		if (!new File(scoresFile).exists()) {
			scoreBoard = new String[2][0][0];
			return;
		}
		scoreBoard = loadScoreBoard(scoresFile);
		orderScoreBoard(scoreBoard);
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
					out[list][person] = new String[] { name, val };
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
	
	void orderScoreBoard(String[][][] board) {
		for (String[][] list : board) {
			if (list == null || list.length == 0)
				continue;
			boolean swiched = false;
			do {
				swiched = false;
				for (int i = 0; i < list.length - 1; i++) {
					if (Float.parseFloat(list[i][1].replace(":", ".")) > (Float
							.parseFloat(list[i + 1][1].replace(":", ".")))) {
						String[] keep = list[i];
						list[i] = list[i + 1];
						list[i + 1] = keep;
						swiched = true;
					}
				}
			} while (swiched);
		}
	}
	
	int getUnixTime() {
		return (int) (System.currentTimeMillis() / 1000);
	}
	
	float round(float nr, int decimals) {
		return floor(nr * (pow(10, decimals + 1))) / ((float) (pow(10, decimals + 1)));
	}
	
	String timeFloatToString(float nr) {
		return (nr + ((getNumbersAfterDot(nr) % 10 == 0) ? "0" : "")).replace(".", ":");
	}
	
	int getNumbersAfterDot(float nr) {
		return (int) ((nr) * 100) % 100;
	}
}
