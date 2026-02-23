int distance(PVector start, PVector previousPosition, PVector goal, Board board, int calls) {
  if (calls > 40) {
    return 1000; 
  }
  
  if (start.x == goal.x && start.y == goal.y) {
    return 0; 
  }
  
  int distanceUp = 1000;
  int distanceDown = 1000;
  int distanceRight = 1000;
  int distanceLeft = 1000;
  
  if (start.y == 0) {
    if (!(previousPosition.x == start.x && previousPosition.y == board._nbCellsY-1)) {
      distanceUp = 1 + distance(new PVector(start.x, board._nbCellsY - 1), start, goal, board, calls+1);
    }
  } else if (board._cells[int(start.y) - 1][int(start.x)] != TypeCell.WALL) {
    if (!(previousPosition.x == start.x && previousPosition.y == start.y-1)) {
      distanceUp = 1 + distance(new PVector(start.x, start.y - 1), start, goal, board, calls+1);
    }
  }
  
  if (start.y == board._nbCellsY - 1) {
    if (!(previousPosition.x == start.x && previousPosition.y == 0)) {
      distanceDown = 1 + distance(new PVector(start.x, 0), start, goal, board, calls+1);
    }
  } else if (board._cells[int(start.y) + 1][int(start.x)] != TypeCell.WALL) {
    if (!(previousPosition.x == start.x && previousPosition.y == start.y + 1)) {
      distanceDown = 1 + distance(new PVector(start.x, start.y + 1), start, goal, board, calls+1);
    }
  }
  
  if (start.x == board._nbCellsX - 1) {
    if (!(previousPosition.x == 0 && previousPosition.y == start.y)) {
      distanceRight = 1 + distance(new PVector(0, start.y), start, goal, board, calls+1);
    }
  } else if (board._cells[int(start.y)][int(start.x)+1] != TypeCell.WALL) {
    if (!(previousPosition.x == start.x+1 && previousPosition.y == start.y)) {
      distanceRight = 1 + distance(new PVector(start.x+1, start.y), start, goal, board, calls+1);
    }
  }
  
  if (start.x == 0) {
    if (!(previousPosition.x == board._nbCellsX-1 && previousPosition.y == start.y)) {
      distanceLeft = 1 + distance(new PVector(board._nbCellsX-1, start.y), start, goal, board, calls+1);
    }
  } else if (board._cells[int(start.y)][int(start.x)-1] != TypeCell.WALL) {
    if (!(previousPosition.x==start.x-1 && previousPosition.y == start.y)) {
      distanceLeft = 1 + distance(new PVector(start.x-1, start.y), start, goal, board, calls+1);
    }
  }
  
  int leastDistance = 1000;
  if (distanceUp < leastDistance) {
     leastDistance = distanceUp;
  }
  
  if (distanceDown < leastDistance) {
     leastDistance = distanceDown;
  }
  
  if (distanceRight < leastDistance) {
     leastDistance = distanceRight;
  }
  
  if (distanceLeft < leastDistance) {
     leastDistance = distanceLeft;
  }
  
  return leastDistance;
}

