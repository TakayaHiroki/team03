import java.awt.Graphics;

public abstract class Character {
    protected int x;
    protected int y;
    protected int speed;
    protected String direction; // "up", "down", "left", "right"

    public Character(int x, int y, int speed, String direction) {
        this.x = x;
        this.y = y;
        this.speed = speed;
        this.direction = direction;
    }

    public void move() {
        switch (direction) {
            case "up": y -= speed; break;
            case "down": y += speed; break;
            case "left": x -= speed; break;
            case "right": x += speed; break;
        }
    }

    public abstract void draw(Graphics g); // 描画は各子クラスで定義
}
