import 'package:flame/components.dart';
import '../game/absorb_game.dart'; 

// Define what happens when the object hits the screen edge
enum BoundaryBehavior { bounce, clamp, none }

class PhysicsComponent extends Component with ParentIsA<PositionComponent>, HasGameReference<AbsorbGame> {
  Vector2 velocity = Vector2.zero();
  
  // Configuration Properties
  final double friction;
  final BoundaryBehavior boundaryBehavior;

  final double _lowestSpeedThreshold = 10.0; // Below this speed, we consider the object stopped

  PhysicsComponent({
    this.friction = 1.0, // Default to 1.0 (no friction)
    this.boundaryBehavior = BoundaryBehavior.bounce, // Default to bouncing
  });

  @override
  void update(double dt) {
    super.update(dt);

    // 1. Apply velocity and friction
    if (!velocity.isZero()) {
      parent.position += velocity * dt;
      
      // Only apply friction math if friction is actually active (< 1.0)
      if (friction < 1.0) {
        velocity.scale(friction);
        if (velocity.length < _lowestSpeedThreshold) {
          velocity.setZero();
        }
      }
    }

    // 2. Boundary Management (Runs every frame, even if velocity is 0, to handle manual dragging)
    final extents = parent.size / 2;

    if (boundaryBehavior == BoundaryBehavior.bounce) {
      if (parent.position.x - extents.x < 0 && velocity.x < 0) {
        velocity.x = -velocity.x;
      } else if (parent.position.x + extents.x > game.size.x && velocity.x > 0) {
        velocity.x = -velocity.x;
      }

      if (parent.position.y - extents.y < 0 && velocity.y < 0) {
        velocity.y = -velocity.y;
      } else if (parent.position.y + extents.y > game.size.y && velocity.y > 0) {
        velocity.y = -velocity.y;
      }
      
    } else if (boundaryBehavior == BoundaryBehavior.clamp) {
      final minimumPosition = extents;
      final maximumPosition = game.size - extents;
      parent.position.clamp(minimumPosition, maximumPosition);
    }
  }
}