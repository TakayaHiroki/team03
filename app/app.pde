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
PImage playerImage, slimeImage, fruitImage, treasureImage, heartImage;

void loadImages() {
  playerImage   = loadImage("player.png");
  slimeImage    = loadImage("slime.png");
  fruitImage    = loadImage("fruit.png");
  treasureImage = loadImage("treasure.png");
  heartImage    = loadImage("heart.png");
}

// キャラクターオブジェクト
Player player;
ArrayList<Slime> slimes;
ArrayList<Item> items;

//--------------
// SETUP & DRAW
//--------------

void setup() {
  size(640, 480);
  frameRate(60); 
  
  loadImages();
  
  gameMap = new GameMap("map.txt"); 
  
  createCharactersFromMap();
  createItemsFromMap();

  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(0);

  if (!gameStarted) {
    showStartOrEndScreen();
  } else {
    gameMap.draw();
    
    player.move();
    player.paint();
    
    for (Slime s : slimes) {
      if (s.isAlive) {
        s.move();
        s.paint();
      }
    }
    
    for (Item item : items) {
      item.paint();
    }
    
    drawUI();
    updateGameLogic();
    checkCollisions();
  }
}

//------------------------------
// HELPER FUNCTIONS
//------------------------------

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
        items.add(new Item(x, y, "dot"));
      }
    }
  }
}

void checkCollisions() {
  for (int i = items.size() - 1; i >= 0; i--) {
    Item item = items.get(i);
    if (item.isCollisionWithPlayer(player)) {
      item.eat();
      if (item.getType().equals("fruit")) {
        score += 100;
      } else if (item.getType().equals("treasure")) {
        score += 500;
      } else if (item.getType().equals("dot")) {
        score += 10;
      }
      items.remove(i);
    }
  }

  for (Slime slime : slimes) {
    if (slime.isAlive && isCollisionBetweenCharacters(player, slime)) {
      life--;
      resetPlayerPosition();
      break;
    }
  }

  if (items.size() == 0) {
    gameOver = true;
    gameStarted = false;
  }
}

boolean isCollisionBetweenCharacters(Character c1, Character c2) {
  float distance = dist(c1.x, c1.y, c2.x, c2.y);
  return distance < 20;
}

void resetPlayerPosition() {
  for (int row = 0; row < gameMap.mapData.length; row++) {
    for (int col = 0; col < gameMap.mapData[row].length; col++) {
      if (gameMap.mapData[row][col] == '.' && row > 0 && col > 0) {
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

  drawHearts();

  fill(0, 255, 255);
  textAlign(LEFT, CENTER);
  text("Items: " + items.size(), 10, 50);
}

void drawHearts() {
  int heartSize = 24;
  int xOffset = width - 10 - heartSize;
  int yOffset = 20;
  for (int i = 0; i < life; i++) {
    image(heartImage, xOffset - i * (heartSize + 5), yOffset, heartSize, heartSize);
  }
}

void updateGameLogic() {
  int elapsedTime = (millis() - startTime) / 1000;
  int remainingTime = max(0, totalTime - elapsedTime);
  
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
    text("Mog-Man", width / 2, height / 2 - 30);
    textSize(20);
    text("Press SPACE to Start", width / 2, height / 2 + 10);
  }
}

//----------------------
// USER INPUT
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
  if (player != null) {
    if ((key == 'w' && player.direction.equals("up")) ||
        (key == 's' && player.direction.equals("down")) ||
        (key == 'a' && player.direction.equals("left")) ||
        (key == 'd' && player.direction.equals("right"))) {
      player.setDirection("stop");
    }
  }
}
