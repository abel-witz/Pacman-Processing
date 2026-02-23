enum TypeGhost
{
  BLINKY, PINKY, INKY, CLYDE
}

class Ghost {
  TypeGhost _ghostType;
  
  PImage[] _sprites;
  int _spriteOffset;
  int _currentSprite;
  
  PVector _position;
  PVector _startPosition;
  PVector _posOffset;
  
  int _cellX, _cellY;
  
  float _size;
  
  PVector _direction;
  PVector _cachedDirection;
  
  int _nextIntelligent;
  boolean _intelligent;
  
  boolean _canBeEaten;
  
  Ghost(PVector position, PVector posOffset, float size, PVector direction, TypeGhost ghostType) {
    _size = size;
    _position = position;
    _startPosition = new PVector(position.x, position.y);
    _posOffset = posOffset;
    _direction = direction;
    _ghostType = ghostType;
    _nextIntelligent = 10*30 + (int)random(20*30);
    
    PImage spriteSheet = loadImage("data/img/pacman_sprites.png");
    _sprites = new PImage[8];
    if (_ghostType == TypeGhost.BLINKY) {
      for (int i=0; i<_sprites.length; i++) {
         _sprites[i] = spriteSheet.get(0, 0 + i*50, 50, 50);
      }
    } else if (_ghostType == TypeGhost.PINKY) {
      for (int i=0; i<_sprites.length; i++) {
         _sprites[i] = spriteSheet.get(1*50, 0 + i*50, 50, 50);
      }
    } else if (_ghostType == TypeGhost.INKY) {
      for (int i=0; i<_sprites.length; i++) {
         _sprites[i] = spriteSheet.get(2*50, 0 + i*50, 50, 50);
      }
    } else if (_ghostType == TypeGhost.CLYDE) {
      for (int i=0; i<_sprites.length; i++) {
         _sprites[i] = spriteSheet.get(3*50, 0 + i*50, 50, 50);
      }
    }
  }
  
  void changeDirection(Board board) {
    if (_direction.x == -_cachedDirection.x || _direction.y == -_cachedDirection.y) {
      _direction = _cachedDirection;
    } else if (Math.abs(_position.x - _cellX*board._cellSize) < 4 && Math.abs(_position.y - _cellY*board._cellSize) < 4) {
      if (_cachedDirection.x == 1 && board._cells[_cellY][_cellX+1] != TypeCell.WALL) {
        _direction = _cachedDirection;
        _position.x = _cellX*board._cellSize;
        _position.y =_cellY*board._cellSize;
      } else if (_cachedDirection.x == -1 && board._cells[_cellY][_cellX-1] != TypeCell.WALL) {
        _direction = _cachedDirection;
        _position.x = _cellX*board._cellSize;
        _position.y =_cellY*board._cellSize;
      } else if (_cachedDirection.y == 1 && board._cells[_cellY+1][_cellX] != TypeCell.WALL) {
        _direction = _cachedDirection;
        _position.x = _cellX*board._cellSize;
        _position.y =_cellY*board._cellSize;
      } else if (_cachedDirection.y == -1 && board._cells[_cellY-1][_cellX] != TypeCell.WALL) {
        _direction = _cachedDirection;
        _position.x = _cellX*board._cellSize;
        _position.y =_cellY*board._cellSize;
      }
    }
  }
  
