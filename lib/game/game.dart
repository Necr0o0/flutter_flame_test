import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../scenes/gameplay_scene.dart';

enum GameState { menu, playing, gameOver, paused }

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

@override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);

    // If the game is currently being played and the user leaves the app/tab
    if (currentGameState == GameState.playing) {
      if (state == AppLifecycleState.paused || 
          state == AppLifecycleState.inactive || 
          state == AppLifecycleState.hidden) {
        
        triggerPause();
      }
    }
  }

  void triggerPause() {
    currentGameState = GameState.paused;
    pauseEngine(); // Freeze the physics and timers
    overlays.add('PauseMenu'); // Show the pause screen
  }

  void resumePlaying() {
    currentGameState = GameState.playing;
    overlays.remove('PauseMenu');
    resumeEngine(); // Unfreeze the engine
  }

}