import '../game/absorb_game.dart';

/// Abstract base class for all game states in the Absorb game.
/// 
/// This class implements the State Pattern, providing a common interface for
/// different game states (menu, playing, paused, game over). Each state can
/// handle its own lifecycle and respond to user actions appropriately.
abstract class GameState {
  /// Reference to the main game instance for state manipulation.
  /// 
  /// Each state holds a reference to the AbsorbGame instance so it can
  /// manipulate the game context, transition to other states, and access
  /// shared resources like the player data and scene management.
  final AbsorbGame game;

  /// Creates a new game state with a reference to the main game.
  GameState(this.game);

  /// Lifecycle hook called when entering this state.
  /// 
  /// This method is called when the state machine transitions to this state.
  /// Subclasses should override this to perform initialization tasks.
  void enter() {}

  /// Lifecycle hook called when exiting this state.
  /// 
  /// This method is called when the state machine transitions away from this
  /// state. Subclasses should override this to perform cleanup tasks.
  void exit() {}

  /// Handles the play action request.
  /// 
  /// This method is called when the user requests to start or resume gameplay.
  /// Default implementation does nothing; concrete states should override as needed.
  void play() {}

  /// Handles the pause action request.
  /// 
  /// This method is called when the user requests to pause the game or when
  /// the app lifecycle changes. Default implementation does nothing.
  void pause() {}

  /// Handles the resume action request.
  /// 
  /// This method is called when the user requests to resume gameplay after
  /// a pause. Default implementation does nothing.
  void resume() {}

  /// Handles the menu action request.
  /// 
  /// This method is called when the user requests to return to the main menu.
  /// Default implementation does nothing.
  void menu() {}

  /// Handles the game over action request.
  /// 
  /// This method is called when the game ends (e.g., player loses all lives).
  /// Default implementation does nothing.
  void gameOver() {}
}