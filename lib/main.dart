import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyGame(),
    );
  }
}

class MyGame extends StatefulWidget {
  MyGameState createState() => MyGameState();
}

class MyGameState extends State<MyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Align(
        alignment: Alignment(-0.2, 0),
        child: Container(
          height: 20,
          width: 20,
          color: Colors.red,
        ),
      ),
    );
  }
}
