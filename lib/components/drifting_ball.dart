import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class DriftingBall extends CircleComponent with HasGameRef, CollisionCallbacks {
  Vector2 velocity;

  DriftingBall({
    required super.position,
    required super.radius,
    required this.velocity,
    required Paint paint,
  }) : super(
          anchor: Anchor.center,
          paint: paint,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // The hitbox allows the engine to detect when balls touch
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Apply velocity to the position
    position += velocity * dt;

    // --- Wall Collision Logic ---
    // We check if the ball is hitting a wall AND if it's moving towards it.
    // This prevents the ball from getting stuck if it spawns slightly off-screen.
    
    // Left wall
    if (position.x - radius < 0 && velocity.x < 0) {
      velocity.x = -velocity.x;
    } 
    // Right wall
    else if (position.x + radius > gameRef.size.x && velocity.x > 0) {
      velocity.x = -velocity.x;
    }

    // Top wall
    if (position.y - radius < 0 && velocity.y < 0) {
      velocity.y = -velocity.y;
    } 
    // Bottom wall
    else if (position.y + radius > gameRef.size.y && velocity.y > 0) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is DriftingBall) {
      // --- The "Sticky Collision" Fix ---
      // Calculate the relative position and velocity between the two balls
      final deltaPosition = other.position - position;
      final deltaVelocity = other.velocity - velocity;
      
      // The dot product tells us the direction of the velocities relative to each other.
      // If it's negative, they are moving towards each other. If positive, they are already moving apart.
      if (deltaPosition.dot(deltaVelocity) < 0) {
        // Only process the swap from one ball's perspective to avoid double-swapping in the same frame
        if (hashCode < other.hashCode) {
          final temp = velocity.clone();
          velocity = other.velocity;
          other.velocity = temp;
        }
      }
    }
  }
}

// --- Specific Ball Types ---

class GoodBall extends DriftingBall {
  GoodBall({
    required super.position,
    required super.velocity,
  }) : super(
          radius: 15,
          paint: Paint()..color = Colors.greenAccent,
        );
}

class BadBall extends DriftingBall {
  BadBall({
    required super.position,
    required super.velocity,
  }) : super(
          radius: 20,
          paint: Paint()..color = Colors.redAccent,
        );
}