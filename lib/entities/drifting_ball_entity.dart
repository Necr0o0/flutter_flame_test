import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class DriftingBall extends CircleComponent with HasGameReference, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();

  DriftingBall({
    required super.radius,
    required Paint paint,
  }) : super(
          anchor: Anchor.center,
          paint: paint,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Wall collision logic
    if (position.x - radius < 0 && velocity.x < 0)
    {
      velocity.x = -velocity.x;
    // ignore: curly_braces_in_flow_control_structures
    } else if (position.x + radius > game.size.x && velocity.x > 0)
    {
      velocity.x = -velocity.x;
    }
    if (position.y - radius < 0 && velocity.y < 0)
    {
      velocity.y = -velocity.y;
    } 
    else if (position.y + radius > game.size.y && velocity.y > 0)
    {
      velocity.y = -velocity.y;
    } 
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is DriftingBall) {
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

class GoodBall extends DriftingBall {
  GoodBall() : super(radius: 15, paint: Paint()..color = Colors.greenAccent);
}

class BadBall extends DriftingBall {
  BadBall() : super(radius: 20, paint: Paint()..color = Colors.redAccent);
}