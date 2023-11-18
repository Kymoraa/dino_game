import 'dart:math';

import 'package:dino_game/cactus.dart';
import 'package:dino_game/clouds.dart';
import 'package:dino_game/ground.dart';
import 'package:dino_game/dino.dart';
import 'package:dino_game/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(title: 'Dino Game'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runDistance = 0;
  double runVelocity = 30;

  late AnimationController animationController;
  Duration lastUpdateCall = const Duration();
  List<Cactus> cacti = [Cactus(location: const Offset(200, 0))];
  List<Ground> ground = [
    Ground(location: const Offset(0, 0)),
    Ground(location: Offset(groundSprite.imageWidth / 10, 0)),
  ];

  List<Cloud> clouds = [
    Cloud(location: const Offset(100, 20)),
    Cloud(location: const Offset(200, 10)),
    Cloud(location: const Offset(200, -100)),
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(days: 99));
    animationController.addListener(_update);
    animationController.forward();
  }

  _update() {
    // update the object over the course of the game
    dino.update(lastUpdateCall, animationController.lastElapsedDuration!);

    // get the time elapsed in seconds by subtracting the last time the update call was made from the animation controller elapsed duration
    double elapsedTimeSeconds = (animationController.lastElapsedDuration! - lastUpdateCall).inMilliseconds / 1000;
    runDistance += runVelocity * elapsedTimeSeconds;

    // collision detection
    Size screenSize = MediaQuery.of(context).size;
    Rect dinoRect = dino.getRect(screenSize, runDistance).deflate(5); // deflate to take care of the white spaces
    for (Cactus cactus in cacti) {
      Rect cactusRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(cactusRect.deflate(5))) {
        // _die();
      }

      if (cactusRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(Cactus(location: Offset(runDistance + Random().nextInt(100) + 50, 0)));
        });
      }
    }

    for (Ground groundlet in ground) {
      if (groundlet.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          ground.remove(groundlet);
          ground.add(Ground(location: Offset(ground.last.location.dx + groundSprite.imageWidth / 10, 0)));
        });
      }
    }

    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(Cloud(location: Offset(clouds.last.location.dx + Random().nextInt(100) + 50, Random().nextInt(40) - 20.0)));
        });
      }
    }
    lastUpdateCall = animationController.lastElapsedDuration!;
  }

  _die() {
    setState(() {
      animationController.stop();
      dino.die();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      // [...clouds, ...ground, ...cacti, dino]) {
      children.add(
        AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dino.jump();
        },
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}
