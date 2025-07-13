class GameMap {
  char[][] mapData;
  int tileSize = 32;
  int offsetX, offsetY; // マップを中央に配置するためのオフセット

  // コンストラクタ：インスタンス作成時にマップを読み込む
  GameMap(String filename) {
    loadMapFromFile(filename);
    calculateOffset(); // オフセットを計算
  }

  // マップファイルを読み込み、二次元配列に変換する
  void loadMapFromFile(String filename) {
    String[] lines = loadStrings(filename);
    if (lines == null) {
      println("Error: map.txt could not be found or is empty.");
      exit(); // マップがなければプログラム終了
    }
    
    mapData = new char[lines.length][];
    for (int i = 0; i < lines.length; i++) {
      mapData[i] = lines[i].toCharArray();
    }
  }

  // マップを画面中央に配置するためのオフセットを計算
  void calculateOffset() {
    int mapWidth = mapData[0].length * tileSize;
    int mapHeight = mapData.length * tileSize;
    
    offsetX = (width - mapWidth) / 2;
    offsetY = (height - mapHeight) / 2;
  }

  // マップを描画する
  void draw() {
    for (int row = 0; row < mapData.length; row++) {
      for (int col = 0; col < mapData[row].length; col++) {
        int x = col * tileSize + offsetX;
        int y = row * tileSize + offsetY;
        char tile = mapData[row][col];

        switch (tile) {
          case '#': // 壁
            fill(100, 160, 255);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          case '.': // 道（アイテムは別途描画されるので何も描画しない）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          case 'F': // フルーツ（キャラクター生成時に処理されるので道として描画）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          case 'T': // 宝（キャラクター生成時に処理されるので道として描画）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          case 'S': // スライム（キャラクター生成時に処理されるので道として描画）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          case 'P': // プレイヤー（キャラクター生成時に処理されるので道として描画）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
          default: // 何も無い場所（道）
            fill(0);
            noStroke();
            rect(x, y, tileSize, tileSize);
            break;
        }
      }
    }
  }
}
