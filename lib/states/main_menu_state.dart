import 'game_state.dart';
import 'playing_state.dart';

class MenuState extends GameState {
  MenuState(super.game);

  @override
  void enter() {
    // 1. Destroy the scene if it exists
    game.clearActiveScene();
    
    // 2. Route UI
    game.clearAllOverlays();
    game.overlays.add('MainMenuView');
    
    // 3. Keep game running for background effects
    game.resume();
  }

  @override
  void play() {
    // Only from the menu can we start a fresh game
    game.transitionTo(PlayingState(game));
  }
}