import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:game_flame/actors/player.dart';
import 'package:game_flame/components/collisions_block.dart';

// World это класс который создаёт мир (уровень) в игре
class Level extends World {
  // создаём уровень динамически с levelName и player
  final String levelName;
  final Player player;
  Level({
    required this.levelName,
    required this.player,
  });
  // создаём TiledComponent чтобы отрендерить карту из tmx файла (assets/tiles/)
  late TiledComponent level;
  late List<CollisionsBlock> collisionsBlocks = [];

  // onLoad это метод который даёт доступ к загрузке ваших игровых ассетов и компонентов когда уровень начинается
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    // начальная точка спавна на карте, ObjectGroup добовляется в Tiled
    final spownPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spownpoint');
    if (spownPointsLayer != null) {
      for (final spownPoint in spownPointsLayer.objects) {
        switch (spownPoint.class_) {
          // название дается в Tiled
          case 'Player':
            player.position = spownPoint.position;
            add(player);
            break;
          default:
        }
      }
    }
    
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionLayer != null) {
      for (final collisionObject in collisionLayer.objects) {
        switch (collisionObject.class_) {
          case 'Platform':
            final platform = CollisionsBlock(
              position: collisionObject.position,
              size: collisionObject.size,
              isPlatform: true,
            );
            collisionsBlocks.add(platform);
            add(platform);
            break;
          default:
            final blocks = CollisionsBlock(
              position: collisionObject.position,
              size: collisionObject.size,
            );
            collisionsBlocks.add(blocks);
            add(blocks);
            break;
        }
      }
    }
    player.collisionsBlocks = collisionsBlocks;
    return super.onLoad();
  }
}
