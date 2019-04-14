import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyGame());

class MyGame extends StatefulWidget {
  MyGameState createState() => MyGameState();
}

class MyGameState extends State<MyGame> with TickerProviderStateMixin {
  Animation<double> bulletAnimation, targetAnimation;
  AnimationController bulletController, targetController;
  double bulletYPoint = 0,
      targetYPoint = 0,
      bulletXPoint = 0,
      targetXPoint = 0,
      x = 0;
  int count = 1;
  int endGame = 0;
  var rand = Random();
  static const Color white = Colors.white;
  Widget box = Container(height: 30, width: 30, color: white);
  void init() {
    bulletController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    accelerometerEvents.listen((AccelerometerEvent event) {
      if ((-x * 5 - event.x).abs() > 0.1) {
        if (event.x < -5)
          stream.addValue(1);
        else if (event.x > 5)
          stream.addValue(-1);
        else {
          x = -double.parse(event.x.toStringAsFixed(1)) / 5;
          stream.addValue(x);
        }
      }
    });
    initialize();
  }

  void initialize() {
    bulletYPoint = 1;
    targetYPoint = -1;
    bulletAnimation = Tween(begin: 1.0, end: -1.0).animate(bulletController)
      ..addStatusListener((event) {
        if (event == AnimationStatus.completed) {
          bulletController.reset();
          bulletController.forward();
        }
      })
      ..addListener(() {
        stream.bulletStream.add(bulletAnimation.value);
      });
    bulletController.forward();
    targetController = AnimationController(
        duration:
            Duration(milliseconds: count < 45 ? 10000 - (count * 200) : 1000),
        vsync: this);
    targetAnimation = Tween(begin: -1.0, end: 1.0).animate(targetController)
      ..addListener(() {
        setState(() {
          targetYPoint = targetAnimation.value;
        });
        if (targetAnimation.value == 1) {
          endGame = 2;
        }
      });
    targetController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (bulletXPoint > targetXPoint - 0.15 &&
        bulletXPoint < targetXPoint + 0.15) {
      if (bulletYPoint < targetYPoint) {
        setState(() {
          count++;
          if (rand.nextBool())
            targetXPoint = rand.nextDouble();
          else
            targetXPoint = -rand.nextDouble();
        });
        bulletController.reset();
        initialize();
      }
    }

    if (endGame == 1 && bulletAnimation.value == 1) {
      bulletXPoint = x;
    }

    return MaterialApp(
      home: Stack(children: <Widget>[
        FlareActor("assets/background.flr",
            alignment: Alignment.center,
            fit: BoxFit.fitWidth,
            animation: "rotate"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: endGame != 1
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 160,
                        width: 60,
                        child: FlareActor("assets/bullet.flr",
                            // alignment: Alignment(bulletXPoint, stream.data),
                            fit: BoxFit.fitHeight,
                            animation: "float"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Box Shooter",
                          style: TextStyle(color: white, fontSize: 62),
                        ),
                      ),
                      Text(
                        endGame == 2 ? "Score:${count - 1}" : "",
                        style: TextStyle(color: white, fontSize: 62),
                      ),
                      GestureDetector(
                        onTap: () {
                          init();
                          endGame = 1;
                          count = 1;
                          initialize();
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          child: (endGame == 2)
                              ? Icon(
                                  Icons.refresh,
                                  color: white,
                                  size: 62,
                                )
                              : FlareActor("assets/play_button.flr",
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  animation: "animate"),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                        child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment(0.8, -0.9),
                        child: Text(
                          "${count - 1}",
                          style: TextStyle(fontSize: 32, color: white),
                        ),
                      ),
                      StreamBuilder(
                        initialData: 1.0,
                        stream: stream.bulletStreamGet,
                        builder: (context, stream) {
                          bulletYPoint = stream.data;
                          return Align(
                              alignment: Alignment(bulletXPoint, stream.data),
                              child:
                                  //  Icon(Icons.arrow_upward)
                                  Container(
                                width: 15,
                                child: FlareActor("assets/bullet.flr",
                                    alignment:
                                        Alignment(bulletXPoint, stream.data),
                                    fit: BoxFit.fitWidth,
                                    animation: "float"),
                              ));
                        },
                      ),
                      Align(
                          alignment: Alignment(targetXPoint, targetYPoint),
                          child: Container(
                            width: 40,
                            child: FlareActor("assets/target.flr",
                                alignment:
                                    Alignment(targetXPoint, targetYPoint),
                                fit: BoxFit.fitWidth,
                                animation: "Preview2"),
                          ))
                    ])),
                    StreamBuilder(
                      initialData: 0.0,
                      stream: stream.shooterStreamGet,
                      builder: (ctx, stream) {
                        x = stream.data;
                        return Align(
                          alignment: Alignment(stream.data, 1),
                          child: Container(
                            width: 60,
                            height: 20,
                            child: FlareActor("assets/earth.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.fitWidth,
                                animation: "Preview2"),
                          ),
                          //box
                        );
                      },
                    )
                  ],
                ),
        ),
      ]),
    );
  }
}

class Streams {
  StreamController shooterStreamController =
          StreamController<double>.broadcast(),
      bulletStreamController = StreamController<double>.broadcast();

  Sink get shooterStream => shooterStreamController.sink;
  Sink get bulletStream => bulletStreamController.sink;

  Stream<double> get shooterStreamGet => shooterStreamController.stream;
  Stream<double> get bulletStreamGet => bulletStreamController.stream;

  addValue(double value) {
    shooterStream.add(value);
  }

  addBulletValue(double value) {
    bulletStream.add(value);
  }

  voiddispose() {
    shooterStreamController.close();
    bulletStreamController.close();
  }
}

Streams stream = Streams();
