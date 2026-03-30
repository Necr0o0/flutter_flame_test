import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../game/absorb_game.dart';
import 'ball_entity.dart';
import '../scenes/gameplay_scene.dart'; // Import your new scene
import '../components/physics2D_component.dart';

class AbsorberEntity extends CircleComponent with DragCallbacks, HasGameReference<AbsorbGame>, CollisionCallbacks {
  
  late final PhysicsComponent physics;

  AbsorberEntity({required super.position, required super.radius}) : 
  super(anchor: Anchor.center, paint: Paint()..color = Colors.blueAccent) {
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
    physics.velocity.setZero(); // Stop momentum while dragging
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    physics.velocity = event.velocity; // Pass the flick velocity to physics
  }
  

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is GoodBallEntity) {
      other.removeFromParent();
      game.playerData.score.value += 1; 
      
      radius += 1.5; 
      children.whereType<CircleHitbox>().first.radius = radius; 
      
    } else if (other is BadBallEntity) {
      other.removeFromParent();
     if (parent is GameplayScene) {
        final scene = parent as GameplayScene;
        scene.loseLife();
      }
    }
  }
}