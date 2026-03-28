import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../components/absorber.dart';
import '../components/drifting_ball.dart';

class AbsorbGame extends FlameGame with HasCollisionDetection {
  late Absorber player;
  int lives = 3;
  int score = 0;
  
  late Timer spawnTimer;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set up a timer to trigger every 2 seconds, repeating 
    spawnTimer = Timer(
      2.0, 
      onTick: spawnBall, 
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // The timer needs to be updated every frame to know when to fire
    spawnTimer.update(dt);
  }

  void cleanLevel(){
    // Clear any existing balls if this is a restart
    removeWhere((component) => component is DriftingBall || component is Absorber);
  }

  void startGame() {
    overlays.remove('MainMenu');
    
    // Clear any existing balls if this is a restart
    cleanLevel();

    lives = 3;
    score = 0;

    player = Absorber(
      position: size / 2, 
      radius: 30,
    );
    add(player);
    
    spawnTimer.start(); // Start spawning balls
  }

  void spawnBall() {
    // Randomly pick a position within the screen boundaries
    final randomX = random.nextDouble() * size.x;
    final randomY = random.nextDouble() * size.y;
    final position = Vector2(randomX, randomY);

    // Give the ball a random velocity between -100 and 100 on both axes
    final velocity = Vector2(
      (random.nextDouble() - 0.5) * 200,
      (random.nextDouble() - 0.5) * 200,
    );

    // 70% chance to spawn a GoodBall, 30% chance for a BadBall
    final isGood = random.nextDouble() > 0.3;

    if (isGood) {
      add(GoodBall(position: position, velocity: velocity));
    } else {
      add(BadBall(position: position, velocity: velocity));
    }

    // Progressively increase difficulty by slightly reducing the timer limit 
    if (spawnTimer.limit > 0.5) {
      // Decrease the wait time by 2% every time a ball spawns
      spawnTimer.limit *= 0.98; 
    }
  }
  void loseLife() {
    lives--;
    if (lives <= 0) {
      // Pause the game and show the Game Over screen (we will build this next)
      pauseEngine();
      overlays.add('GameOver');
    }
  }
}