bool checkCollision(block, player) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (fixX < blockX + blockWidth &&
      fixX + playerWidth > blockX &&
      playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
