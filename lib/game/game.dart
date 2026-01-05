import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:test6_platformer_03/components/collectible.dart';
import 'package:test6_platformer_03/components/obstacle.dart';
import 'package:test6_platformer_03/components/player.dart';
import 'package:test6_platformer_03/services/analytics_service.dart';
import 'package:test6_platformer_03/services/ads_service.dart';
import 'package:test6_platformer_03/services/storage_service.dart';

/// The main game class for the 'test6-platformer-03' game.
class Test6Platformer03Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The list of obstacles in the current level.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles in the current level.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service.
  final AdsService _adsService = AdsService();

  /// The storage service.
  final StorageService _storageService = StorageService();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadLevel(1);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  /// Loads the specified level.
  void _loadLevel(int levelNumber) {
    try {
      // Load level data from storage or other source
      _loadLevelData(levelNumber);

      // Create player, obstacles, and collectibles
      _createPlayer();
      _createObstacles();
      _createCollectibles();

      // Reset game state
      _gameState = GameState.playing;
      _score = 0;

      // Notify analytics service
      _analyticsService.logLevelStart(levelNumber);
    } catch (e) {
      // Handle errors gracefully
      print('Error loading level $levelNumber: $e');
    }
  }

  /// Creates the player component.
  void _createPlayer() {
    _player = Player(position: Vector2(100, 400));
    add(_player);
  }

  /// Creates the obstacles for the current level.
  void _createObstacles() {
    // Create obstacles based on level data
    for (final obstacleData in _levelData.obstacles) {
      final obstacle = Obstacle(position: obstacleData.position);
      _obstacles.add(obstacle);
      add(obstacle);
    }
  }

  /// Creates the collectibles for the current level.
  void _createCollectibles() {
    // Create collectibles based on level data
    for (final collectibleData in _levelData.collectibles) {
      final collectible = Collectible(position: collectibleData.position);
      _collectibles.add(collectible);
      add(collectible);
    }
  }

  /// Handles collision detection between the player and obstacles/collectibles.
  @override
  void update(double dt) {
    super.update(dt);

    // Check for collisions
    _checkCollisions();

    // Update game state based on player status
    _updateGameState();
  }

  /// Checks for collisions between the player and obstacles/collectibles.
  void _checkCollisions() {
    // Check for collisions with obstacles
    for (final obstacle in _obstacles) {
      if (_player.overlaps(obstacle)) {
        _handleObstacleCollision();
        break;
      }
    }

    // Check for collisions with collectibles
    for (final collectible in _collectibles) {
      if (_player.overlaps(collectible)) {
        _handleCollectibleCollection(collectible);
      }
    }
  }

  /// Handles the collision between the player and an obstacle.
  void _handleObstacleCollision() {
    // Notify analytics service
    _analyticsService.logLevelFail();

    // Update game state
    _gameState = GameState.gameOver;

    // Show game over UI
    _showGameOverUI();
  }

  /// Handles the collection of a collectible by the player.
  void _handleCollectibleCollection(Collectible collectible) {
    // Remove the collectible from the level
    _collectibles.remove(collectible);
    remove(collectible);

    // Update the score
    _score += 100;

    // Notify analytics service
    _analyticsService.logCollectibleCollected();
  }

  /// Updates the game state based on the player's status.
  void _updateGameState() {
    if (_gameState == GameState.playing) {
      if (_player.isDead) {
        _handleObstacleCollision();
      } else if (_isLevelComplete()) {
        _handleLevelComplete();
      }
    }
  }

  /// Checks if the current level is complete.
  bool _isLevelComplete() {
    return _collectibles.isEmpty;
  }

  /// Handles the completion of the current level.
  void _handleLevelComplete() {
    // Notify analytics service
    _analyticsService.logLevelComplete();

    // Update game state
    _gameState = GameState.levelComplete;

    // Show level complete UI
    _showLevelCompleteUI();

    // Load the next level
    _loadLevel(_currentLevel + 1);
  }

  /// Shows the game over UI.
  void _showGameOverUI() {
    // Implement game over UI logic
  }

  /// Shows the level complete UI.
  void _showLevelCompleteUI() {
    // Implement level complete UI logic
  }
}

/// The current game state.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}