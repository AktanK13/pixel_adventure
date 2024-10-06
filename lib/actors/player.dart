import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:game_flame/components/collisions_block.dart';
import 'package:game_flame/pixel_advanture.dart';
import 'package:game_flame/utils/utils.dart';

enum PlayerState {
  idle,
  running,
}

// SpriteAnimationGroupComponent это компонент анимации спрайта (спрайт - это изображение)
// HasGameRef это класс(событие) который даёт доступ к игре
// KeyboardHandler это класс(событие) который даёт доступ к клавиатуре
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdvanture>, KeyboardHandler {
  String character;
  Player({
    super.position,
    this.character = 'Ninja Frog',
  });

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  double stepTime = 0.05;
  double moveSpeed = 100;
  double horizontalMovement = 0;
  // скорости игрока
  Vector2 velocity = Vector2.zero();
  List<CollisionsBlock> collisionsBlocks = [];

  @override
  Future<void> onLoad() async {
    _loadAnimations();
    await super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && !isRightKeyPressed) {
      horizontalMovement = -1;
    } else if (isRightKeyPressed && !isLeftKeyPressed) {
      horizontalMovement = 1;
    } else {
      horizontalMovement = 0;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  // update это метод который даёт доступ к обновлению игровой логики каждый кадр
  // dt это delta time (время между кадрами) используется для стабильного обновления кадра
  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    super.update(dt);
  }

  void _loadAnimations() {
    idleAnimation = _spriteAnimation(state: 'Idle', amount: 11);
    runningAnimation = _spriteAnimation(state: 'Run', amount: 12);
    // список всех анимаций
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };
    // устанавливаем текущую анимацию
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation({
    required String state,
    required int amount,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    // если скорость игрока -1 (влево) и масштаб игрока 1 (не перевернут), то переворачиваем игрока
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) {
      playerState = PlayerState.running;
    } else {
      playerState = PlayerState.idle;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    // тут к позиции игрока прибавляется скорость игрока и умножается на dt (дельта время это время между кадрами)
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionsBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(block, this)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width;
          }
        }
      }
    }
  }
}
