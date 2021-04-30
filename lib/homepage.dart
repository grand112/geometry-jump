import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geometry_jump/brick.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static double brickYaxis = 1;
  static double brickXaxis = -0.9;
  double time = 0;
  double height = 0;
  double initialHeight = brickYaxis;
  bool jumpStarted = false;
  bool firsRotate = true;
  double startRotatePos = 0;
  double endRotatePos = 0.5;
  AnimationController _rotationController;

  @override
  void initState() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void jump() {
    rotate();
    setState(() {
      time = 0;
      initialHeight = brickYaxis;
    });
  }

  void rotate() {
    if (firsRotate) {
      startRotatePos = 0;
      endRotatePos = 0.5;
      firsRotate = false;
    } else {
      startRotatePos = 0.5;
      endRotatePos = 1;
      firsRotate = true;
    }
    _rotationController.reset();
    _rotationController.forward();
  }

  void startJumping() {
    jumpStarted = true;
    rotate();
    Timer.periodic(
        Duration(
          milliseconds: 50,
        ), (timer) {
      time += 0.05;
      height = -2.9 * time * time + 2.6 * time;
      setState(() {
        brickYaxis = initialHeight - height;
      });
      if (brickYaxis > 1) {
        timer.cancel();
        jumpStarted = false;
        setState(() {
          time = 0;
          initialHeight = 1;
          brickYaxis = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              if (jumpStarted) {
                jump();
              } else {
                startJumping();
              }
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/background.png"),
                    fit: BoxFit.cover),
              ),
              alignment: Alignment(brickXaxis, brickYaxis),
              duration: Duration(
                milliseconds: 0,
              ),
              child: RotationTransition(
                child: Brick(),
                turns: Tween(begin: startRotatePos, end: endRotatePos)
                    .animate(_rotationController),
              ),
            ),
          ),
        ),
        Container(
          height: 5,
          color: Colors.black87,
        ),
        Expanded(
          child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SCORE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BEST",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
