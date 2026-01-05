import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:test6_platformer_03/player.dart';
import 'package:test6_platformer_03/obstacle.dart';
import 'package:test6_platformer_03/collectible.dart';

/// The main game scene that handles level setup, game logic, and UI.
class GameScene extends FlameGame with TapDetector {
  /// The player character.
  late Player player;

  /// The list of obstacles in the current level.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles in the current level.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// Loads the level and sets up the game scene.
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the level data
    await _loadLevel();

    // Add the player to the scene
    player = Player()..position = Vector2(100, 500);
    add(player);

    // Add the obstacles to the scene
    for (final obstacle in _obstacles) {
      add(obstacle);
    }

    // Add the collectibles to the scene
    for (final collectible in _collectibles) {
      add(collectible);
    }
  }

  /// Handles the game loop logic, including win/lose conditions and score updates.
  @override
  void update(double dt) {
    super.update(dt);

    // Check for player collisions with obstacles or falling off the screen
    if (player.isOutOfBounds(camera.viewport) || _hasCollision(player, _obstacles)) {
      _handleLose();
    }

    // Check for player collisions with collectibles
    for (final collectible in _collectibles) {
      if (_hasCollision(player, [collectible])) {
        _collectible.collected = true;
        _score += 100;
      }
    }

    // Remove collected collectibles from the scene
    _collectibles.removeWhere((c) => c.collected);
  }

  /// Handles a tap input, which should make the player jump.
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    player.jump();
  }

  /// Pauses the game.
  void pause() {
    pauseEngine();
  }

  /// Resumes the game.
  void resume() {
    resumeEngine();
  }

  /// Loads the level data and sets up the obstacles and collectibles.
  Future<void> _loadLevel() async {
    // Load level data from a file or database
    final levelData = await _loadLevelData();

    // Spawn obstacles
    for (final obstacleData in levelData.obstacles) {
      final obstacle = Obstacle(obstacleData.position, obstacleData.size);
      _obstacles.add(obstacle);
    }

    // Spawn collectibles
    for (final collectibleData in levelData.collectibles) {
      final collectible = Collectible(collectibleData.position);
      _collectibles.add(collectible);
    }
  }

  /// Loads the level data from a file or database.
  Future<LevelData> _loadLevelData() async {
    try {
      // Load level data from a file or database
      return LevelData(
        obstacles: [
          ObstacleData(position: Vector2(200, 500), size: Vector2(50, 50)),
          ObstacleData(position: Vector2(400, 400), size: Vector2(75, 75)),
        ],
        collectibles: [
          CollectibleData(position: Vector2(300, 550)),
          CollectibleData(position: Vector2(500, 450)),
        ],
      );
    } catch (e) {
      // Handle any errors that occur while loading the level data
      throw Exception('Failed to load level data: $e');
    }
  }

  /// Checks if the given entity collides with any of the provided obstacles.
  bool _hasCollision(PositionComponent entity, List<Obstacle> obstacles) {
    for (final obstacle in obstacles) {
      if (entity.rectFromComponents.overlaps(obstacle.rectFromComponents)) {
        return true;
      }
    }
    return false;
  }

  /// Handles the player losing the game.
  void _handleLose() {
    // Implement game over logic, such as displaying a game over screen
    print('Game over! Score: $_score');
  }
}

/// Represents the data for a single obstacle in the level.
class ObstacleData {
  final Vector2 position;
  final Vector2 size;

  ObstacleData({
    required this.position,
    required this.size,
  });
}

/// Represents the data for a single collectible in the level.
class CollectibleData {
  final Vector2 position;

  CollectibleData({
    required this.position,
  });
}

/// Represents the data for a single level.
class LevelData {
  final List<ObstacleData> obstacles;
  final List<CollectibleData> collectibles;

  LevelData({
    required this.obstacles,
    required this.collectibles,
  });
}