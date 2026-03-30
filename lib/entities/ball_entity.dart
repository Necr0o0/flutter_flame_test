import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../components/physics2d_component.dart';

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
      // Calculate the vector between the two centers
      final deltaPosition = position - other.position;
      final distance = deltaPosition.length;
      final minDistance = radius + other.radius;

     
      // If they are overlapping, forcefully push them apart along the collision normal
      if (distance < minDistance && distance > 0) {
        final overlap = minDistance - distance;
        // Divide the overlap by 2 so they both push away equally
        final separationVector = (deltaPosition / distance) * (overlap / 2);
        
        position += separationVector;
        other.position -= separationVector;
      }

      //Only bounce if they are moving towards each other)
      final deltaVelocity = velocity - other.velocity;
      if (deltaPosition.dot(deltaVelocity) < 0) {
        // Simple mass-less elastic collision (velocity swap)
        final temp = velocity.clone();
        velocity = other.velocity;
        other.velocity = temp;
      }
    }
  }
}

class GoodBallEntity extends BallEntity {
  GoodBallEntity() : super(radius: 15, paint: Paint()..color = Colors.greenAccent);
}

class BadBallEntity extends BallEntity {
  BadBallEntity() : super(radius: 20, paint: Paint()..color = Colors.redAccent);
}