import 'package:flame/game.dart';
import 'package:flutter/foundation.dart'; // Required for ValueNotifier
import '../components/absorber.dart';
import '../managers/ball_manager.dart';

enum GameState { menu, playing, gameOver }

class AbsorbGame extends FlameGame with HasCollisionDetection {
  late Absorber player;
  late BallManager ballManager;

  GameState currentGameState = GameState.menu;
  
  // 1. Wrap state in ValueNotifiers
  final ValueNotifier<int> lives = ValueNotifier<int>(3);
  final ValueNotifier<int> score = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    ballManager = BallManager();
    add(ballManager);

    
  }

  void startGame() {

    currentGameState = GameState.playing;
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    
    // 2. Reset the reactive state values
    lives.value = 3; 
    score.value = 0;
    
    removeWhere((component) => component is Absorber);
    ballManager.resetGame();

    player = Absorber(position: size / 2, radius: 30);
    add(player);
    
    // 3. Add the new Flutter HUD Overlay instead of the Flame component
    overlays.add('HudOverlay');
    
    ballManager.start();
  }

  void goToMenu() {
    // 1. Lock the state machine immediately
    currentGameState = GameState.menu;
    
    // 2. Clear the board of the player so they can't be hit
    if (player.isMounted) {
      player.removeFromParent();
    }
    
    // 3. Manage the UI
    overlays.remove('GameOver');
    overlays.remove('HudOverlay');
    overlays.add('MainMenu');
    
    // 4. Resume the engine. This allows the balls to keep bouncing 
    // in the background as a visual effect for the menu, but because 
    // of our FSM locks, they won't trigger any game logic.
    resumeEngine(); 
  }

  void loseLife() {
    if (currentGameState != GameState.playing) return;
    // 4. Update the value

    lives.value--; 
    if (lives.value <= 0) {
      pauseEngine();
      currentGameState = GameState.gameOver;

      overlays.remove('HudOverlay'); // Hide HUD on game over
      overlays.add('GameOver');
    }
  }
}