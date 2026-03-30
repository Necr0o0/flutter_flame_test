import '../game/absorb_game.dart';

abstract class GameState {
  // Every state holds a reference to the Engine (Context) so it can manipulate it
  final AbsorbGame game;

  GameState(this.game);

  // Lifecycle hooks triggered during a transition
  void enter() {}
  void exit() {}

  // The actions that the UI or OS can request
  // By default, they do nothing unless a concrete state overrides them
  void play() {}
  void pause() {}
  void resume() {}
  void menu() {}
  void gameOver() {}
}