import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Scoreboard extends StatefulWidget {
  final Widget playButton;

  Scoreboard({this.playButton});

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
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
        children: <Widget>[
          Text(
            "SCOREBOARD",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Divider(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "USERNAME",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                "SCORE",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('scoreboard')
                  .orderBy('record', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(child: Center(child: Text("No data")));
                }
                return Container(
                  height: 200.0,
                  width: 300.0,
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data.documents[index]["nick"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  snapshot.data.documents[index]["record"]
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                );
              }),
          Divider(
            height: 30,
          ),
          widget.playButton,
        ],
      ),
      actions: [],
    );
  }
}
