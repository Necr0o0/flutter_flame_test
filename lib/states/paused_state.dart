import 'game_state.dart';
import 'playing_state.dart';
import 'main_menu_state.dart';

class PausedState extends GameState {
  PausedState(super.game);

  @override
  void enter() {
    game.pause();
    game.pauseEngine();
    // Safely overlay the pause menu on top of the HUD
    if (!game.overlays.isActive('PauseMenuView')) {
      game.overlays.add('PauseMenuView');
    }
  }

  @override
  void exit() {
    game.resumeEngine();
    game.overlays.remove('PauseMenuView');
  }

  @override
  void resume() {
    game.transitionTo(PlayingState(game, isResuming: true));
  }

  @override
  void menu() {
    game.transitionTo(MenuState(game));
  }
}