import 'package:flame/components.dart';
import 'package:flame/audio.dart';
import 'package:flutter/material.dart';

/// A collectible item in the platformer game.
class Collectible extends SpriteComponent with CollisionCallbacks {
  final double _scoreValue;
  final Audio _collectSound;
  final Vector2 _initialPosition;

  /// Creates a new Collectible instance.
  ///
  /// [sprite] The sprite to be used for the collectible.
  /// [position] The initial position of the collectible.
  /// [scoreValue] The score value awarded for collecting this item.
  /// [collectSound] The audio to be played when the collectible is collected.
  Collectible({
    required Sprite sprite,
    required Vector2 position,
    required double scoreValue,
    required Audio collectSound,
  })  : _scoreValue = scoreValue,
        _collectSound = collectSound,
        _initialPosition = position {
    this.sprite = sprite;
    this.position = position;
    size = Vector2.all(32.0); // Adjust the size as needed
  }

  @override
  void onMount() {
    super.onMount();
    priority = 1; // Ensure the collectible is rendered on top of other components
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) { // Assuming the player is represented by a 'Player' component
      _collectSound.play(); // Play the collect sound
      removeFromParent(); // Remove the collectible from the game world
      other.score += _scoreValue; // Increase the player's score
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Add any optional animation logic here, such as spinning or floating
  }
}