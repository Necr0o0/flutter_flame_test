import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'ball_entity.dart';
import '../components/physics2d_component.dart';

// 1. REMOVED: HasGameReference and GameplayScene imports!
class AbsorberEntity extends CircleComponent with DragCallbacks, CollisionCallbacks {
  late final PhysicsComponent physics;
  double maxRadius = 120.0;
  double growthPerGoodBall = 1.5;

  // 2. Define the "Signals" (Callbacks)
  final VoidCallback? onGoodBallEaten;
  final VoidCallback? onBadBallEaten;

  AbsorberEntity({
    required super.position, 
    required super.radius,
    this.onGoodBallEaten, // Optional callback
    this.onBadBallEaten,  // Optional callback
  }) : super(anchor: Anchor.center, paint: Paint()..color = Colors.blueAccent) {
    physics = PhysicsComponent(
      friction: 0.92, 
      boundaryBehavior: BoundaryBehavior.clamp,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(physics);
    add(CircleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
    physics.velocity.setZero(); 
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    physics.velocity = event.velocity; 
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is GoodBallEntity) {
      other.removeFromParent();
      
      // 3. Emit the signal!
      onGoodBallEaten?.call(); 
      
      // Internal visual logic stays here
      if (radius < maxRadius){
        radius += growthPerGoodBall; 
        children.whereType<CircleHitbox>().first.radius = radius; 
      }
      
    } else if (other is BadBallEntity) {
      other.removeFromParent();
      
      // 3. Emit the signal!
      onBadBallEaten?.call();
    }
  }
}