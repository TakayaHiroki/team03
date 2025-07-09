class Player extends Character {
  int score;
  boolean isPowered;
  int powerTimer;

  Player(int x, int y, int speed) {
    super(x, y, speed, "right");
    this.score = 0;
    this.isPowered = false;
    this.powerTimer = 0;
  }

  void eatItem(Item item) {
    item.eat();
    if (item.getType().equals("dot")) {
      score += 10;
    } else if (item.getType().equals("power")) {
      isPowered = true;
      powerTimer = 300;
    }
  }

  void updatePowerState() {
    if (isPowered) {
      powerTimer--;
      if (powerTimer <= 0) {
        isPowered = false;
      }
    }
  }

  void paint() {
    fill(255, 255, 0);
    noStroke();
    arc(x, y, 20, 20, radians(45), radians(315));
  }

  boolean checkCollisionWithSlime(Slime s) {
    return (this.x == s.x && this.y == s.y);
  }

  boolean isPowered() {
    return isPowered;
  }
}
