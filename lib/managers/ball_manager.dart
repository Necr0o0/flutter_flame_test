import 'dart:math';
import 'package:flame/components.dart';
import '../scenes/gameplay_scene.dart';
import '../entities/ball_entity.dart';
import '../game/absorb_game.dart';

/// Manages the spawning, pooling, and lifecycle of game balls.
/// 
/// This component implements a dynamic object pool pattern to efficiently
/// manage game balls (both good and bad) without creating garbage collection
/// spikes. It handles spawning balls at random positions, ensuring they don't
/// spawn too close to the player, and recycling balls when they're no longer
/// needed.
class BallManager extends Component with HasGameReference<AbsorbGame> {
  /// Pool of available good ball entities for reuse.
  final List<GoodBallEntity> _goodPool = [];
  
  /// Pool of available bad ball entities for reuse.
  final List<BadBallEntity> _badPool = [];
  
  /// Timer that controls the spawning frequency of balls.
  late Timer _spawnTimer;
  
  /// Random number generator for ball spawning logic.
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Pre-allocate initial pool to prevent garbage collection spikes
    for (int i = 0; i < 40; i++) {
      _goodPool.add(GoodBallEntity());
      _badPool.add(BadBallEntity());
    }
    
    // Initialize spawn timer with 1 second interval
    _spawnTimer = Timer(1.0, onTick: _spawnBall, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
  }

  /// Starts the ball spawning process.
  /// 
  /// This method resets the spawn timer and begins the spawning loop.
  void start() {
    _spawnTimer.limit = 1.0; 
    _spawnTimer.reset();
    _spawnTimer.start();
  }

  /// Resets the game by stopping spawning and removing all active balls.
  /// 
  /// This method ensures all balls are properly removed from the game tree
  /// and the spawn timer is stopped to prevent further spawning.
  void resetGame() {
    _spawnTimer.stop();
    
    // Remove all active balls from the game tree
    for (var ball in _goodPool) {
      if (ball.parent != null) ball.removeFromParent();
    }
    for (var ball in _badPool) {
      if (ball.parent != null) ball.removeFromParent();
    }
  }

  /// Spawns a new ball at a random safe position.
  /// 
  /// This method handles the logic for spawning either a good or bad ball,
  /// ensuring it spawns at a safe distance from the player, and adds it to
  /// the game tree with random velocity.
  void _spawnBall() {
    // Randomly determine if this should be a good or bad ball
    final isGood = _random.nextDouble() > 0.3;
    final ball = _getAvailableBall(isGood);

    Vector2 randomPosition = Vector2.zero();
    bool isSafe = false;

    // Get reference to the gameplay scene for player position
    final scene = parent as GameplayScene; 
    const double safeDistance = 150.0;

    // Find a safe spawn position that's not too close to the player
    while (!isSafe) {
      randomPosition = Vector2(
        _random.nextDouble() * game.size.x, 
        _random.nextDouble() * game.size.y,
      );
      
      // Check if this position is safe from the player
      if (randomPosition.distanceTo(scene.player.position) > safeDistance + scene.player.radius) {
        isSafe = true; // Found a safe spot!
      }
    }
    
    // Set ball position and velocity
    ball.position = randomPosition;
    ball.velocity = Vector2(
      (_random.nextDouble() - 0.5) * 200, 
      (_random.nextDouble() - 0.5) * 200
    );
    
    // Add ball to the game tree (this assigns ball.parent)
    add(ball);

    // Increase difficulty by decreasing spawn interval over time
    if (_spawnTimer.limit > 0.3) {
      _spawnTimer.limit *= 0.95;
    }
  }

  /// Gets an available ball from the pool or creates a new one if needed.
  /// 
  /// This method implements the object pooling pattern by first trying to
  /// find an available ball in the pool. If none are available, it creates
  /// a new ball and adds it to the pool.
  BallEntity _getAvailableBall(bool isGood) {
    if (isGood) {
      try {
        // Find a good ball that's not currently in use
        return _goodPool.firstWhere((ball) => ball.parent == null && !ball.isRemoving);
      } catch (e) {
        // Create new ball if pool is exhausted
        final newBall = GoodBallEntity();
        _goodPool.add(newBall);
        return newBall;
      }
    } else {
      try {
        // Find a bad ball that's not currently in use
        return _badPool.firstWhere((ball) => ball.parent == null && !ball.isRemoving);
      } catch (e) {
        // Create new ball if pool is exhausted
        final newBall = BadBallEntity();
        _badPool.add(newBall);
        return newBall;
      }
    }
  }
}