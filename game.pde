class Game 
{
  int _currentFrame;
  Board _board;
  Hero _hero;
  Ghost[] _ghosts;
  
  String _levelName;
  
  Game() {
    PVector levelSize = getBoardSizeFromFile("levels/level1.txt");
    
    float cellSize = width / levelSize.x;
    if (height / levelSize.y < cellSize) {
      cellSize = height / levelSize.y; 
    }
    
    float yOffset = height - cellSize * levelSize.y;
    
    _board = new Board(new PVector(0,yOffset), (int)levelSize.x, (int)levelSize.y, cellSize);
    _board.loadBoardFromFile("levels/level1.txt");
    
    _hero = new Hero(new PVector(_board._startPosition.x * cellSize, _board._startPosition.y * cellSize), new PVector(4, yOffset +3), cellSize, new PVector(1, 0));
    PVector boardCenter = _board.getBoardCenter();
    _ghosts = new Ghost[4];
    _ghosts[0] = new Ghost(new PVector(boardCenter.x * cellSize, (boardCenter.y-1) * cellSize), new PVector (4, yOffset + 3), cellSize, new PVector(1, 0), TypeGhost.BLINKY);
    _ghosts[1] = new Ghost(new PVector(boardCenter.x * cellSize, (boardCenter.y-1) * cellSize), new PVector (4, yOffset + 3), cellSize, new PVector(1, 0), TypeGhost.PINKY);
    _ghosts[2] = new Ghost(new PVector(boardCenter.x * cellSize, (boardCenter.y-1) * cellSize), new PVector (4, yOffset + 3), cellSize, new PVector(1, 0), TypeGhost.INKY);
    _ghosts[3] = new Ghost(new PVector(boardCenter.x * cellSize, (boardCenter.y-1) * cellSize), new PVector (4, yOffset + 3), cellSize, new PVector(1, 0), TypeGhost.CLYDE);
    
    _currentFrame = 0;
  }
  
  PVector getBoardSizeFromFile(String fileName) {
    String[] boardLines = loadStrings(fileName);
    int greatestWidth = 0;
    
    for (int i=0; i<boardLines.length; i++) {
      if (boardLines[i].length() > greatestWidth) {
        greatestWidth = boardLines[i].length(); 
      }
    }
    
    return new PVector(greatestWidth, boardLines.length);
  }
  
  void update() {
    if (_hero._deathSprite == 2*11-1) {
      _hero._deathSprite = 0;
      _hero._dead = false;
      _hero._lifes -= 1;
      _hero._position = new PVector(_board._startPosition.x * _board._cellSize, _board._startPosition.y * _board._cellSize);
      _hero._direction = new PVector(1,0);
      for (Ghost ghost : _ghosts) {
        ghost._position = new PVector(ghost._startPosition.x, ghost._startPosition.y);
      }
    }
    
    _hero.update(_board, _currentFrame);
    
    if (_hero._ateSuperDot) {
      _hero._ateSuperDot = false;
      for (Ghost ghost : _ghosts) {
        ghost._canBeEaten = true;
      }
    } else if (_currentFrame >= _hero._superDotEffectEnd) {
      _hero._multiplier = 1;
       for (Ghost ghost : _ghosts) {
        ghost._canBeEaten = false;
      }
    }
    
    if (!_hero._dead) {
      for (Ghost ghost : _ghosts) {
        ghost.update(_board, _hero, _currentFrame);
      }
    }
    
    for (Ghost ghost : _ghosts) {
      if (_hero._cellX == ghost._cellX && _hero._cellY == ghost._cellY) {
        if (ghost._canBeEaten) {
          ghost._canBeEaten = false;
          ghost._position = new PVector(ghost._startPosition.x, ghost._startPosition.y);
          _hero._score += 200 * _hero._multiplier;
          _hero._multiplier *= 2;
      } else {
          _hero._dead = true; 
          _hero._multiplier = 1;
        }
      }
    }
    
    _currentFrame += 1;
  }
  
  void drawIt() {
    background(0);
    _board.drawIt();
    _hero.drawIt();
    for (Ghost ghost : _ghosts) {
      ghost.drawIt();
    }
    textSize(20);
    fill(255,255,255);
    text("SCORE: "+_hero._score + "     LIFES: "+_hero._lifes, 10, 20);
  }
  
  void handleKey(int k) {
    if (k == 'z' || keyCode == UP) {
      _hero.launchMove(new PVector(0, -1)); 
    } else if (k == 'q' || keyCode == LEFT) {
      _hero.launchMove(new PVector(-1, 0));
    } else if (k == 's' || keyCode == DOWN) {
      _hero.launchMove(new PVector(0, 1));
    } else if (k == 'd' || keyCode == RIGHT) {
      _hero.launchMove(new PVector(1, 0)); 
    }
  }
}
