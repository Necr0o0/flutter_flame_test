import 'package:flame/components.dart';
import '../entities/absorber_entity.dart';
import '../managers/ball_manager.dart';
import '../game/absorb_game.dart';

class GameplayScene extends Component with HasGameReference<AbsorbGame> {
  late AbsorberEntity player;
  late BallManager ballManager;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    ballManager = BallManager();
    add(ballManager);

    // Subscribe to the player's signals right here in the constructor
    player = AbsorberEntity(
      position: game.size / 2, 
      radius: 30,
      onGoodBallEaten: () {
        // Scene handles the data routing
        game.playerData.score.value += 1;
      },
      onBadBallEaten: () {
        // Scene handles the damage routing
        loseLife();
      }
    );
    
    add(player);
    ballManager.start();
  }

  void loseLife() {
    game.playerData.lives.value--; 
    
    if (game.playerData.lives.value <= 0) {
      game.gameOver();
    }
  }
}