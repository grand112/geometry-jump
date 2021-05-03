import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geometry_jump/barriers.dart';
import 'package:geometry_jump/brick.dart';
import 'package:geometry_jump/alert.dart';

import 'barriers.dart';

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
  bool gameStarted = false;
  bool firsRotate = true;
  bool endGame = false;
  double startRotatePos = 0;
  double endRotatePos = 0.5;
  int score = 0;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
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

  void startGame() {
    if (!gameStarted) {
      Timer.periodic(Duration(milliseconds: 40), (timer) {
        loopBariers();
        if (endGame) {
          timer.cancel();
        }
      });
      setState(() {
        gameStarted = true;
      });
    }
  }

  void handleTap() {
    startGame();
    if (jumpStarted) {
      jump();
    } else {
      startJumping();
    }
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
        if (!endGame) {
          brickYaxis = initialHeight - height;
        }
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

  showEndGameDialog(BuildContext context) {
    Widget restartButton = IconButton(
      icon: Icon(
        Icons.play_arrow,
        color: Colors.red[700],
        size: 40,
      ),
      onPressed: () {
        restart();
        Navigator.of(context).pop();
      },
    );

    Widget scoreBoardButton = IconButton(
      icon: Icon(
        Icons.leaderboard,
        color: Colors.red[700],
        size: 40,
      ),
      onPressed: () {},
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Alert(
          restartButton: restartButton,
          scoreBoardButton: scoreBoardButton,
          score: score,
        );
      },
    );
  }

  void restart() {
    brickYaxis = 1;
    brickXaxis = -0.9;
    time = 0;
    height = 0;
    initialHeight = brickYaxis;
    jumpStarted = false;
    gameStarted = false;
    firsRotate = true;
    endGame = false;
    startRotatePos = 0;
    endRotatePos = 0.5;
    score = 0;
    barrierXone = 1;
    barrierXtwo = barrierXone + 1.5;
  }

  void checkCollision() {
    if (barrierXone > brickXaxis - 0.4 &&
        barrierXone < brickXaxis + 0.4 &&
        brickYaxis > 1 - 0.4) {
      showEndGameDialog(context);
      endGame = true;
    }

    if (barrierXtwo > brickXaxis - 0.4 &&
        barrierXtwo < brickXaxis + 0.4 &&
        brickYaxis > 1 - 0.2) {
      showEndGameDialog(context);
      endGame = true;
    }

    if (barrierXone > brickXaxis - 0.4 &&
        barrierXone < brickXaxis + 0.4 &&
        brickYaxis < -1 + 0.4) {
      showEndGameDialog(context);
      endGame = true;
    }

    if (barrierXtwo > brickXaxis - 0.4 &&
        barrierXtwo < brickXaxis + 0.4 &&
        brickYaxis < -1 + 0.6) {
      showEndGameDialog(context);
      endGame = true;
    }
  }

  void loopBariers() {
    checkCollision();
    setState(() {
      if (barrierXtwo < -2) {
        barrierXtwo += 3.5;
        score += 1;
      } else {
        barrierXtwo -= 0.05;
      }
    });
    setState(() {
      if (barrierXone < -2) {
        barrierXone += 3.5;
        score += 1;
      } else {
        barrierXone -= 0.05;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: endGame ? () {} : handleTap,
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                AnimatedContainer(
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 0),
                  alignment: Alignment(
                    barrierXone,
                    1.1,
                  ),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 0),
                  alignment: Alignment(
                    barrierXone,
                    -1.1,
                  ),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 0),
                  alignment: Alignment(
                    barrierXtwo,
                    1.1,
                  ),
                  child: MyBarrier(
                    size: 50.0,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 0),
                  alignment: Alignment(
                    barrierXtwo,
                    -1.1,
                  ),
                  child: MyBarrier(
                    size: 150.0,
                  ),
                ),
                Container(
                  child: gameStarted
                      ? Text("")
                      : Text(
                          "T A P  T O  P L A Y",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                  alignment: Alignment(
                    0,
                    -0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
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
                          score.toString(),
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
                          score.toString(),
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
      )),
    );
  }
}
