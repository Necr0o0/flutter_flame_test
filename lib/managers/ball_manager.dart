import 'dart:math';
import 'package:flame/components.dart';
import '../components/drifting_ball.dart';
import '../game/game.dart';

class BallManager extends Component with HasGameReference<AbsorbGame> {
  // We maintain our lists as contiguous memory blocks
  final List<GoodBall> _goodPool = [];
  final List<BadBall> _badPool = [];
  
  late Timer _spawnTimer;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Pre-allocate the initial heap to prevent garbage collection spikes
    for (int i = 0; i < 40; i++) {
      _goodPool.add(GoodBall());
      _badPool.add(BadBall());
    }
    
    _spawnTimer = Timer(1.0, onTick: _spawnBall, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // The state machine gatekeeper
    if (game.currentGameState == GameState.playing) {
      _spawnTimer.update(dt);
    }
  }

  void start() {
    _spawnTimer.limit = 1.0; 
    _spawnTimer.reset();
    _spawnTimer.start();
  }

  void resetGame() {
    _spawnTimer.stop();
    
    // Deterministic cleanup: We check 'parent != null' to ensure we only
    // queue removal for balls that are actually living in the component tree.
    for (var ball in _goodPool) {
      if (ball.parent != null) ball.removeFromParent();
    }
    for (var ball in _badPool) {
      if (ball.parent != null) ball.removeFromParent();
    }
  }

  void _spawnBall() {
    final isGood = _random.nextDouble() > 0.3;
    final ball = _getAvailableBall(isGood);

    // Reinitialize physics state
    ball.position = Vector2(
      _random.nextDouble() * game.size.x, 
      _random.nextDouble() * game.size.y
    );
    ball.velocity = Vector2(
      (_random.nextDouble() - 0.5) * 200, 
      (_random.nextDouble() - 0.5) * 200
    );
    
    // Add it to the game tree (this instantly assigns ball.parent)
    add(ball);

    // Exponential decay of the timer limit to increase difficulty
    if (_spawnTimer.limit > 0.3) {
      _spawnTimer.limit *= 0.95;
    }
  }

  DriftingBall _getAvailableBall(bool isGood) {
    if (isGood) {
      try {
        // SYNCHRONOUS CHECK: If parent is null, it is definitively detached.
        // We also check !ball.isRemoving to ensure we don't grab a ball 
        // that was eaten by the player a millisecond ago and is awaiting garbage collection.
        return _goodPool.firstWhere((ball) => ball.parent == null && !ball.isRemoving);
      } catch (e) {
        // Dynamic Allocation Fallback
        final newBall = GoodBall();
        _goodPool.add(newBall);
        return newBall;
      }
    } else {
      try {
        return _badPool.firstWhere((ball) => ball.parent == null && !ball.isRemoving);
      } catch (e) {
        final newBall = BadBall();
        _badPool.add(newBall);
        return newBall;
      }
    }
  }
}