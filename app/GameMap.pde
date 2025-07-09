PImage playerImage, slimeImage, fruitImage, treasureImage;
char[][] mapData;
int tileSize = 32;

void setup() {
  size(32 * 13, 32 * 9); // map.txt に合わせたサイズ
  loadImages();
  mapData = loadMap("map.txt");
}

void draw() {
  background(0);
  drawMap();
}

void loadImages() {
  playerImage = loadImage("player.png");
  slimeImage = loadImage("slime.png");
  fruitImage = loadImage("fruit.png");
  treasureImage = loadImage("treasure.png");
}

char[][] loadMap(String filename) {
  String[] lines = loadStrings(filename);
  char[][] map = new char[lines.length][];
  for (int i = 0; i < lines.length; i++) {
    map[i] = lines[i].toCharArray();
  }
  return map;
}

void drawMap() {
  for (int row = 0; row < mapData.length; row++) {
    for (int col = 0; col < mapData[0].length; col++) {
      int x = col * tileSize;
      int y = row * tileSize;
      char tile = mapData[row][col];

      switch (tile) {
        case '#':
          fill(100, 160, 255);
          rect(x, y, tileSize, tileSize);
          break;
        case '.':
          fill(0);
          rect(x, y, tileSize, tileSize);
          fill(255);
          ellipse(x + tileSize / 2, y + tileSize / 2, tileSize / 5, tileSize / 5);
          break;
        case 'F':
          image(fruitImage, x, y, tileSize, tileSize);
          break;
        case 'T':
          image(treasureImage, x, y, tileSize, tileSize);
          break;
        case 'S':
          image(slimeImage, x, y, tileSize, tileSize);
          break;
        case 'P':
          image(playerImage, x, y, tileSize, tileSize);
          break;
        default:
          fill(0);
          rect(x, y, tileSize, tileSize);
          break;
      }
    }
  }
}
