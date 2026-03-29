import 'package:flame/components.dart';
import '../components/absorber.dart';
import '../managers/ball_manager.dart';
import '../game/game.dart';

class GameplayScene extends Component with HasGameReference<AbsorbGame> {
  late Absorber player;
  late BallManager ballManager;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Initialize gameplay-specific managers
    ballManager = BallManager();
    add(ballManager);

    // Initialize the player
    player = Absorber(
      position: game.size / 2, 
      radius: 30,
    );
    add(player);
    
    // Start the spawner
    ballManager.start();
  }

  // Look how clean this is. No "if (playing)" checks needed!
  // If this scene is in the engine, the game is running.
  void loseLife() {
    game.playerData.lives.value--; 
    
    if (game.playerData.lives.value <= 0) {
      // Tell the main game class to handle the UI routing
      game.triggerGameOver();
    }
  }
}