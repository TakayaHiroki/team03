class Player extends Character {

  Player(int x, int y, int speed) {
    super(x, y, speed);
  }

  @Override
  void paint() {
    fill(255, 255, 0); // 黄色
    noStroke();
    ellipse(x, y, 20, 20); // 簡単な円で描画
  }
}
