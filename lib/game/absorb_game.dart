import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/player_data.dart';
import '../scenes/gameplay_scene.dart';
import '../states/game_state.dart';
import '../states/main_menu_state.dart';

/// The main game class that manages the overall game state and lifecycle.
/// 
/// This class extends FlameGame and implements the State Pattern to handle
/// different game states (menu, playing, paused, game over). It acts as the
/// central context for state transitions and delegates game logic to the
/// current active state.
class AbsorbGame extends FlameGame with HasCollisionDetection {
  /// The current active game state (menu, playing, paused, or game over).
  GameState? _currentState;
  
  /// The currently active gameplay scene containing all game entities.
  GameplayScene? activeScene;
  
  /// Player data including score, lives, and persistent storage.
  final PlayerData playerData = PlayerData();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load player data from persistent storage
    await playerData.loadPlayerData();
    
    // Start the game in the main menu state
    transitionTo(MenuState(this));
  }

  /// Transitions the game to a new state.
  /// 
  /// This method handles the state transition by calling exit() on the
  /// current state, updating the current state reference, and calling
  /// enter() on the new state.
  void transitionTo(GameState newState) {
    _currentState?.exit();
    _currentState = newState;
    _currentState!.enter();
  }

  /// Clears all active overlays from the game screen.
  /// 
  /// This is useful when transitioning between states to ensure no
  /// previous overlays remain visible.
  void clearAllOverlays() {
    overlays.removeAll(overlays.activeOverlays.toList());
  }

  /// Clears and removes the active gameplay scene.
  /// 
  /// This method ensures proper cleanup of the scene graph when
  /// transitioning away from gameplay to prevent memory leaks.
  void clearActiveScene() {
    if (activeScene != null) {
      activeScene!.removeFromParent();
      activeScene = null;
    }
  }

  // --- Delegate OS events to the state ---
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    
    // Handle app lifecycle changes by delegating to the current state
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      
      // Delegate pause handling to the current state
      // Menu state ignores this, PlayingState handles it
      _currentState?.pause(); 
    }
  }

  // --- Public getters for the UI to trigger actions ---
  /// Triggers the play action in the current state.
  void play() => _currentState?.play();
  
  /// Triggers the pause action in the current state.
  void pause() => _currentState?.pause();
  
  /// Triggers the resume action in the current state.
  void resume() => _currentState?.resume();
  
  /// Triggers the menu action in the current state.
  void menu() => _currentState?.menu();
  
  /// Triggers the game over action in the current state.
  void gameOver() => _currentState?.gameOver();
}