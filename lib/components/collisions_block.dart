import 'package:flame/components.dart';

class CollisionsBlock extends PositionComponent {
  bool isPlatform;
  CollisionsBlock({
    super.position,
    super.size,
    this.isPlatform = false,
  }) {
    debugMode = true;
  }
}
