import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_flame/pixel_advanture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // делаем так чтобы устройство было готово в ландшафтном режиме перед началом игры
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixelAdvanture game = PixelAdvanture();
  // добавляем kDebugMode чтобы убедиться что игра запускается в режиме отладки
  runApp(GameWidget(game: kDebugMode ? PixelAdvanture() : game));
}
