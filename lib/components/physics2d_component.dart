import 'package:flame/components.dart';
import '../game/absorb_game.dart'; 

/// Defines how an object should behave when it hits the screen boundaries.
/// 
/// - bounce: The object bounces off the edges with velocity reversal
/// - clamp: The object is clamped to stay within screen bounds
/// - none: No boundary behavior (object can move off-screen)
enum BoundaryBehavior { bounce, clamp, none }

/// A reusable physics component that handles movement, friction, and boundary constraints.
/// 
/// This component can be attached to any PositionComponent to provide physics
/// behavior including velocity-based movement, friction simulation, and screen
/// boundary management. It's designed to be highly configurable and reusable
/// across different game entities.
class PhysicsComponent extends Component with ParentIsA<PositionComponent>, HasGameReference<AbsorbGame> {
  /// The current velocity of the object (pixels per second).
  Vector2 velocity = Vector2.zero();
  
  /// The friction coefficient applied to the velocity each frame.
  /// 
  /// Values less than 1.0 create friction (slowing down over time),
  /// while 1.0 means no friction and values greater than 1.0 create acceleration.
  final double friction;
  
  /// How the object should behave when it hits screen boundaries.
  final BoundaryBehavior boundaryBehavior;

  /// The minimum speed threshold below which velocity is considered zero.
  /// 
  /// This prevents objects from moving indefinitely at very slow speeds
  /// due to floating-point precision issues.
  final double _lowestSpeedThreshold = 10.0;

  /// Creates a new PhysicsComponent with the specified configuration.
  /// 
  /// [friction]: The friction coefficient (default: 1.0 for no friction)
  /// [boundaryBehavior]: How to handle screen boundaries (default: bounce)
  PhysicsComponent({
    this.friction = 1.0, // Default to 1.0 (no friction)
    this.boundaryBehavior = BoundaryBehavior.bounce, // Default to bouncing
  });

  @override
  void update(double dt) {
    super.update(dt);

    // Apply velocity-based movement and friction
    if (!velocity.isZero()) {
      // Move the parent component based on velocity and time delta
      parent.position += velocity * dt;
      
      // Only apply friction if friction coefficient is less than 1.0
      if (friction < 1.0) {
        velocity.scale(friction);
        
        // Stop movement when velocity drops below threshold
        if (velocity.length < _lowestSpeedThreshold) {
          velocity.setZero();
        }
      }
    }

    // Handle boundary management (runs every frame for manual dragging support)
    final extents = parent.size / 2;

    // Boundary behavior logic
    if (boundaryBehavior == BoundaryBehavior.bounce) {
      // Bounce off left/right edges
      if (parent.position.x - extents.x < 0 && velocity.x < 0) {
        velocity.x = -velocity.x;
      } else if (parent.position.x + extents.x > game.size.x && velocity.x > 0) {
        velocity.x = -velocity.x;
      }

      // Bounce off top/bottom edges
      if (parent.position.y - extents.y < 0 && velocity.y < 0) {
        velocity.y = -velocity.y;
      } else if (parent.position.y + extents.y > game.size.y && velocity.y > 0) {
        velocity.y = -velocity.y;
      }
      
    } else if (boundaryBehavior == BoundaryBehavior.clamp) {
      // Clamp position to stay within screen bounds
      final minimumPosition = extents;
      final maximumPosition = game.size - extents;
      parent.position.clamp(minimumPosition, maximumPosition);
    }
  }
}