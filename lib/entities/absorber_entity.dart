import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'ball_entity.dart';
import '../components/physics2d_component.dart';

/// The main player-controlled entity in the Absorb game.
/// 
/// This entity represents the player's character that can be dragged around
/// the screen to absorb balls. It grows when absorbing good balls and shrinks
/// when absorbing bad balls. The entity uses a signal-based architecture to
/// communicate with the game scene without direct references.
class AbsorberEntity extends CircleComponent with DragCallbacks, CollisionCallbacks {
  /// The physics component that handles movement and boundary constraints.
  late final PhysicsComponent physics;
  
  /// The maximum radius the absorber can grow to.
  double maxRadius = 120.0;
  
  /// The amount the radius increases when absorbing a good ball.
  double growthPerGoodBall = 1.5;

  /// Callback signal emitted when a good ball is absorbed.
  /// 
  /// This allows the game scene to handle scoring and game logic without
  /// the entity needing direct references to the scene.
  final VoidCallback? onGoodBallEaten;
  
  /// Callback signal emitted when a bad ball is absorbed.
  /// 
  /// This allows the game scene to handle life deduction and game logic
  /// without tight coupling between components.
  final VoidCallback? onBadBallEaten;

  /// Creates a new AbsorberEntity with the specified position and radius.
  /// 
  /// The absorber is initialized with a blue color and physics properties
  /// that allow for smooth dragging and boundary clamping.
  AbsorberEntity({
    required super.position, 
    required super.radius,
    this.onGoodBallEaten, // Optional callback for good ball absorption
    this.onBadBallEaten,  // Optional callback for bad ball absorption
  }) : super(anchor: Anchor.center, paint: Paint()..color = Colors.blueAccent) {
    physics = PhysicsComponent(
      friction: 0.92, // Smooth deceleration when dragging stops
      boundaryBehavior: BoundaryBehavior.clamp, // Stay within screen bounds
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Add physics and collision detection components
    add(physics);
    add(CircleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Update position based on drag movement
    position += event.localDelta;
    
    // Stop physics simulation during manual dragging
    physics.velocity.setZero(); 
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    
    // Apply fling velocity when drag ends for smooth motion
    physics.velocity = event.velocity; 
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Handle collision with good balls
    if (other is GoodBallEntity) {
      other.removeFromParent();
      
      // Emit signal for good ball absorption
      onGoodBallEaten?.call(); 
      
      // Grow the absorber if not at maximum size
      if (radius < maxRadius){
        radius += growthPerGoodBall; 
        children.whereType<CircleHitbox>().first.radius = radius; 
      }
      
    // Handle collision with bad balls
    } else if (other is BadBallEntity) {
      other.removeFromParent();
      
      // Emit signal for bad ball absorption
      onBadBallEaten?.call();
    }
  }
}