Game game;
Menu menu;
boolean inGame;

void setup() {
  size(800, 800, P2D);
  frameRate(30);
  game = new Game();
  menu = new Menu();
}

void draw() {
  if (inGame) {
    game.update();
    game.drawIt();
  } else {
     menu.drawIt();
  }
}

void keyPressed() {
  if (keyCode == ESC) {
    inGame = false; 
  } else {
    game.handleKey(key);
  }
}

void mousePressed() {
  if (inGame)
    return;
  
  if (380 <= mouseX && mouseX <= 480) {
    if (390 <= mouseY && mouseY <= 420) {
      game = new Game();
      inGame = true; 
    }
  }
}
