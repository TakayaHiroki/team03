char[][] loadMap(String filename) {
  ArrayList<char[]> lines = new ArrayList<char[]>();

  BufferedReader br = createReader(filename);  // Processing の createReader を使用
  String line = null;

  try {
    while ((line = br.readLine()) != null) {
      lines.add(line.toCharArray());
    }
    br.close();
  } catch (IOException e) {
    e.printStackTrace();
  }

  char[][] map = new char[lines.size()][];
  for (int i = 0; i < lines.size(); i++) {
    map[i] = lines.get(i);
  }

  return map;
}
