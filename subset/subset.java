
import java.awt.Rectangle;
import java.io.File;
import java.util.Arrays;

import javax.swing.JOptionPane;

import processing.core.*;
import processing.data.*;

@SuppressWarnings("serial")
public class subset extends PApplet {
	
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
	
	String scoresFile, gameFile, infoTxtFile;
	
	String infoTxt = null;
	
	int backgroundColor = 0;
	int selectedScreen = SCREEN_MENU;
	int gameStatus = GAME_OFF;
	boolean forceScreenUpdate = true;
	
	int buttonAmount = 200;
	int[][] buttonData = new int[buttonAmount][];
	String[] buttonTxt = new String[buttonAmount];
	String popupTxt = null;

	int timerStartTime = 0;
	int lastTime = 0;
	
	StringList stack;
	String highScore;
	int foundSets, possibleSets;
	int[] selectedCards = new int[3];
	int[] hintSet = null;
	String playerName = null;
	
	int[] draggingCard = null;
	int[] draggingCardOriginalPos = null;
	int[] draggingMarge = null;
	
	String[][][] scoreBoard;
	
	PImage star;
	
	@Override
	public void keyPressed() {
		if(key == 'h')
			giveHint();
		if(key == 'g')
			handInSet();
	}
	
	/*********************
	 * MAIN
	 **********************/
	public void setup() {
		scoresFile = dataPath("high.scores");
		gameFile = dataPath("saved.game");
		star = loadImage(dataPath("ster.png"));
		infoTxtFile = dataPath("info.txt");
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
		addButton("Back to Menu", 7, SCREEN_ABOUT, 520, 470, 250, 110, color(160, 0, 0), 255);
		// game
		addButton("Save & Quit", 9, SCREEN_GAME, 10, 220, 250, 40, color(160, 0, 0), 255);
		addButton("Order Cards", 10, SCREEN_GAME, 10, 270, 250, 40, color(160, 0, 0), 255);
		addButton("Hint", 11, SCREEN_GAME, 10, 320, 250, 40, color(160, 0, 0), 255);
		addButton("Give Up", 12, SCREEN_GAME, 10, 370, 250, 40, color(160, 0, 0), 255);
		addButton("", 13, SCREEN_GAME, 10, height - 50, 250, 40, color(150, 150, 150),255);
		addButton("", 14, SCREEN_MENU, 10, 10, 10, 10, color(0, 0, 0, 0), 0);
	}
	
	public void draw() {
		if (forceScreenUpdate || lastTime != getTimeSeconds()) {
			drawScreen();
			drawButtons();
			lastTime = getTimeSeconds();
			if(popupTxt != null){
				drawPopupScreen();
			}
			forceScreenUpdate = false;
		}
	}
	
