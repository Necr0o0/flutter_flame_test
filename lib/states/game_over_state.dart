import 'game_state.dart';
import 'playing_state.dart';
import 'main_menu_state.dart';

class GameOverState extends GameState {
  GameOverState(super.game);

  @override
  void enter() {
    game.pauseEngine();
    
    // Fire and forget the high score save
    game.playerData.checkAndSaveHighScore();
    
    game.clearAllOverlays();
    game.overlays.add('GameOverView');
  }

  @override
  void play() {
    game.transitionTo(PlayingState(game));
  }

  @override
  void menu() {
    game.clearAllOverlays();
    game.clearActiveScene();
    game.resumeEngine();

    game.transitionTo(MenuState(game));
  }
}