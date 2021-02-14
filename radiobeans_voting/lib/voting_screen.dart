import 'dart:math';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:radiobeans_voting/theme_data.dart';

class VotingScreen extends StatefulWidget {
  String sessionId;
  VotingScreen({this.sessionId});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Map<String, dynamic> song0data;
  Map<String, dynamic> song1data;
  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();
  int index = 0;

  Database db;
  DatabaseReference ref;
  @override
  void initState() {
    db = database();
    ref = db.ref('sessions/${widget.sessionId}/voting_options');
    ref.onValue.listen((e) {
      setState(() {
        song0data = e.snapshot.child('0').toJson();
        song1data = e.snapshot.child('1').toJson();
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RadioBeans", style: strongText.copyWith(color: Colors.black),), backgroundColor: Colors.transparent,),
      body: song0data == null
          ? CircularProgressIndicator()
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: (Column(
                children: [
                  Text(widget.sessionId),
                  getSongData(song0data, 0),
                  Divider(),
                  getSongData(song1data, 1)
                ],
              )),
          ),
    );
  }

  Widget getSongData(dynamic json, int votingIndex) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(),
        Text(json['title'], style: strongText,),
        Text(json['artist']),
        SizedBox(height: 10,),
        GestureDetector(
          onTap: () {
            ref.child("0").child("votes").once('value').then((e) {
              print(e.snapshot);
              ref.child("0").child("votes").update(5);
            });
            
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10,50,10,50),
            width: 400,
            decoration: BoxDecoration(
                color: colors[random.nextInt(3)],
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: Icon(Icons.music_note),
          ),
        )
      ],
    ));
  }
}
