import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('lib/assets/brick.png'),
      height: 60,
      width: 60,
    );
  }
}
