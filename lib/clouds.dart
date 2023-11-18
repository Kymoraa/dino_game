import 'package:dino_game/constants.dart';
import 'package:dino_game/game.dart';
import 'package:dino_game/sprite.dart';
import 'package:flutter/widgets.dart';

Sprite cloudSprite = Sprite()
  ..imagePath = "assets/images/general/cloud.png"
  ..imageWidth = 92
  ..imageHeight = 27;

class Cloud extends GameObject {
  final Offset location;
  Cloud({required this.location});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (location.dx - runDistance) * WORLD_TO_PIXEL_RATIO / 5,
      screenSize.height / 5 - cloudSprite.imageHeight - location.dy,
      cloudSprite.imageWidth.toDouble(),
      cloudSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudSprite.imagePath);
  }
}
