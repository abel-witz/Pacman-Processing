class Hero {
  PImage[] _sprites;
  
  // position on screen
  PVector _position;
  PVector _posOffset;
  // position on board
  int _cellX, _cellY;
  // display size
  float _size;
  
  int _spriteOffset;
  int _currentSprite;
  
  int _score;
  int _lifes;
  
  // move data
  PVector _direction;
  PVector _cachedDirection;
  boolean _moving; // is moving ? 
  
  boolean _dead;
  int _deathSprite;
  
  boolean _ateSuperDot;
  int _superDotEffectEnd;
  int _multiplier;
    
  Hero(PVector position, PVector posOffset, float size, PVector direction) {
    _size = size;
    _position = position;
    _posOffset = posOffset;
    _direction = direction;
    _currentSprite = 5;
    _multiplier = 1;
    
    _score = 0;
    _lifes = 2;
    
    PImage spriteSheet = loadImage("data/img/pacman_sprites.png");
    _sprites = new PImage[23];
    for (int i=0; i<12; i++) {
       _sprites[i] = spriteSheet.get(17*50, 0 + i*50, 50, 50);
    }
    for (int i=0; i<11; i++) {
       _sprites[12+i] = spriteSheet.get(7*50, 0 + i*50, 50, 50);
    }
  }
  
  void launchMove(PVector dir) {
    _cachedDirection = dir;
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
         _position.x -= 8;
         _moving = true;
      } else if (_position.x > _cellX*board._cellSize) {
        _position.x -= 8;
        _moving = true;
         if (_position.x - (_cellX-1)*board._cellSize < board._cellSize) {
           _position.x = _cellX*board._cellSize;
           _moving = false;
         }
      }
    } else if (_direction.x == 1) {
      if (_cellX + 1 == board._nbCellsX || board._cells[_cellY][_cellX + 1] != TypeCell.WALL) {
         _position.x += 8;
         _moving = true;
      } else if (_position.x < _cellX*board._cellSize) {
        _position.x += 8;
        _moving = true;
         if ((_cellX+1)*board._cellSize - _position.x < board._cellSize) {
           _position.x = _cellX*board._cellSize;
           _moving = false;
         }
      }
    } else if (_direction.y == -1) {
      if (_cellY - 1 < 0 || board._cells[_cellY - 1][_cellX] != TypeCell.WALL) {
         _position.y -= 8;
         _moving = true;
      } else if (_position.y > _cellY*board._cellSize) {
        _position.y -= 8;
        _moving = true;
         if (_position.y - (_cellY-1)*board._cellSize < board._cellSize) {
           _position.y = _cellY*board._cellSize;
           _moving = false;
         }
      }
    } else if (_direction.y == 1) {
      if (_cellY + 1 == board._nbCellsY || board._cells[_cellY + 1][_cellX] != TypeCell.WALL) {
         _position.y += 8;
         _moving = true;
      } else if (_position.y < _cellY*board._cellSize) {
        _position.y += 8;
        _moving = true;
         if ((_cellY+1)*board._cellSize - _position.y < board._cellSize) {
           _position.y = _cellY*board._cellSize;
           _moving = false;
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
  
  void update(Board board, int currentFrame) {
    if (!_dead) {
      move(board);
    }
    
    if (board._cells[_cellY][_cellX] == TypeCell.DOT) {
      _score += 10;
      board._cells[_cellY][_cellX] = TypeCell.EMPTY;
    } else if (board._cells[_cellY][_cellX] == TypeCell.SUPER_DOT) {
      _score += 50;
      board._cells[_cellY][_cellX] = TypeCell.EMPTY;
      _ateSuperDot = true;
      _superDotEffectEnd = currentFrame + 30*10;
    }
    
    if (_moving) {
      _currentSprite = (_currentSprite + 1) % 6;
    }
    
    if (_dead) {
      _deathSprite = min(2*11-1, _deathSprite + 1); 
    }
    
    if (_direction.x == 1) {
       _spriteOffset = 0;
    } else if (_direction.x == -1) {
      _spriteOffset = 6; 
    } else if (_direction.y == 1) {
      _spriteOffset = 3;
    } else {
      _spriteOffset = 9; 
    }
    
    if (_cachedDirection != null) {
      changeDirection(board);
    }
  }
  
  void drawIt() {
    if (!_dead) {
      image(_sprites[_spriteOffset+_currentSprite/2], _position.x + _posOffset.x, _position.y + _posOffset.y, _size, _size);
    } else {
      image(_sprites[12+_deathSprite/2], _position.x + _posOffset.x, _position.y + _posOffset.y, _size, _size);
    }
  }
}
