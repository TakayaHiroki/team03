abstract class Character {
  int x, y;
  int speed;
  String direction;

  Character(int x, int y, int speed, String direction) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.direction = direction;
  }

  void move() {
    switch (direction) {
      case "up":    y -= speed; break;
      case "down":  y += speed; break;
      case "left":  x -= speed; break;
      case "right": x += speed; break;
    }
  }

  abstract void paint();
}
