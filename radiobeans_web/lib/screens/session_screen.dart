import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radiobeans_web/data/genres.dart';
import 'package:radiobeans_web/widgets/logo.dart';
import 'package:firebase/firebase.dart';
import '../theme_data.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:http/http.dart';
import 'dart:math';

class SessionScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final player = AudioPlayer();
  String genre = "jungle";
  List<int> chosen = [];
  String title = "";
  String artist = "";
  String sessionId = Uuid().v1();

  @override
  void initState() {
    super.initState();
    Database db = database();
    DatabaseReference ref = db.ref('sessions/$sessionId');
    buildRandomSession();
    ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      // initAudio(datasnapshot.toJson()['playing_now']);
      // Do something with datasnapshot
      title = datasnapshot.toJson()['title'];
      artist = datasnapshot.toJson()['artist'];
      initAudio(datasnapshot.toJson()['url']);
    });
  }

  void buildRandomSession() async {
    // Select a random starting song
    var rng = new Random();
    var numOptions = 2;
    var nowPlaying = rng.nextInt(jungle.length);
    chosen.add(nowPlaying);
    for (int i = 0; i < numOptions; i++) {
      var songIndex = rng.nextInt(jungle.length);
      while (chosen.contains(songIndex)) {
        songIndex = rng.nextInt(jungle.length);
      }
      chosen.add(songIndex);
    }

    var songData = {
      "url": jungle[chosen[0]].url,
      "artist": jungle[chosen[0]].artist,
      "title": jungle[chosen[0]].title,
      "voting_options": [
        {
          "url": jungle[chosen[1]].url,
          "artist": jungle[chosen[1]].artist,
          "title": jungle[chosen[1]].title,
          "votes": 0
        },
        {
          "url": jungle[chosen[2]].url,
          "artist": jungle[chosen[2]].artist,
          "title": jungle[chosen[2]].title,
          "votes": 0
        }
      ]
    };
    database().ref('sessions/' + sessionId).set(songData);
  }

  void initAudio(String songUrl) async {
    var duration = await player.setUrl(songUrl);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("images/beans_bg.png")),
        ),
        child: FutureBuilder(
          builder: (context, snapshot) {
            return Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Logo(),
                    )),
                Container(),
                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(sessionId)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  title,
                  style: strongText,
                ),
                Text(artist),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    if (player.playing) {
                      setState(() {
                        player.pause();
                      });
                    } else {
                      setState(() {
                        player.play();
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: player.playing
                            ? Colors.redAccent
                            : Colors.lightGreen,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: player.playing
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
