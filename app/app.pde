// YourProjectName.pde

// ゲームの状態を管理する変数
GameMap gameMap;
boolean gameStarted = false;
boolean gameOver = false;

// UIやゲームロジックに関する変数
int score = 0;
int life = 3;
int totalTime = 300; // 制限時間を5分（300秒）に延長
int startTime;

// 画像を保持する変数
PImage playerImage, slimeImage, fruitImage, treasureImage;
void loadImages() {
  playerImage   = loadImage("player.png");
  slimeImage    = loadImage("slime.png");
  fruitImage    = loadImage("fruit.png");
  treasureImage = loadImage("treasure.png");
}

// キャラクターオブジェクト
Player player;
ArrayList<Slime> slimes;
ArrayList<Item> items; // アイテムリストを追加

//--------------
// SETUP & DRAW
//--------------

void setup() {
  size(640, 480);
  frameRate(60); 
  
  loadImages(); // 画像読み込み
  
  gameMap = new GameMap("map.txt"); 
  
  createCharactersFromMap(); // マップからキャラクターを生成
  createItemsFromMap(); // アイテムを生成

  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(0);

  if (!gameStarted) {
    showStartOrEndScreen();
  } else {
    // === ゲーム実行中の処理 ===
    gameMap.draw();
    
    player.move();
    player.paint();
    
    // スライムの移動と描画
    for (Slime s : slimes) {
      if (s.isAlive) {
        s.move();
        s.paint();
      }
    }
    
    // アイテムの描画
    for (Item item : items) {
      item.paint();
    }
    
    drawUI();
    updateGameLogic();
    checkCollisions(); // 衝突判定を追加
  }
}

//--------------------------------
// HELPER FUNCTIONS (各種補助機能)
//--------------------------------

void createCharactersFromMap() {
  slimes = new ArrayList<Slime>();
  for (int row = 0; row < gameMap.mapData.length; row++) {
    for (int col = 0; col < gameMap.mapData[row].length; col++) {
      char tile = gameMap.mapData[row][col];
      int x = col * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetX;
      int y = row * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetY;

      if (tile == 'P') {
        player = new Player(x, y, 2);
        gameMap.mapData[row][col] = '.';
      } else if (tile == 'S') {
        slimes.add(new Slime(x, y, 1));
        gameMap.mapData[row][col] = '.';
      }
    }
  }
}

// アイテムを生成する関数を追加
void createItemsFromMap() {
  items = new ArrayList<Item>();
  for (int row = 0; row < gameMap.mapData.length; row++) {
    for (int col = 0; col < gameMap.mapData[row].length; col++) {
      char tile = gameMap.mapData[row][col];
      int x = col * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetX;
      int y = row * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetY;

      if (tile == 'F') {
        items.add(new Item(x, y, "fruit"));
        gameMap.mapData[row][col] = '.';
      } else if (tile == 'T') {
        items.add(new Item(x, y, "treasure"));
        gameMap.mapData[row][col] = '.';
      } else if (tile == '.') {
        // 通常の道にはドット（小さなアイテム）を配置
        items.add(new Item(x, y, "dot"));
      }
    }
  }
}

// 衝突判定を処理する関数を追加
void checkCollisions() {
  // プレイヤーとアイテムの衝突判定
  for (int i = items.size() - 1; i >= 0; i--) {
    Item item = items.get(i);
    if (item.isCollisionWithPlayer(player)) {
      item.eat();
      
      // アイテムの種類に応じてスコアを加算
      if (item.getType().equals("fruit")) {
        score += 100;
      } else if (item.getType().equals("treasure")) {
        score += 500;
      } else if (item.getType().equals("dot")) {
        score += 10;
      }
      
      // 食べられたアイテムを削除
      items.remove(i);
    }
  }
  
  // プレイヤーとスライムの衝突判定
  for (Slime slime : slimes) {
    if (slime.isAlive && isCollisionBetweenCharacters(player, slime)) {
      // プレイヤーがスライムに触れたらライフを減らす
      life--;
      // プレイヤーを初期位置に戻す（オプション）
      resetPlayerPosition();
      break; // 一度に複数のスライムとの衝突を避ける
    }
  }
  
  // 全てのアイテムが食べられたらゲームクリア
  if (items.size() == 0) {
    gameOver = true;
    gameStarted = false;
  }
}

