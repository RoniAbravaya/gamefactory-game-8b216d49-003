import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the platformer game.
class MenuScene extends Component {
  final GameRef gameRef;
  late final TextComponent _titleText;
  late final ButtonComponent _playButton;
  late final ButtonComponent _levelSelectButton;
  late final ButtonComponent _settingsButton;
  late final ParallaxComponent _backgroundAnimation;

  MenuScene(this.gameRef) {
    _setupComponents();
  }

  void _setupComponents() {
    _titleText = TextComponent(
      text: 'test6-platformer-03',
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.2),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    _playButton = ButtonComponent(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.4),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Play',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the game scene
      },
    );

    _levelSelectButton = ButtonComponent(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.5),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Level Select',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the level select scene
      },
    );

    _settingsButton = ButtonComponent(
      position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.6),
      size: Vector2(200, 60),
      anchor: Anchor.topCenter,
      child: TextComponent(
        text: 'Settings',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the settings scene
      },
    );

    _backgroundAnimation = ParallaxComponent(
      parallaxOptions: ParallaxOptions(
        baseVelocity: Vector2(50, 0),
        velocityMultiplierDelta: Vector2(1.2, 1.0),
      ),
      children: [
        SpriteComponent(
          sprite: Sprite('background_layer1.png'),
          size: gameRef.size,
        ),
        SpriteComponent(
          sprite: Sprite('background_layer2.png'),
          size: gameRef.size,
        ),
        SpriteComponent(
          sprite: Sprite('background_layer3.png'),
          size: gameRef.size,
        ),
      ],
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_titleText);
    add(_playButton);
    add(_levelSelectButton);
    add(_settingsButton);
    add(_backgroundAnimation);
  }
}