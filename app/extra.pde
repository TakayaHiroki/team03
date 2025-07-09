int score = 0;
int totalTime = 60;
int startTime;
boolean gameStarted = false;
boolean gameOver = false;

int life = 3;  // ライフは3つ

void setup() {
  size(640, 480);
  textAlign(CENTER, CENTER);
  textSize(20);
}

void draw() {
  background(0);

  if (!gameStarted) {
    fill(255);
    textSize(32);
    if (gameOver) {
      text("Game Over", width / 2, height / 2 - 30);
      textSize(24);
      text("Press SPACE to Restart", width / 2, height / 2 + 20);
    } else {
      text("Press SPACE to Start", width / 2, height / 2);
    }
    return;
  }

  // 経過時間と残り時間
  int elapsedTime = (millis() - startTime) / 1000;
  int remainingTime = max(0, totalTime - elapsedTime);

  // マップ描画
  drawMap();

  // スコア表示
  fill(255, 255, 0);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Score: " + score, 10, 20);

  // 残り時間表示
  fill(255);
  text("Time: " + remainingTime, width / 2 - 40, 20);

  // ライフ表示（ハート）
  fill(255, 0, 0);
  text("Life: " + getHearts(life), width - 180, 20);

  // 敵との当たり判定（ここにあなたのロジックを入れてください）
  simulateEnemyCollision(); // テスト用。実際は敵の位置とプレイヤーの距離などで判定

  // ライフ0または時間切れでゲームオーバー
  if (life <= 0 || remainingTime <= 0) {
    gameOver = true;
    gameStarted = false;
  }
}

// キー入力でスタート・リスタート
void keyPressed() {
  if (key == ' ' && !gameStarted) {
    restartGame();
  }
}

// ゲームリスタート処理
void restartGame() {
  score = 0;
  life = 3;
  startTime = millis();
  gameStarted = true;
  gameOver = false;
}

// ハートアイコンの生成
String getHearts(int n) {
  String hearts = "";
  for (int i = 0; i < n; i++) {
    hearts += "❤️";
  }
  return hearts;
}

// スコア加算（例：アイテム取得時に呼ぶ）
void eatFruit() {
  score += 10;
}

// マップ描画（仮）
void drawMap() {
  fill(50);
  rect(50, 100, 540, 300);
}

// テスト用：ランダムに敵に当たるシミュレーション
void simulateEnemyCollision() {
  if (frameCount % 180 == 0 && life > 0) {  // 3秒に1回ランダムでヒット
    life--;
    println("Enemy hit! Life: " + life);
  }
}
