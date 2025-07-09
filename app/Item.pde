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
      fill(type.equals("power") ? color(255, 100, 100) : color(255, 255, 0));
      noStroke();
      if (type.equals("power")) {
        ellipse(x, y, 16, 16);
      } else {
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
    float threshold = 12;
    return !isEaten && distance < threshold;
  }

  String getType() {
    return type;
  }

  boolean isEaten() {
    return isEaten;
  }
}
