import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Scoreboard extends StatefulWidget {
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
          StreamBuilder(
              stream: Firestore.instance.collection('scoreboard').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(child: Center(child: Text("No data")));
                }
                return Container(
                  height: 300.0,
                  width: 300.0,
                  child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, int index) {
                        return Text(
                          snapshot.data.documents[index]["nick"] +
                              ":" +
                              snapshot.data.documents[index]["record"]
                                  .toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                        //return ChatMessage(text: snapshot.data.documents[index]["messageField"]); //I just assumed that your ChatMessage class takes a parameter message text
                      }),
                );
              }),
          Divider(
            height: 1.0,
          ),
        ],
      ),
      actions: [],
    );
  }
}
