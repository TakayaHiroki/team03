import java.awt.Color;
import java.awt.Graphics;
import java.util.Random;

public class Slime extends Character {
    private boolean isAlive;
    private Random rand = new Random();

    public Slime(int x, int y, int speed) {
        super(x, y, speed, "left");
        this.isAlive = true;
    }

    public void changeDirection() {
        String[] dirs = {"up", "down", "left", "right"};
        this.direction = dirs[rand.nextInt(4)];
    }

    public boolean checkCollisionWithPlayer(Player p) {
        return (this.x == p.x && this.y == p.y);
    }

    @Override
    public void draw(Graphics g) {
        g.setColor(Color.GREEN);
        g.fillOval(x, y, 20, 20);
    }

    public boolean isAlive() {
        return isAlive;
    }

    public void setAlive(boolean alive) {
        this.isAlive = alive;
    }
}
