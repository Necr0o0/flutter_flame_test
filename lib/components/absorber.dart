import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../game/game.dart';
import 'drifting_ball.dart';

class Absorber extends CircleComponent with DragCallbacks, HasGameRef<AbsorbGame>, CollisionCallbacks {
  
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
    // Add the player's hitbox
    add(CircleHitbox());
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // Move the absorber exactly where the user drags their finger
    position += event.localDelta;
    super.onDragUpdate(event);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is GoodBall) {
      // 1. Remove the good ball from the game
      other.removeFromParent();
      
      // 2. Increase score
      gameRef.score += 1;
      
      // 3. Make the absorber grow slightly
      radius += 1.5; 
      
      // Update the actual physical hitbox to match the new visual radius
      children.whereType<CircleHitbox>().first.radius = radius; 
      
    } else if (other is BadBall) {
      // 1. Remove the bad ball from the game
      other.removeFromParent();
      
      // 2. Trigger the damage logic in the main game class
      gameRef.loseLife();
    }
  }
}