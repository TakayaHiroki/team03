class Item {
  int x, y;
  boolean isEaten;
  String type;

  Item(int x, int y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.isEaten = false;
  }

  void paint() {
    if (!isEaten) {
      pushMatrix();
      noStroke();
      
      if (type.equals("fruit")) {
        fill(255, 100, 100); // 赤色のフルーツ
        ellipse(x, y, 16, 16);
      } else if (type.equals("treasure")) {
        fill(255, 255, 0); // 黄色の宝物
        ellipse(x, y, 20, 20);
      } else if (type.equals("dot")) {
        fill(255, 255, 255); // 白色のドット
        ellipse(x, y, 4, 4);
      } else {
        fill(255, 255, 0); // デフォルト色
        ellipse(x, y, 8, 8);
      }
      
      popMatrix();
    }
  }

  void eat() {
    isEaten = true;
  }

  boolean isCollisionWithPlayer(Player p) {
    float distance = dist(x, y, p.x, p.y);
    float threshold = 15; // 衝突判定の範囲を少し大きくする
    return !isEaten && distance < threshold;
  }

  String getType() {
    return type;
  }

  boolean isEaten() {
    return isEaten;
  }
}
