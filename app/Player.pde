import java.awt.Color;
import java.awt.Graphics;

public class Player extends Character {
    private int score;
    private boolean isPowered;
    private int powerTimer;

    public Player(int x, int y, int speed) {
        super(x, y, speed, "right");
        this.score = 0;
        this.isPowered = false;
        this.powerTimer = 0;
    }

    public void eatItem(Item item) {
        item.eat();
        if (item.getType().equals("dot")) {
            score += 10;
        } else if (item.getType().equals("power")) {
            isPowered = true;
            powerTimer = 300; // 例：5秒分（60FPS前提）
        }
    }

    public void updatePowerState() {
        if (isPowered) {
            powerTimer--;
            if (powerTimer <= 0) {
                isPowered = false;
            }
        }
    }

    @Override
    public void draw(Graphics g) {
        g.setColor(Color.YELLOW);
        g.fillArc(x, y, 20, 20, 45, 270); // パックマンの口
    }

    public boolean checkCollisionWithSlime(Slime s) {
        return (this.x == s.x && this.y == s.y);
    }

    // getter/setterは必要に応じて追加
}
