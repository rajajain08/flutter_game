import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyGame());

class MyGame extends StatefulWidget {
  MyGameState createState() => MyGameState();
}

class MyGameState extends State<MyGame> with TickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> targetAnimation;
  AnimationController controller;
  AnimationController targetController;
  double bulletPosition;
  double targetPosition;
  double bulletX = 0;
  double targetX = 0;
  bool endGame = false;
  var rng = new Random();
  @override
  void initState() {
    super.initState();
    bulletPosition = 1;
    targetPosition = -1;
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 1.0, end: -1.0).animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });
    animation.addListener(() {
      setState(() {
        bulletPosition = animation.value;
        // print(animation.value);
      });
    });

    targetController = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
    targetAnimation = Tween(begin: -1.0, end: 1.0).animate(targetController);
    targetController.forward();
    targetAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          endGame = true;
        });
      }
    });
    targetAnimation.addListener(() {
      setState(() {
        targetPosition = targetAnimation.value;
      });
    });
  }

  double x = 0, y = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (bulletX > targetX - 0.15 && bulletX < targetX + 0.15) {
      if (bulletPosition > targetPosition - 0.15 &&
          bulletPosition < targetPosition) {
        setState(() {
          count++;
          if (rng.nextBool())
            targetX = rng.nextDouble();
          else
            targetX = -rng.nextDouble();
          targetController.reset();
          targetController.forward();
          controller.reset();
          controller.forward();
        });
      }
    }
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = -event.x / 5;
        y = event.y / 5;
      });
    });
    if (animation.value == 1) {
      bulletX = x;
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text("$count", style: TextStyle(fontSize: 32)),
                        )),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment(bulletX, bulletPosition),
                      child: Bullet(),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment(targetX, targetPosition),
                      child: Target(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(x, 1),
              child: Container(
                height: 30,
                width: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 10,
      color: Colors.red,
    );
  }
}

class Target extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      color: Colors.red,
    );
  }
}
