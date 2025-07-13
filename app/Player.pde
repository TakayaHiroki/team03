class Player extends Character {

  Player(int x, int y, int speed) {
    super(x, y, speed);
  }

  @Override
  void paint() {
    imageMode(CENTER);
    image(playerImage,x,y,20,20);
  }
}
