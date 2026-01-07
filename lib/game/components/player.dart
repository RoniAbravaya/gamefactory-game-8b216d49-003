import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  double _speed = 200.0;
  double _jumpForce = -300.0;
  double _gravity = 1000.0;
  bool _isJumping = false;
  Vector2 _velocity = Vector2.zero();
  int _health = 3;
  bool _isInvulnerable = false;
  final double _invulnerabilityTime = 2.0;
  double _invulnerabilityTimer = 0.0;

  Player() {
    addHitbox(HitboxRectangle());
  }

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2.all(48),
      ),
    );
    size = Vector2.all(48);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _handleMovement(dt);
    _handleGravity(dt);
    _handleInvulnerability(dt);
    position += _velocity * dt;
    _checkBounds();
  }

  void _handleMovement(double dt) {
    if (_isJumping) {
      _velocity.y += _gravity * dt;
    }
  }

  void _handleGravity(double dt) {
    if (!isOnGround()) {
      _velocity.y += _gravity * dt;
    } else {
      _velocity.y = 0;
      _isJumping = false;
    }
  }

  void jump() {
    if (!_isJumping) {
      _velocity.y = _jumpForce;
      _isJumping = true;
    }
  }

  bool isOnGround() {
    // This method should be implemented to check if the player is on the ground
    return position.y >= gameRef.size.y - size.y / 2;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Obstacle && !_isInvulnerable) {
      _takeDamage();
    } else if (other is Collectible) {
      // Handle collectible logic
    }
  }

  void _takeDamage() {
    _health -= 1;
    _isInvulnerable = true;
    _invulnerabilityTimer = _invulnerabilityTime;
    if (_health <= 0) {
      // Handle player death
    }
  }

  void _handleInvulnerability(double dt) {
    if (_isInvulnerable) {
      _invulnerabilityTimer -= dt;
      if (_invulnerabilityTimer <= 0) {
        _isInvulnerable = false;
      }
    }
  }

  void _checkBounds() {
    if (position.y > gameRef.size.y) {
      // Handle falling off the platforms
    }
  }
}

class Obstacle extends SpriteComponent with Collidable {
  Obstacle() {
    addHitbox(HitboxRectangle());
  }
}

class Collectible extends SpriteComponent with Collidable {
  Collectible() {
    addHitbox(HitboxCircle());
  }
}