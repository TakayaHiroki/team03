class Slime extends Character {
  boolean isAlive;
  
  Slime(int x, int y, int speed) {
    super(x, y, speed, "left");
    this.isAlive = true;
  }

  void changeDirection() {
    String[] dirs = {"up", "down", "left", "right"};
    direction = dirs[int(random(4))];
  }

  boolean checkCollisionWithPlayer(Player p) {
    return (this.x == p.x && this.y == p.y);
  }

  void paint() {
    if (isAlive) {
      fill(0, 255, 0);
      noStroke();
      ellipse(x, y, 20, 20);
    }
  }

  boolean isAlive() {
    return isAlive;
  }

  void setAlive(boolean alive) {
    this.isAlive = alive;
  }
}
