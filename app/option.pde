GameMap map = new GameMap("map.txt");

//  描画（draw() の中で直接描画）
void draw() {
  background(0);
  map.draw(playerImg, slimeImg, fruitImg, treasureImg);
}

//  GameMap クラス内で image(...) を使う（前回の回答参照））
void draw(PImage player, PImage slime, PImage fruit, PImage treasure) {
  // マップに応じて image(player, x, y, ...) のように描画
}


// 画像を読み込む方法
PImage playerImg, slimeImg, fruitImg, treasureImg;

void setup() {
  size(416, 288); // 32×13, 32×9
  playerImg = loadImage("player.png");
  slimeImg = loadImage("slime.png");
  fruitImg = loadImage("fruit.png");
  treasureImg = loadImage("treasure.png");
}
