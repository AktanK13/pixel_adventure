import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/actors/player.dart';
import 'package:game_flame/levels/level.dart';

// FlameGame это класс который даёт доступ к компонентам Flame
// HasKeyboardHandlerComponents это класс(событие) который даёт доступ к клавиатуре
// DragCallbacks это класс(событие) который даёт доступ к событиям перетаскивания
class PixelAdvanture extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {
  // backgroundColor это метод который даёт доступ к установке цвета фона и удалению черных линий
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  //CameraComponent это класс который даёт доступ к камере, она необходима для добавления камеры
  late final CameraComponent cam;
  // Player это класс который создаёт игрока
  Player player = Player(character: 'Mask Dude');
  // JoystickComponent это класс который даёт доступ к джойстику
  late JoystickComponent joystick;
  bool showJoystick = false;

  // onLoad это метод который даёт доступ к загрузке ваших игровых ассетов и компонентов когда уровень начинается
  @override
  FutureOr<void> onLoad() async {
    // загружаем все изображения в кэш
    await images.loadAllImages();
    // добавляем уровень в игру
    final world = Level(levelName: 'level_02', player: player);
    // добавляем камеру в игру с фиксированным разрешением
    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    // устанавливаем камеру в верхний левый угол
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // можно не передавать dt потому что он уже есть в методе движении игрока
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  // добавляем джойстик в игру
  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 2,
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
