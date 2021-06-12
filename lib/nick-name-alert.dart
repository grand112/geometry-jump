import 'package:flutter/material.dart';

class NickNameAlert extends StatelessWidget {
  final wordController;
  final Widget playButton;

  NickNameAlert({this.wordController, this.playButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.white,
        ),
      ),
      title: Column(
        children: [
          Divider(
            height: 20,
          ),
          Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Divider(
            height: 20,
          ),
          Text(
            "Please enter your nickname",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Divider(
            height: 40,
          ),
          TextField(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
              decoration: TextDecoration.none,
            ),
            controller: wordController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red[900]),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red[900]),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red[900]),
              ),
            ),
            autofocus: true,
            cursorColor: Colors.red[900],
          ),
          Divider(
            height: 40,
          ),
          playButton
        ],
      ),
      actions: [],
    );
  }
}
