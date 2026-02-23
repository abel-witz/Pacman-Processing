enum TypeCell 
{
  EMPTY, WALL, DOT, SUPER_DOT // others ?
}

class Board 
{
  TypeCell _cells[][];
  PVector _position;
  PVector _startPosition;
  int _nbCellsX;
  int _nbCellsY;
  float _cellSize; // cells should be square
  
  Board(PVector position, int nbCellsX, int nbCellsY, float cellSize) {
    _position = position;
    _cells = new TypeCell[nbCellsY][nbCellsX];
    _nbCellsX = nbCellsX;
    _nbCellsY = nbCellsY;
    _cellSize = cellSize;
  }
  
  void loadBoardFromFile(String fileName) {
    PVector pacManPosition = new PVector();
    String[] boardLines = loadStrings(fileName);
    for (int i=0; i<_nbCellsY; i++) {
      if (i == boardLines.length)
        break;
        
      for (int j=0; j<_nbCellsX; j++) {
        if (j < boardLines[i].length()) {
           char c = boardLines[i].charAt(j);
           
           if (c == 'x') {
             _cells[i][j] = TypeCell.WALL;
           } else if (c == 'V') {
             _cells[i][j] = TypeCell.EMPTY; 
           } else if (c == 'o') {
             _cells[i][j] = TypeCell.DOT; 
           } else if (c == 'O') {
             _cells[i][j] = TypeCell.SUPER_DOT; 
           } else if (c == 'P') {
             pacManPosition.x = j;
             pacManPosition.y = i;
           }
        }
      }
    }
    _startPosition = pacManPosition;
  }
  
  PVector getBoardCenter() {
    return new PVector(int(_nbCellsX/2), int(_nbCellsY/2));
  }
  
  void drawIt() {
    for (int i=0; i<_nbCellsY; i++) {
      for (int j=0; j<_nbCellsX; j++) {
        if (_cells[i][j] == TypeCell.WALL) {
          stroke(0,0,255);
          strokeWeight(3);
          fill(0, 0, 0);
          square(j*_cellSize + _position.x, i*_cellSize + _position.y, _cellSize);
        } else if (_cells[i][j] == TypeCell.DOT) {
           fill(234,203,200);
           noStroke();
           square(j*_cellSize + _position.x + _cellSize/2 - 8/2, i*_cellSize + _position.y + _cellSize/2 - 8/2, 8); 
        } else if (_cells[i][j] == TypeCell.SUPER_DOT) {
          fill(234,203,200);
          noStroke();
          circle(j*_cellSize + _position.x + _cellSize/2, i*_cellSize + _position.y + _cellSize/2, 20);
        }
      }
    }
  }
}
