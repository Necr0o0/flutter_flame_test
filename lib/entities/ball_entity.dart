import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../components/physics2D_component.dart';

class BallEntity extends CircleComponent with CollisionCallbacks {
  // The Entity owns the physics component as a child
  late final PhysicsComponent physics;

  BallEntity({
    required super.radius,
    required Paint paint,
  }) : super(
          anchor: Anchor.center,
          paint: paint,
        ) {
    // Instantiate the component
    physics = PhysicsComponent();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Add the logic component and the physical hitbox to the Flame engine tree
    add(physics);
    add(CircleHitbox());
  }

  // Expose getters and setters so the BallManager and Collision logic can still 
  // easily read/write the velocity without needing to write `ball.physics.velocity` everywhere.
  Vector2 get velocity => physics.velocity;
  set velocity(Vector2 v) => physics.velocity = v;

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is BallEntity) {
      // Sticky Collision Fix
      final deltaPosition = other.position - position;
      final deltaVelocity = other.velocity - velocity;
      
      if (deltaPosition.dot(deltaVelocity) < 0) {
        if (hashCode < other.hashCode) {
          final temp = velocity.clone();
          velocity = other.velocity;
          other.velocity = temp;
        }
      }
    }
  }
}

// --- Specific Implementations ---

class GoodBallEntity extends BallEntity {
  GoodBallEntity() : super(radius: 15, paint: Paint()..color = Colors.greenAccent);
}

class BadBallEntity extends BallEntity {
  BadBallEntity() : super(radius: 20, paint: Paint()..color = Colors.redAccent);
}