PVector bestDirection(PVector start, PVector goal, Board board) {
  if (start.x == goal.x && start.y == goal.y) {
    return null; 
  }
  
  int distanceUp = 1000;
  int distanceDown = 1000;
  int distanceRight = 1000;
  int distanceLeft = 1000;
  
  if (start.y == 0) {
    distanceUp = distance(new PVector(start.x, board._nbCellsY-1), start, goal, board, 1);
  } else if (board._cells[int(start.y) - 1][int(start.x)] != TypeCell.WALL) {
    distanceUp = distance(new PVector(start.x, start.y-1), start, goal, board, 1);
  }
  
  if (start.y == board._nbCellsY - 1) {
    distanceDown = distance(new PVector(start.x, 0), start, goal, board, 1);
  } else if (board._cells[int(start.y) + 1][int(start.x)] != TypeCell.WALL) {
    distanceDown = distance(new PVector(start.x, start.y+1), start, goal, board, 1);
  }

  if (start.x == board._nbCellsX - 1) {
    distanceRight = distance(new PVector(0, start.y), start, goal, board, 1);
  } else if (board._cells[int(start.y)][int(start.x)+1] != TypeCell.WALL) {
    distanceRight = distance(new PVector(start.x+1, start.y), start, goal, board, 1);
  }
    
  if (start.x == 0) {
    distanceLeft = distance(new PVector(board._nbCellsX-1, start.y), start, goal, board, 1);
  } else if (board._cells[int(start.y)][int(start.x)-1] != TypeCell.WALL) {
    distanceLeft = distance(new PVector(start.x-1, start.y), start, goal, board, 1);
  }
  
  int leastDistance = 1000;
  PVector result = new PVector();
  
  if (distanceUp < leastDistance) {
     leastDistance = distanceUp;
     result = new PVector(0,-1);
  }
  
  if (distanceDown < leastDistance) {
     leastDistance = distanceDown;
     result = new PVector(0,1);
  }
  
  if (distanceRight < leastDistance) {
     leastDistance = distanceRight;
     result = new PVector(1,0);
  }
  
  if (distanceLeft < leastDistance) {
     leastDistance = distanceLeft;
     result = new PVector(-1,0);
  }
  
  return result;
}

PVector hallwayEnd(Board board, PVector cell, PVector direction) {
  int previousX = (int)cell.x;
  int previousY = (int)cell.y;
  int x = (int)cell.x;
  int y = (int)cell.y;
  
  while (board._cells[y][x] != TypeCell.WALL) {
    previousX = x;
    previousY = y;
    
    x += (int)direction.x;
    y += (int)direction.y;
    
    if (x < 0) {
      x = board._nbCellsX - 1;
    } else if (x > board._nbCellsX - 1) {
      x = 0; 
    } else if (y < 0) {
      y = board._nbCellsY - 1;
    } else if (y > board._nbCellsY - 1) {
      y = 0;
    }
  }
  
  return new PVector(previousX, previousY);
}

PVector randomDirection(PVector pos, PVector direction, Board board) {  
  int availableDirections = 0;
  
  if (pos.x == board._nbCellsX - 1 || board._cells[(int)pos.y][(int)pos.x+1] != TypeCell.WALL) {
    availableDirections += 1;
  }
  if (pos.x == 0 || board._cells[(int)pos.y][(int)pos.x-1] != TypeCell.WALL) {
    availableDirections += 1;
  }
  if (pos.y == board._nbCellsY - 1 || board._cells[(int)pos.y+1][(int)pos.x] != TypeCell.WALL) {
    availableDirections += 1;
  }
  if (pos.y == 0 || board._cells[(int)pos.y-1][(int)pos.x] != TypeCell.WALL) {
    availableDirections += 1;
  }
  
  while (true) {
    int rand = (int)random(4);
    
    if (rand == 0 && (direction.x != -1 || availableDirections == 1) && (pos.x == board._nbCellsX - 1 || board._cells[(int)pos.y][(int)pos.x+1] != TypeCell.WALL)) {
      return new PVector(1,0);
    } else if (rand == 1 && (direction.x != 1 || availableDirections == 1) && (pos.x == 0 || board._cells[(int)pos.y][(int)pos.x-1] != TypeCell.WALL)) {
      return new PVector(-1,0);
    } else if (rand == 2 && (direction.y != -1 || availableDirections == 1) && (pos.y == board._nbCellsY - 1 || board._cells[(int)pos.y+1][(int)pos.x] != TypeCell.WALL)) {
      return new PVector(0,1);
    } else if (rand == 3 && (direction.y != 1 || availableDirections == 1) && (pos.y == 0 || board._cells[(int)pos.y-1][(int)pos.x] != TypeCell.WALL)) {
      return new PVector(0,-1);
    }
  }
}
