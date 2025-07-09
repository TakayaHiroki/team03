Player player;
ArrayList<Slime> slimes;
ArrayList<Item> items;

int slimeMoveTimer = 0;

void setup() {
  size(640, 480);
  frameRate(60);

  // プレイヤー初期化
  player = new Player(100, 100, 2);

  // スライム初期化
  slimes = new ArrayList<Slime>();
  slimes.add(new Slime(300, 100, 2));
  slimes.add(new Slime(300, 300, 2));

  // アイテム初期化
  items = new ArrayList<Item>();
  for (int i = 60; i < width; i += 60) {
    for (int j = 60; j < height; j += 60) {
      String type = random(1) < 0.1 ? "power" : "dot"; // 10%でパワー
      items.add(new Item(i, j, type));
    }
  }
}

void draw() {
  background(0);

  // アイテム描画 & 取得処理
  for (Item item : items) {
    item.paint();
    if (item.isCollisionWithPlayer(player)) {
      player.eatItem(item);
    }
  }

  // スライムの移動（定期的に方向変更）
  slimeMoveTimer++;
  for (Slime slime : slimes) {
    if (slime.isAlive()) {
      if (slimeMoveTimer % 60 == 0) {
        slime.changeDirection();
      }
      slime.move();
      slime.draw(getGraphics());

      // 衝突判定
      if (slime.checkCollisionWithPlayer(player)) {
        if (playerIsPowered()) {
          slime.setAlive(false);
          println("Slime defeated!");
        } else {
          println("Game Over");
          noLoop();
        }
      }
    }
  }

  // プレイヤー状態更新・描画
  player.updatePowerState();
  player.move();
  player.draw(getGraphics());

  // ステージクリア判定
  boolean allEaten = true;
  for (Item item : items) {
    if (!item.isEaten) {
      allEaten = false;
      break;
    }
  }
  if (allEaten) {
    println("Stage Clear!");
    noLoop();
  }
}

boolean playerIsPowered() {
  // 内部変数がprivateなので判定用メソッド
  return player != null && getPlayerPower();
}

// getPlayerPower() を Player に作ると便利（getter）
boolean getPlayerPower() {
  // 直接アクセスできない場合は player 内に public メソッド用意
  return player != null && playerIsPowered(); // 仮メソッド
}

void keyPressed() {
  switch (key) {
    case 'w': player.direction = "up"; break;
    case 's': player.direction = "down"; break;
    case 'a': player.direction = "left"; break;
    case 'd': player.direction = "right"; break;
  }
}
