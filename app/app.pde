Player player;
ArrayList<Slime> slimes;
ArrayList<Item> items;

int slimeMoveTimer = 0;

void setup() {
  size(640, 480);
  frameRate(60);

  player = new Player(100, 100, 2);

  slimes = new ArrayList<Slime>();
  slimes.add(new Slime(300, 100, 2));
  slimes.add(new Slime(300, 300, 2));

  items = new ArrayList<Item>();
  for (int i = 60; i < width; i += 60) {
    for (int j = 60; j < height; j += 60) {
      String type = random(1) < 0.1 ? "power" : "dot";
      items.add(new Item(i, j, type));
    }
  }
}

void draw() {
  background(0);

  for (Item item : items) {
    item.paint();
    if (item.isCollisionWithPlayer(player)) {
      player.eatItem(item);
    }
  }

  slimeMoveTimer++;
  for (Slime slime : slimes) {
    if (slime.isAlive()) {
      if (slimeMoveTimer % 60 == 0) {
        slime.changeDirection();
      }
      slime.move();
      slime.paint();

      if (slime.checkCollisionWithPlayer(player)) {
        if (player.isPowered()) {
          slime.setAlive(false);
          println("Slime defeated!");
        } else {
          println("Game Over");
          noLoop();
        }
      }
    }
  }

  player.updatePowerState();
  player.move();
  player.paint();

  boolean allEaten = true;
  for (Item item : items) {
    if (!item.isEaten()) {
      allEaten = false;
      break;
    }
  }
  if (allEaten) {
    println("Stage Clear!");
    noLoop();
  }
}

void keyPressed() {
  switch (key) {
    case 'w': player.direction = "up"; break;
    case 's': player.direction = "down"; break;
    case 'a': player.direction = "left"; break;
    case 'd': player.direction = "right"; break;
  }
}
