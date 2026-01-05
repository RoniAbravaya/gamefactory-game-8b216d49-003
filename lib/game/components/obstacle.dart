import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

/// Represents an obstacle in the platformer game.
class Obstacle extends PositionComponent with HasHitboxes, Collidable {
  final Sprite _sprite;
  final double _speed;
  final double _damage;

  /// Creates a new instance of the [Obstacle] component.
  ///
  /// [position]: The initial position of the obstacle.
  /// [size]: The size of the obstacle.
  /// [sprite]: The sprite to be used for the visual representation of the obstacle.
  /// [speed]: The speed at which the obstacle moves.
  /// [damage]: The amount of damage the obstacle deals upon collision.
  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite,
    required double speed,
    required double damage,
  })  : _sprite = sprite,
        _speed = speed,
        _damage = damage {
    this.position = position;
    this.size = size;
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    // Respawn the obstacle if it goes off-screen
    if (position.x < -size.x) {
      position.x = size.x + 800;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    // Handle collision with the player or other game objects
    // and deal damage if necessary
  }
}