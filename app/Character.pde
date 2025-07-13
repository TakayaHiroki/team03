abstract class Character {
  int x, y;
  int speed;
  String direction = "stop"; // 初期方向は停止

  Character(int x, int y, int speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  // 壁を考慮した移動メソッド
  void move() {
    int nextX = x;
    int nextY = y;
    
    // 1. 次の座標を計算
    switch (direction) {
      case "up":    nextY -= speed; break;
      case "down":  nextY += speed; break;
      case "left":  nextX -= speed; break;
      case "right": nextX += speed; break;
      default: return; // "stop"なら何もしない
    }
    
    // 2. 次の座標が壁でないかチェック
    if (!isWall(nextX, nextY)) {
      // 壁でなければ座標を更新
      x = nextX;
      y = nextY;
    }
  }
  
  // 指定された座標が壁かどうかを判定する
  boolean isWall(int checkX, int checkY) {
    // キャラクターの端4点の座標を計算
    int[] checkPointsX = {checkX - 10, checkX + 10, checkX - 10, checkX + 10};
    int[] checkPointsY = {checkY - 10, checkY - 10, checkY + 10, checkY + 10};
    
    for (int i = 0; i < 4; i++) {
        // オフセットを考慮してピクセル座標をマップのマス目（col, row）に変換
        int col = (checkPointsX[i] - gameMap.offsetX) / gameMap.tileSize;
        int row = (checkPointsY[i] - gameMap.offsetY) / gameMap.tileSize;
      
        // マップの範囲外か、壁（#）に衝突しているか
        if (col < 0 || col >= gameMap.mapData[0].length || row < 0 || row >= gameMap.mapData.length || gameMap.mapData[row][col] == '#') {
            return true; // 壁である
        }
    }
    return false; // 壁ではない
  }

  // 方向を設定するメソッドを追加
  void setDirection(String dir) {
    this.direction = dir;
  }

  abstract void paint();
}
