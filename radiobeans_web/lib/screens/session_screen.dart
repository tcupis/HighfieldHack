import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radiobeans_web/widgets/logo.dart';
import 'package:firebase/firebase.dart';
import '../theme_data.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:http/http.dart';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final player = AudioPlayer();
  String title = "";
  String artist = "";

  @override
  void initState() {
    super.initState();

    Database db = database();
    DatabaseReference ref = db.ref('157629');

    ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      initAudio(datasnapshot.toJson()['playing_now']);
      // Do something with datasnapshot
    });
  }

  void initAudio(String songUrl) async {
    var duration = await player.setUrl(songUrl);
    player.play();
    getMetaData(songUrl);
  }

  void getMetaData(String songUrl) async {
    Response response = await get(songUrl);
    TagProcessor tp = new TagProcessor();
    var l = await tp.getTagsFromByteData(
        response.bodyBytes.buffer.asByteData(), [TagType.id3v2]);
    setState(() {
      title = l[0].tags["title"];
      artist = l[0].tags['artist'];
    });
    print(l[0].tags['picture']['Cover (front)']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Logo(),
      ),
      body: Column(
        children: [
          Container(),
          Text("Session ID: 157629"),
          Text(
            title,
            style: strongText,
          ),
          Text(artist)
        ],
      ),
    );
  }
}
