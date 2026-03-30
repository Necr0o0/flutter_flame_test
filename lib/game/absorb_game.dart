import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../data/player_data.dart';
import '../scenes/gameplay_scene.dart';
import '../states/game_state.dart';
import '../states/main_menu_state.dart';

class AbsorbGame extends FlameGame with HasCollisionDetection {
  // 1. The Current State
  GameState? _currentState;
  
  GameplayScene? activeScene;
  final PlayerData playerData = PlayerData();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await playerData.loadPlayerData();

    transitionTo( MenuState(this));
  }

  // The State Machine Transition Hub
  void transitionTo(GameState newState) {
    _currentState?.exit();
    _currentState = newState;
    _currentState!.enter();
  }

  void clearAllOverlays() {
    overlays.removeAll(overlays.activeOverlays.toList());
  }

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
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      
      // If we are playing, the PlayingState will handle this.
      // If we are in the Menu, the MenuState simply ignores it!
      _currentState?.pause(); 
    }
  }

  // --- Public getters for the UI to trigger actions ---
  void play() => _currentState?.play();
  void pause() => _currentState?.pause();
  void resume() => _currentState?.resume();
  void menu() => _currentState?.menu();
  void gameOver() => _currentState?.gameOver();
}