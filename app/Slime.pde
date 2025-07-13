class Slime extends Character {
  boolean isAlive = true;
  int lastDirectionChange = 0;
  int directionChangeInterval = 120; // 2秒ごとに方向転換を検討
  
  Slime(int x, int y, int speed) {
    super(x, y, speed);
    changeDirection(); // 初期方向をランダムに設定
  }

  @Override
  void move() {
    // 定期的に方向を見直す
    if (frameCount - lastDirectionChange > directionChangeInterval) {
      chooseDirection();
      lastDirectionChange = frameCount;
    }
    
    // 現在の方向で移動できない場合、すぐに方向転換
    int nextX = x;
    int nextY = y;
    switch (direction) {
      case "up":    nextY -= speed; break;
      case "down":  nextY += speed; break;
      case "left":  nextX -= speed; break;
      case "right": nextX += speed; break;
    }
    
    if (isWall(nextX, nextY)) {
      chooseDirection();
    }
    
    super.move(); // 親クラスの壁判定付きmoveを呼び出す
  }
  
  void chooseDirection() {
    // プレイヤーとの距離を計算
    float distToPlayer = dist(x, y, player.x, player.y);
    
    // プレイヤーが近い場合（100ピクセル以内）は追いかける
    if (distToPlayer < 100) {
      chasePlayer();
    } else {
      // プレイヤーが遠い場合はランダムに動く
      changeDirection();
    }
  }
  
  void chasePlayer() {
    String[] possibleDirections = {"up", "down", "left", "right"};
    String bestDirection = direction;
    float bestDistance = Float.MAX_VALUE;
    
    // 各方向に移動した場合のプレイヤーとの距離を計算
    for (String dir : possibleDirections) {
      int testX = x;
      int testY = y;
      
      switch (dir) {
        case "up":    testY -= speed; break;
        case "down":  testY += speed; break;
        case "left":  testX -= speed; break;
        case "right": testX += speed; break;
      }
      
      // その方向に移動できて、プレイヤーに近づく場合
      if (!isWall(testX, testY)) {
        float distanceToPlayer = dist(testX, testY, player.x, player.y);
        if (distanceToPlayer < bestDistance) {
          bestDistance = distanceToPlayer;
          bestDirection = dir;
        }
      }
    }
    
    // 最適な方向が見つからない場合はランダムに選択
    if (bestDistance == Float.MAX_VALUE) {
      changeDirection();
    } else {
      this.direction = bestDirection;
    }
  }
  
  void changeDirection() {
    String[] dirs = {"up", "down", "left", "right"};
    ArrayList<String> validDirections = new ArrayList<String>();
    
    // 移動可能な方向のみを選択肢に追加
    for (String dir : dirs) {
      int testX = x;
      int testY = y;
      
      switch (dir) {
        case "up":    testY -= speed; break;
        case "down":  testY += speed; break;
        case "left":  testX -= speed; break;
        case "right": testX += speed; break;
      }
      
      if (!isWall(testX, testY)) {
        validDirections.add(dir);
      }
    }
    
    // 移動可能な方向からランダムに選択
    if (validDirections.size() > 0) {
      this.direction = validDirections.get(int(random(validDirections.size())));
    }
  }

  @Override
  void paint() {
    if (isAlive) {
      fill(0, 255, 0); // 緑色
      noStroke();
      ellipse(x, y, 20, 20);
      
      // デバッグ用：プレイヤーとの距離が近い場合は色を変える
      float distToPlayer = dist(x, y, player.x, player.y);
      if (distToPlayer < 100) {
        fill(255, 0, 0); // 追跡中は赤色
        ellipse(x, y, 18, 18);
      }
    }
  }
}
