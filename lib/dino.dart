import 'package:dino_game/constants.dart';
import 'package:dino_game/game.dart';
import 'package:dino_game/sprite.dart';
import 'package:flutter/widgets.dart';

List<Sprite> dino = [
  Sprite()
    ..imagePath = "assets/images/dino/dino_1.png"
    ..imageHeight = 94
    ..imageWidth = 88,
  Sprite()
    ..imagePath = "assets/images/dino/dino_2.png"
    ..imageHeight = 94
    ..imageWidth = 88,
  Sprite()
    ..imagePath = "assets/images/dino/dino_3.png"
    ..imageHeight = 94
    ..imageWidth = 88,
  Sprite()
    ..imagePath = "assets/images/dino/dino_4.png"
    ..imageHeight = 94
    ..imageWidth = 88,
  Sprite()
    ..imagePath = "assets/images/dino/dino_5.png"
    ..imageHeight = 94
    ..imageWidth = 88,
  Sprite()
    ..imagePath = "assets/images/dino/dino_6.png"
    ..imageHeight = 94
    ..imageWidth = 88,
];

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite = dino[0];
  double positionY = 0;
  double velocityY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 2 - currentSprite.imageHeight - positionY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastTime, Duration currentTime) {
    currentSprite = dino[(currentTime.inMilliseconds / 100).floor() % 2 + 2];

    double elapsedTimeSeconds = (currentTime - lastTime).inMilliseconds / 1000;
    // distance = speed * time
    positionY += velocityY * elapsedTimeSeconds;

    if (positionY <= 0) {
      // not move below the ground level
      positionY = 0;
      velocityY = 0;
      state = DinoState.running;
    } else {
      // if dino is still above the ground,  update velocity according to the gravity
      velocityY -= GRAVITY * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velocityY = 950; // initial jump velocity in pixels/second
    }
  }

  void die() {
    currentSprite = dino[5];
    state = DinoState.dead;
  }
}
