import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent with TapDetector, CollisionCallbacks {
  /// The player's current health or lives.
  int _health = 3;

  /// The player's current score.
  int _score = 0;

  /// The player's current animation state.
  PlayerAnimationState _currentAnimationState = PlayerAnimationState.idle;

  /// Initializes the player component with the given position and size.
  Player(Vector2 position, Vector2 size) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's sprite sheet and create the animations
    final spriteSheet = await loadSpriteSheet();
    animations = {
      PlayerAnimationState.idle: spriteSheet.createAnimation(row: 0, columns: 4, stepTime: 0.2),
      PlayerAnimationState.moving: spriteSheet.createAnimation(row: 1, columns: 4, stepTime: 0.1),
      PlayerAnimationState.jumping: spriteSheet.createAnimation(row: 2, columns: 2, stepTime: 0.3),
    };

    // Set the initial animation state
    current = animations[_currentAnimationState]!;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position and animation based on user input
    handleInput(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Handle the player's jump input
    jump();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Handle collisions with other game objects
    if (other is Obstacle) {
      takeDamage();
    }
  }

  /// Handles the player's movement and animation based on user input.
  void handleInput(double dt) {
    // Implement the player's movement and animation logic here
    // based on the game's mechanics and controls
  }

  /// Causes the player to jump.
  void jump() {
    // Implement the player's jump logic here
    _currentAnimationState = PlayerAnimationState.jumping;
    current = animations[_currentAnimationState]!;
  }

  /// Reduces the player's health by 1.
  void takeDamage() {
    _health--;
    if (_health <= 0) {
      // The player has died, handle the game over logic
    }
  }

  /// Increases the player's score by the given amount.
  void addScore(int amount) {
    _score += amount;
  }

  /// Loads the player's sprite sheet.
  Future<SpriteSheet> loadSpriteSheet() async {
    // Load the player's sprite sheet and return it
    return SpriteSheet.fromImage(
      await images.load('player_spritesheet.png'),
      srcSize: Vector2(32, 32),
    );
  }
}

/// The possible animation states for the player.
enum PlayerAnimationState {
  idle,
  moving,
  jumping,
}