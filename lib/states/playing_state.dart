import 'game_state.dart';
import 'paused_state.dart';
import 'game_over_state.dart';
import '../scenes/gameplay_scene.dart';

class PlayingState extends GameState {
  final bool isResuming;

  // We use a flag to know if we are starting fresh or coming back from pause
  PlayingState(super.game, {this.isResuming = false});

  @override
  void enter() {
    game.clearAllOverlays();
    game.overlays.add('HudView');

    if (!isResuming) {
      game.clearActiveScene();
      game.playerData.reset();
      game.activeScene = GameplayScene();
      game.add(game.activeScene!);
    }

    game.resumeEngine();
  }

  @override
  void pause() {
    game.transitionTo(PausedState(game));
  }

  @override
  void gameOver() {
    game.transitionTo(GameOverState(game));
  }
}