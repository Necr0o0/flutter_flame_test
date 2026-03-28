import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../game/game.dart';
import 'drifting_ball.dart';
import '../scenes/gameplay_scene.dart'; // Import your new scene

class Absorber extends CircleComponent with DragCallbacks, HasGameReference<AbsorbGame>, CollisionCallbacks {
  
  // 1. Add velocity and friction variables
  Vector2 velocity = Vector2.zero();
  final double friction = 0.92; // 1.0 is no friction, 0.0 is instant stop

  Absorber({
    required super.position,
    required super.radius,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = Colors.blueAccent, 
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 2. Apply momentum if the velocity is not zero
    if (!velocity.isZero()) {
      position += velocity * dt;
      
      // Apply friction to smoothly decelerate the absorber
      velocity.scale(friction);
      
      // Kill the velocity entirely if it gets too slow (avoids infinite micro-calculations)
      if (velocity.length < 10) {
        velocity.setZero();
      }
    }

    // 3. Prevent the absorber from flying off the screen!
    // We calculate the boundary using the radius so the edge of the circle hits the wall, not its center.
    final minimumPosition = Vector2.all(radius);
    final maximumPosition = game.size - Vector2.all(radius);
    position.clamp(minimumPosition, maximumPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
    // Zero out any existing momentum while the user is actively holding/dragging
    velocity.setZero(); 
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    // 4. Capture the exact swipe velocity when the user lifts their finger
    velocity = event.velocity; 
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is GoodBall) {
      other.removeFromParent();
      game.score.value += 1; 
      
      radius += 1.5; 
      children.whereType<CircleHitbox>().first.radius = radius; 
      
    } else if (other is BadBall) {
      other.removeFromParent();
     if (parent is GameplayScene) {
        final scene = parent as GameplayScene;
        scene.loseLife();
      }
    }
  }
}