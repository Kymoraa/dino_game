import 'package:dino_game/constants.dart';
import 'package:dino_game/game.dart';
import 'package:dino_game/sprite.dart';
import 'package:flutter/widgets.dart';

Sprite groundSprite = Sprite()
  ..imagePath = "assets/images/general/ground.png"
  ..imageWidth = 2399
  ..imageHeight = 24;

class Ground extends GameObject {
  final Offset location;

  Ground({required this.location});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (location.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
      screenSize.height / 2 - groundSprite.imageHeight,
      groundSprite.imageWidth.toDouble(),
      groundSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(groundSprite.imagePath);
  }
}