// キャラクター同士の衝突判定
boolean isCollisionBetweenCharacters(Character c1, Character c2) {
  float distance = dist(c1.x, c1.y, c2.x, c2.y);
  return distance < 20; // 両方とも半径10の円として判定
}

// プレイヤーを初期位置に戻す
void resetPlayerPosition() {
  for (int row = 0; row < gameMap.mapData.length; row++) {
    for (int col = 0; col < gameMap.mapData[row].length; col++) {
      if (gameMap.mapData[row][col] == '.' && row > 0 && col > 0) {
        // 最初に見つかった道の位置に戻す
        player.x = col * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetX;
        player.y = row * gameMap.tileSize + gameMap.tileSize / 2 + gameMap.offsetY;
        return;
      }
    }
  }
}

void drawUI() {
  int elapsedTime = (millis() - startTime) / 1000;
  int remainingTime = max(0, totalTime - elapsedTime);

  fill(255, 255, 0);
  textAlign(LEFT, CENTER);
  text("Score: " + score, 10, 20);

  fill(255);
  textAlign(CENTER, CENTER);
  text("Time: " + remainingTime, width / 2, 20);

  fill(255, 0, 0);
  textAlign(RIGHT, CENTER);
  text(getHearts(life) + " Life", width - 10, 20);
  
  // 残りアイテム数を表示
  fill(0, 255, 255);
  textAlign(LEFT, CENTER);
  text("Items: " + items.size(), 10, 50);
}

void updateGameLogic() {
  int elapsedTime = (millis() - startTime) / 1000;
  int remainingTime = max(0, totalTime - elapsedTime);
  
  // 3秒ごとにライフを減らす処理を削除（スライムとの衝突でのみライフが減る）
  
  if (life <= 0 || remainingTime <= 0) {
    gameOver = true;
    gameStarted = false;
  }
}

void restartGame() {
  score = 0;
  life = 3;
  startTime = millis();
  gameStarted = true;
  gameOver = false;
  
  // マップを再読み込み
  gameMap = new GameMap("map.txt");
  createCharactersFromMap();
  createItemsFromMap();
}

void showStartOrEndScreen() {
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  if (gameOver) {
    if (items.size() == 0) {
      text("Game Clear!", width / 2, height / 2 - 50);
      textSize(24);
      text("Final Score: " + score, width / 2, height / 2 - 10);
    } else {
      text("Game Over", width / 2, height / 2 - 50);
      textSize(24);
      text("Score: " + score, width / 2, height / 2 - 10);
    }
    textSize(20);
    text("Press SPACE to Restart", width / 2, height / 2 + 30);
  } else {
    text("Pac-Man Game", width / 2, height / 2 - 30);
    textSize(20);
    text("Press SPACE to Start", width / 2, height / 2 + 10);
  }
}

String getHearts(int n) {
  String hearts = "";
  for (int i = 0; i < n; i++) {
    hearts += "💗";
  }
  return hearts;
}

//----------------------
// USER INPUT (キー入力)
//----------------------

void keyPressed() {
  if (!gameStarted) {
    if (key == ' ') {
      restartGame();
    }
  } else {
    switch (key) {
      case 'w': player.setDirection("up"); break;
      case 's': player.setDirection("down"); break;
      case 'a': player.setDirection("left"); break;
      case 'd': player.setDirection("right"); break;
    }
  }
}

void keyReleased() {
  // キーを離したときの挙動
  if (player != null) {
      // 押されているキーと同じ方向のキーが離されたら停止
      if ((key == 'w' && player.direction.equals("up")) ||
          (key == 's' && player.direction.equals("down")) ||
          (key == 'a' && player.direction.equals("left")) ||
          (key == 'd' && player.direction.equals("right"))) {
          player.setDirection("stop");
      }
  }
}