	public void mousePressed() {
		if(popupTxt != null){
			if(popupTxt.startsWith("Game Over"))
				quit();
			popupTxt = null;
			forceScreenUpdate = true;
			return;
		}
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
		if(selectedScreen == SCREEN_GAME)
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
	
	int getButtonLocation(int id) {
		for (int i = 0; i < buttonData.length; i++)
			if (buttonData[i] != null && buttonData[i][BUTTON_ID] == id)
				return i;
		return -1;
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
				loadGame(gameFile);
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
				saveGame(gameFile);
				quit();
				break;
			case 10:
				orderCards();
				break;
			case 11:
				giveHint();
				break;
			case 12:
				quit();
				break;
			case 13:
				handInSet();
				break;
			case 14:
				doSuperSecretStuff();
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
		if(infoTxt == null){
			infoTxt = loadFileAsString(infoTxtFile);
		}
	}
	
	void backToMenu() {
		selectedScreen = SCREEN_MENU;
		forceScreenUpdate = true;
	}
	
	void loadGame(String fileName) {
		if(!new File(fileName).exists()){
			JOptionPane.showMessageDialog(this, "No saved file.", "Error", JOptionPane.ERROR_MESSAGE);
			return;
		}
		selectedScreen = SCREEN_GAME;
		stack = new StringList();
		
		String[] in = loadStrings(fileName);
		for(String line : in){
			if(line.startsWith("gameType:")){
				line = line.substring(9);
				gameStatus = (line.equals("0") ? GAME_SIMPLE : GAME_ORIGINAL);
			}else if(line.startsWith("time:")){
				line = line.substring(5);
				timerStartTime = getUnixTime()-Integer.parseInt(line);
			}else if(line.startsWith("name:")){
				line = line.substring(5);
				playerName = line;
			}else if(line.startsWith("cardsOnScreen:")){
				line = line.substring(14);
				String[] cards = line.split(";");
				for(String card : cards){
					stack.append(card);
					addCardToScreen();
				}
			}else if(line.startsWith("cardsInStack:")){
				line = line.substring(13);
				String[] cards = line.split(";");
				for(String card : cards){
					stack.append(card);
				}
			}
		}
		
		if (scoreBoard[gameStatus == GAME_ORIGINAL ? 1 : 0].length > 0) {
			highScore = scoreBoard[gameStatus == GAME_ORIGINAL ? 1 : 0][0][1];
		} else {
			highScore = "-";
		}
		
		possibleSets = getPossibleSets();
		
		forceScreenUpdate = true;
	}
	
	void saveGame(String fileName){
		if(gameStatus == GAME_OVER)
			return;
		String[] out = new String[6];
		out[0] = "time:" + (getUnixTime()-timerStartTime);
		out[1] = "gameType:" + (gameStatus == GAME_ORIGINAL ? 1 : 0);
		out[2] = "name:" + playerName;
		out[3] = "cardsOnScreen:";
		int idCounter = 100;
		int butLoc;
		while((butLoc = getButtonLocation(idCounter)) != -1){
			out[3] += buttonTxt[butLoc] + ";";
			idCounter++;
		}
		out[4] = "cardsInStack:";
		for(String card : stack){
			out[4] += card + ";";
		}
		saveStrings(fileName, out);
		JOptionPane.showMessageDialog(this, "Game is saved.", "Done", JOptionPane.INFORMATION_MESSAGE);
	}
	
	void clearScores() {
		scoreBoard = new String[2][0][0];
		forceScreenUpdate = true;
	}
	
	void quit() {
		backToMenu();
		stack = null;
		timerStartTime = 0;
		highScore = null;
		foundSets = 0;
		possibleSets = 0;
		for (int i = 0; i < buttonData.length; i++)
			if (buttonData[i] != null)
				if (buttonData[i][BUTTON_ID] >= 100 && buttonData[i][BUTTON_ID] < 200) {
					buttonData[i] = null;
					buttonTxt[i] = null;
				}
		selectedCards = new int[3];
	}
	
	void orderCards() {
		removeAllSelectedCards();
		int idCounter = 100;
		int butLoc;
		while((butLoc = getButtonLocation(idCounter)) != -1){
			
			int[] button = buttonData[butLoc];
			
			Rectangle rect = getDefaultCardLocation((idCounter-100)/3, (idCounter-100)%3);
			
			button[BUTTON_X] = rect.x;
			button[BUTTON_Y] = rect.y;
			button[BUTTON_WIDTH] = rect.width;
			button[BUTTON_HEIGHT] = rect.height;
			idCounter++;
		}
		forceScreenUpdate = true;
	}
	
	void giveHint() {
		timerStartTime -= 40;
		removeAllSelectedCards();
		if(hintSet == null)
			return;
		for(int buttonLoc : hintSet){
			addSelectedCard(buttonData[buttonLoc]);
		}
		forceScreenUpdate = true;
	}
	
	void giveUp() {}
	
	void handInSet() {
		if(isSelectedSpotFree())
			return; //still a spot left in the selected cards space.
		if(!isSetSelected())
			return; //it is not a set.
		for(int id : selectedCards){
			int loc = getButtonLocation(id);
			buttonData[loc] = null;
			buttonTxt[loc] = null;
			addCardToScreen();
		}
		foundSets++;
		selectedCards = new int[3];
		forceScreenUpdate = true;
		possibleSets = getPossibleSets();
	}
	
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
		stroke(0);
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
	
	void drawPopupScreen(){
		fill(color(43, 53, 255, 160));
		rectMode(CORNER);
		rect(0, 0, width-1, height-1);
		
		textAlign(CENTER, CENTER);
		textSize(50);
		fill(255);
		text(popupTxt, width/2, height/2);
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
		updateGameInfo();
		
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
		stats += "Current Time: \t" + getTimerString() + "\n";
		stats += "Found Sets: " + foundSets + "\n";
		stats += "Cards in Stacdk: " + stack.size() + "\n";
		stats += "High Score: " + highScore + "\n";
		stats += "Possible Sets: " + possibleSets + "\n";
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
	
	void drawAbout() {
		background(0);
		fill(255);
		textAlign(LEFT, TOP);
		textSize(15);
		text(infoTxt, 5, 5, 790, 300);
	}
	
	/*********************
	 * GAME
	 **********************/
	
	void startGame(boolean original) {
		playerName = JOptionPane.showInputDialog(this, "What  is your name?", "Before we start...", JOptionPane.QUESTION_MESSAGE);
		if(playerName == null || playerName.equals("") || playerName.length() > 8 || playerName.contains(";") || playerName.contains(":")){
			playerName = null;
			return;
		}
		gameStatus = (original ? GAME_ORIGINAL : GAME_SIMPLE);
		selectedScreen = SCREEN_GAME;
		forceScreenUpdate = true;
		
		stack = getCardSet(!original);
		shuffleStack(stack);
		
		timerStartTime = getUnixTime();
		
		if (scoreBoard[original ? 1 : 0].length > 0) {
			highScore = scoreBoard[original ? 1 : 0][0][1];
		} else {
			highScore = "-";
		}
		for (int i = 0; i < (original ? 4 : 3); i++) {
			for (int j = 0; j < 3; j++) {
				addCardToScreen();
			}
		}
		possibleSets = getPossibleSets();
	}
	
	void updateGameInfo(){
		int loc = getButtonLocation(13);
		
		if(!isSelectedSpotFree()){
			if(isSetSelected()){
				buttonData[loc][BUTTON_BGCOLOR] =  color(0, 255, 0);
				buttonTxt[loc] = "Set! Hand in.";
			}else{
				buttonData[loc][BUTTON_BGCOLOR] =  color(160, 0, 0);
				buttonTxt[loc] = "No set.";
			}
		}else{
			buttonData[loc][BUTTON_BGCOLOR] =  color(150, 150, 150);
			buttonTxt[loc] = "";
		}
		
		//no set possible: GAME OVER!
		if(possibleSets == 0 && gameStatus != GAME_OVER){
			addScoreEntry(gameStatus == GAME_ORIGINAL ? 1 : 0, playerName, getTimerString());
			orderScoreBoard(scoreBoard);
			maximizeScoreBoard(scoreBoard);
			saveScoreBoard(scoreBoard, scoresFile);
			
			popupTxt = "Game Over! \nScore: " + getTimerString();
			
			forceScreenUpdate = true;
			gameStatus = GAME_OVER;
		}
	}
	
	Rectangle getDefaultCardLocation(int x, int y) {
		return new Rectangle(x * 80 + 290, y * 170 + 55, 77, 150);
	}
	
	Rectangle getSelectedCardLocation(int nr) {
		return new Rectangle(10 + nr * 89, 420, 71, 120);
	}
	
	/*********************
	 * SELECTION
	 **********************/
	
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
	
	void removeSelectedCard(int[] button) {
		for (int i = 0; i < selectedCards.length; i++) {
			if (selectedCards[i] == button[BUTTON_ID]) {
				selectedCards[i] = 0;
				
				Rectangle place = getDefaultCardLocation((button[BUTTON_ID]-100)/3, (button[BUTTON_ID]-100)%3);
				button[BUTTON_X] = place.x;
				button[BUTTON_Y] = place.y;
				button[BUTTON_WIDTH] = place.width;
				button[BUTTON_HEIGHT] = place.height;
			}
		}
	}
	
	void removeAllSelectedCards(){
		for(int buttonID : selectedCards){
			if(buttonID == 0)
				continue;
			int[] button = buttonData[getButtonLocation(buttonID)];
			Rectangle rect = getDefaultCardLocation((buttonID-100)/3, (buttonID-100)%3);
			
			button[BUTTON_X] = rect.x;
			button[BUTTON_Y] = rect.y;
			button[BUTTON_WIDTH] = rect.width;
			button[BUTTON_HEIGHT] = rect.height;
		}
		selectedCards = new int[3];
		forceScreenUpdate = true;
	}
	
	boolean isSelectedSpotFree(){
		for (int i = 0; i < selectedCards.length; i++) {
			if (selectedCards[i] == 0) {
				return true;
			}
		}
		return false;
	}
	
	boolean isSet(String[] cards){
		for(int i = 0; i < cards[0].length(); i++){
			String curCheck = "";
			for(int j = 0; j < cards.length; j++){
				curCheck += cards[j].charAt(i);
			}
			boolean good = isSameOrDiff(curCheck);
			if(!good)
				return false;
		}
		return true;
	}
	
	//wtf is this? look at this: http://rick.measham.id.au/paste/explain.pl?regex=%5E%28%3F%3A%28.%29%28%3F%21.*%3F%5C1%29%29*%24
	boolean isSameOrDiff(String toCheck) {
		return toCheck.matches(toCheck.charAt(0)+"+") || toCheck.matches("^(?:(.)(?!.*?\\1))*$");
	}

	/*********************
	 * CARDS
	 **********************/
	
	void addCardToScreen() {
		if(stack.size() == 0)
			return;
		String card = stack.get(stack.size() - 1);
		stack.remove(stack.size() - 1);
		int cardID = getEmptyCardID();
		Rectangle rect = getDefaultCardLocation((cardID-100)/3, (cardID-100)%3);
		addButton(card, cardID, SCREEN_GAME, rect.x, rect.y, rect.width, rect.height, 255, 0);
	}
	
	int getEmptyCardID(){
		for(int i = 0; i <= 20; i++){   //Can never be more cards than 21. MATH!
			if(getButtonLocation(i+100) == -1)
				return i+100;
		}
		return -1;
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
		if(gameStatus == GAME_OVER)
			return;
		if(draggingCard == null){
			draggingCard = but;
			draggingCardOriginalPos = new int[]{but[BUTTON_X], but[BUTTON_Y]};
			draggingMarge = new int[]{mouseX-but[BUTTON_X], mouseY-but[BUTTON_Y]};
		}
	}
	
	void cardReleaseAction(){
		if(gameStatus == GAME_OVER)
			return;
		int[] but = draggingCard;
		if(but == null)
			return;

		//how far has the card beend dragged.
		int dx = abs(but[BUTTON_X] - draggingCardOriginalPos[0]);
		int dy = abs(but[BUTTON_Y] - draggingCardOriginalPos[1]);
		//was a small drag, handle as click
		if(sqrt(dx*dx+dy*dy) < 10){
			//already selected?
			if (but[BUTTON_Y] == getSelectedCardLocation(0).y) {
				removeSelectedCard(but);
			}else{//not selected
				if(isSelectedSpotFree())//but still a spot free?
					addSelectedCard(but);  //lets add that bich.
			}	
			forceScreenUpdate = true;
		}
		
		draggingCard = null;
		draggingCardOriginalPos = null;
		draggingMarge = null;
	}
	
	void cardDragAction() {
		if(gameStatus == GAME_OVER)
			return;
		if(draggingCard == null || draggingCardOriginalPos[1] == getSelectedCardLocation(0).y)
			return;
		draggingCard[BUTTON_X] = constrain(mouseX-draggingMarge[0], 270, 790-draggingCard[BUTTON_WIDTH]);
		draggingCard[BUTTON_Y] = constrain(mouseY-draggingMarge[1], 5, 595-draggingCard[BUTTON_HEIGHT]);
		forceScreenUpdate = true;
	}
	
	boolean isSetSelected(){
		if(isSelectedSpotFree())
			return false;
		String[] cards = new String[selectedCards.length];
		for(int i = 0; i < cards.length; i++){
			cards[i] = buttonTxt[getButtonLocation(selectedCards[i])];
		}
		return isSet(cards);
	}
	
	/**
	 * Het idee van "het volgende loopje starten op de plek waar de vorigge loop is gestopt" komt van Bram.
	 * Gewoon een super geniaal idee.
	 */
	int getPossibleSets(){
		hintSet = null;
		int out = 0;
		int max = gameStatus == GAME_SIMPLE? 9 : 12;
		for(int a = 0; a < max; a++){
			int locA = getButtonLocation(a+100);
			if(locA == -1)
				continue;
			for(int b = a+1; b < max; b++){
				int locB = getButtonLocation(b+100);
				if(locB == -1)
					continue;
				for(int c = b+1; c < max; c++){
					int locC = getButtonLocation(c+100);
					if(locC == -1 || locC == locB || locC == locA)
						continue;
					if(isSet(new String[]{buttonTxt[locA], buttonTxt[locB], buttonTxt[locC]})){
						out++;
						if(out == 1){
							hintSet = new int[]{locA, locB, locC};
						}
					}
				}
			}
		}
		return out;
	}
	
	int getCardsOnField(){
		return (gameStatus==GAME_SIMPLE ? 27 : 81 )-(stack.size() + (3*foundSets));
	}
	
	/*********************
	 * TIMER
	 **********************/
	
	int getTimeSeconds(){
		if(gameStatus == GAME_OVER)
			return lastTime;
		return timerStartTime == 0 ? 0 : getUnixTime()-timerStartTime;
	}
	
	String getTimerString(){
		int time = getTimeSeconds();
		return toTwoDigets(time/60) + ":" + toTwoDigets(time%60);
	}
	
	String toTwoDigets(int i){
		return (i<10 ? "0" : "") +i;
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
					if (list[i][1].compareTo(list[i+1][1]) > 0) {
						String[] keep = list[i];
						list[i] = list[i + 1];
						list[i + 1] = keep;
						swiched = true;
					}
				}
			} while (swiched);
		}
	}
	
	void addScoreEntry(int board, String name, String score) {
		String[][] newList = new String[scoreBoard[board].length+1][];
		int i;
		for(i = 0; i < scoreBoard[board].length; i++){
			newList[i] = scoreBoard[board][i];
		}
		newList[i] = new String[]{name, score};
		scoreBoard[board] = newList;
	}
	
	void maximizeScoreBoard(String[][][] board){
		for(int i = 0; i < board.length; i++){
			if(board[i].length > 5){
				board[i] = Arrays.copyOf(board[i], 5);
			}
		}
	}
	
	/*********************
	 * UITL
	 **********************/
	
	String loadFileAsString(String fileName){
		String[] in = loadStrings(fileName);
		String out = "";
		for(String line : in){
			out += line + "\n";
		}
		return out;
	}
	
	int getUnixTime() {
		return (int) (System.currentTimeMillis() / 1000);
	}
	
	float round(float nr, int decimals) {
		return floor(nr * (pow(10, decimals))) / ((float) (pow(10, decimals)));
	}
	
	void doSuperSecretStuff() {
		noStroke();
		String[] x = superSeceretString.split(";");
		int[] y = new int[x.length];
		for (int z = 0; z < x.length; z++) {
			y[z] = Integer.parseInt(x[z]);
		}
		for (int a = 0; a < 36; a++) {
			for (int b = 0; b < 17; b++) {
				int z = a + b * 36;
				if (y[z] == -1)
					continue;
				fill(y[z]);
				rect(60+a * 20, 100+b * 20, 20, 20);
			}
		}
	}
	
	String superSeceretString = "-1;-1;-65536;-65536;-65536;-65536;-65536;-65536;-1;-1;-1;-1;-1;-1;-1;"
			+ "-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;"
			+ "-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;"
			+ "-1;-1;-1;-1;-1;-1;-1;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;-65536;"
			+ "-65536;-65536;-718080;-65536;-65536;-16777216;-5761;"
			+ "-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-5761;"
			+ "-16777216;-1;-1;-1;-1;-1;-1;-65536;-65536;-65536;-38400;-38400;-38400;-38400;-3"
			+ "8400;-65536;-65536;-65536;-65536;-65536;-16777216;-5761;-5761;-30276;-30276;-302"
			+ "76;-30276;-5549569;-30276;-30276;-5549569;-30276;-30276;-30276;-5761;-5761;-5761"
			+ ";-16777216;-1;-1;-1;-1;-1;-38400;-38400;-38400;-38400;-38400;-38400;-38400;-3840"
			+ "0;-38400;-38400;-38400;-38400;-38400;-16777216;-5761;-30276;-30276;-5549569;-30"
			+ "276;-30276;-30276;-30276;-16777216;-16777216;-30276;-30276;-30276;-30276;-30276;"
			+ "-5761;-16777216;-1;-16777216;-16777216;-1;-1;-38400;-38400;-38400;-10240;-10240;"
			+ "-10240;-10240;-16777216;-16777216;-16777216;-16777216;-38400;-38400;-16777216;-5"
			+ "761;-30276;-30276;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-1677"
			+ "7216;-30276;-30276;-5549569;-30276;-5761;-16777216;-16777216;-10395296;-10395296;"
			+ "-16777216;-1;-10240;-10240;-10240;-10240;-10240;-10240;-16777216;-10395296;-103952"
			+ "96;-10395296;-16777216;-16777216;-16777216;-16777216;-5761;-30276;-30276;-30276;-3"
			+ "0276;-30276;-30276;-16777216;-10395296;-10395296;-10395296;-16777216;-30276;-30276"
			+ ";-30276;-5761;-16777216;-10395296;-10395296;-10395296;-16777216;-1;-10240;-10240;-"
			+ "10240;-16711903;-16711903;-16711903;-16777216;-16777216;-10395296;-10395296;-10395"
			+ "296;-10395296;-10395296;-16777216;-5761;-30276;-30276;-30276;-5549569;-30276;-3027"
			+ "6;-16777216;-10395296;-10395296;-10395296;-10395296;-16777216;-16777216;-16777216;"
			+ "-16777216;-10395296;-10395296;-10395296;-10395296;-16777216;-1;-16711903;-16711903"
			+ ";-16711903;-16711903;-16711903;-16711903;-16711903;-16711903;-16777216;-16777216;-1"
			+ "6777216;-16777216;-10395296;-16777216;-5761;-30276;-30276;-30276;-30276;-30276;-302"
			+ "76;-16777216;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;"
			+ "-10395296;-10395296;-10395296;-10395296;-10395296;-16777216;-1;-16711903;-16711903;"
			+ "-16711903;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16"
			+ "739073;-16777216;-16777216;-16777216;-5761;-30276;-30276;-30276;-30276;-5549569;-16"
			+ "777216;-10395296;-10395296;-10395296;-1;-16777216;-10395296;-10395296;-10395296;-1"
			+ "0395296;-10395296;-1;-16777216;-10395296;-10395296;-16777216;-16739073;-16739073;-"
			+ "16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16739073;-16"
			+ "739073;-16739073;-16739073;-16777216;-5761;-30276;-5549569;-30276;-30276;-30276;-1"
			+ "6777216;-10395296;-10395296;-10395296;-16777216;-16777216;-10395296;-10395296;-103"
			+ "95296;-16777216;-10395296;-16777216;-16777216;-10395296;-10395296;-16777216;-16739"
			+ "073;-16739073;-16739073;-9160787;-9160787;-9160787;-9160787;-9160787;-16739073;-16"
			+ "739073;-16739073;-16739073;-16739073;-16777216;-5761;-30276;-30276;-30276;-5549569"
			+ ";-30276;-16777216;-10395296;-30276;-30276;-10395296;-10395296;-10395296;-10395296;"
			+ "-10395296;-10395296;-10395296;-10395296;-10395296;-30276;-30276;-16777216;-9160787"
			+ ";-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;-9160787;"
			+ "-9160787;-9160787;-16777216;-16777216;-5761;-5761;-30276;-5549569;-30276;-30276;-1"
			+ "6777216;-10395296;-30276;-30276;-10395296;-16777216;-10395296;-10395296;-16777216;"
			+ "-10395296;-10395296;-16777216;-10395296;-30276;-30276;-16777216;-9160787;-9160787;"
			+ "-9160787;-1;-1;-1;-1;-1;-9160787;-9160787;-16777216;-16777216;-16777216;-16777216;"
			+ "-5761;-5761;-5761;-30276;-30276;-30276;-30276;-16777216;-10395296;-10395296;-10395"
			+ "296;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-1039529"
			+ "6;-10395296;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-10395296;-10395296;"
			+ "-10395296;-16777216;-16777216;-5761;-5761;-5761;-5761;-5761;-5761;-5761;-16777216;"
			+ "-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-10395296;-1"
			+ "0395296;-10395296;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;-10395296;-"
			+ "10395296;-16777216;-1;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;"
			+ "-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-16777216;-1"
			+ "6777216;-16777216;-16777216;-16777216;-16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-"
			+ "1;-16777216;-16777216;-16777216;-1;-1;-1;-16777216;-10395296;-10395296;-16777216;-"
			+ "1;-1;-1;-16777216;-10395296;-10395296;-16777216;-1;-16777216;-10395296;-10395296;-"
			+ "16777216;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-16777216;"
			+ "-16777216;-16777216;-1;-1;-1;-1;-16777216;-16777216;-16777216;-1;-1;-16777216;-167"
			+ "77216;-16777216;-1;-1;-1;-1;-1;";
}