  void move(Board board) {
    _cellX = Math.round(_position.x / board._cellSize);
    _cellY = Math.round(_position.y / board._cellSize);
    
    if (_direction.x == -1) {
      if (_cellX - 1 < 0 || board._cells[_cellY][_cellX - 1] != TypeCell.WALL) {
         _position.x -= 6;
      } else if (_position.x > _cellX*board._cellSize) {
        _position.x -= 6;
         if (_position.x - (_cellX-1)*board._cellSize < board._cellSize) {
           _position.x = _cellX*board._cellSize;
         }
      }
    } else if (_direction.x == 1) {
      if (_cellX + 1 == board._nbCellsX || board._cells[_cellY][_cellX + 1] != TypeCell.WALL) {
         _position.x += 6;
      } else if (_position.x < _cellX*board._cellSize) {
        _position.x += 6;
         if ((_cellX+1)*board._cellSize - _position.x < board._cellSize) {
           _position.x = _cellX*board._cellSize;
         }
      }
    } else if (_direction.y == -1) {
      if (_cellY - 1 < 0 || board._cells[_cellY - 1][_cellX] != TypeCell.WALL) {
         _position.y -= 6;
      } else if (_position.y > _cellY*board._cellSize) {
        _position.y -= 6;
         if (_position.y - (_cellY-1)*board._cellSize < board._cellSize) {
           _position.y = _cellY*board._cellSize;
         }
      }
    } else if (_direction.y == 1) {
      if (_cellY + 1 == board._nbCellsY || board._cells[_cellY + 1][_cellX] != TypeCell.WALL) {
         _position.y += 6;
      } else if (_position.y < _cellY*board._cellSize) {
        _position.y += 6;
         if ((_cellY+1)*board._cellSize - _position.y < board._cellSize) {
           _position.y = _cellY*board._cellSize;
         }
      }
    }
    
    if (_position.x + board._cellSize/2 < 0) {
      _position.x = (board._nbCellsX - 1) * board._cellSize;
    } else if (_position.x - board._cellSize/2 > (board._nbCellsX-1)*board._cellSize) {
      _position.x = 0; 
    }
      
    _cellX = Math.round(_position.x / board._cellSize);
    _cellY = Math.round(_position.y / board._cellSize);
  }
  
  void update(Board board, Hero hero, int currentFrame) {
    move(board);
    
    _currentSprite = (_currentSprite + 1) % 4;
    
    if (_direction.x == 1) {
       _spriteOffset = 0;
    } else if (_direction.x == -1) {
      _spriteOffset = 4; 
    } else if (_direction.y == 1) {
      _spriteOffset = 2;
    } else {
      _spriteOffset = 6; 
    }
    
    if (_ghostType == TypeGhost.BLINKY) {
      _cachedDirection = bestDirection(new PVector(_cellX, _cellY), new PVector(hero._cellX, hero._cellY), board);
    } else if (_ghostType == TypeGhost.PINKY) {
      _cachedDirection = bestDirection(new PVector(_cellX, _cellY), hallwayEnd(board, new PVector(hero._cellX, hero._cellY), hero._direction), board);
    } else if (_ghostType == TypeGhost.INKY) {
      if (currentFrame > _nextIntelligent) {
        _intelligent = !_intelligent;
        _nextIntelligent = currentFrame + 10*30 + (int)random(20*30);
      }
      
      if (_intelligent && Math.abs(_position.x - _cellX*board._cellSize) < 4 && Math.abs(_position.y - _cellY*board._cellSize) < 4) {
        _cachedDirection = bestDirection(new PVector(_cellX, _cellY), hallwayEnd(board, new PVector(hero._cellX, hero._cellY), new PVector(-hero._direction.x, -hero._direction.y)), board);
      } else if (Math.abs(_position.x - _cellX*board._cellSize) < 4 && Math.abs(_position.y - _cellY*board._cellSize) < 4) {
        _cachedDirection = randomDirection(new PVector(_cellX, _cellY), _direction, board);
      }
    } else if (_ghostType == TypeGhost.CLYDE && Math.abs(_position.x - _cellX*board._cellSize) < 4 && Math.abs(_position.y - _cellY*board._cellSize) < 4) {
      _cachedDirection = randomDirection(new PVector(_cellX, _cellY), _direction, board);
    }
    
    if (_cachedDirection != null) {
      changeDirection(board);
    } 
  }
  
  void drawIt() {
    image(_sprites[_spriteOffset+_currentSprite/2], _position.x + _posOffset.x, _position.y + _posOffset.y, _size, _size);
  }
}
