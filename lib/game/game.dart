import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import '../scenes/gameplay_scene.dart';

enum GameState { menu, playing, gameOver }

class AbsorbGame extends FlameGame with HasCollisionDetection {
  GameState currentGameState = GameState.menu;

  final ValueNotifier<int> lives = ValueNotifier<int>(3);
  final ValueNotifier<int> score = ValueNotifier<int>(0);

  // We keep a reference to the active scene so we can destroy it easily
  GameplayScene? _activeScene;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Start the app in the Main Menu state
    goToMenu();
  }

  void startGame() {
    currentGameState = GameState.playing;
    
    // Clean up UI
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('HudOverlay');
    
    // Reset global data
    lives.value = 3; 
    score.value = 0;
    
    // If a scene exists (e.g., from a quick restart), destroy it
    if (_activeScene != null && _activeScene!.parent != null) {
      _activeScene!.removeFromParent();
    }

    // CREATE AND LOAD THE NEW SCENE
    _activeScene = GameplayScene();
    add(_activeScene!);
    
    resumeEngine(); 
  }

  void triggerGameOver() {
    currentGameState = GameState.gameOver;
    
    // Freeze the engine so the final frame stays on screen
    pauseEngine();
    
    overlays.remove('HudOverlay'); 
    overlays.add('GameOver');
  }

  void goToMenu() {
    currentGameState = GameState.menu;
    
    // DESTROY THE ENTIRE GAMEPLAY SCENE
    // This instantly kills the player, the spawner, and the update loops.
    if (_activeScene != null && _activeScene!.parent != null) {
      _activeScene!.removeFromParent();
      _activeScene = null;
    }
    
    overlays.remove('GameOver');
    overlays.remove('HudOverlay');
    overlays.add('MainMenu');
    
    resumeEngine(); 
  }
}