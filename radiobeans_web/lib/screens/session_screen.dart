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
  List<int> options = [];
  String title = "";
  String artist = "";
  String sessionId = Uuid().v1();
  Future<bool> playing;
  final int numOptions = 2;
  Random rng = new Random();

  @override
  void initState() {
    super.initState();
    Database db = database();
    DatabaseReference ref = db.ref('sessions/$sessionId');
    options = buildOptions();
    buildSessionSongs(rng.nextInt(jungle.length));
    ref.once('value').then((e) async {
      DataSnapshot datasnapshot = e.snapshot;
      // initAudio(datasnapshot.toJson()['playing_now']);
      // Do something with datasnapshot

      initAudio(datasnapshot.toJson());
    });
  }

  List<int> buildOptions() {
    print("rebuilding options");
    return jungle.map((song) {
      return song.id;
    }).toList();
  }

  void buildSessionSongs(int chosenSong) async {
    if (options.length < 4) {
      setState(() {
        options = buildOptions();
        print(options);
      });
    }

    options.remove(chosenSong);
    print(options);
    var option1Index = options[rng.nextInt(options.length - 1)];
    var option2Index = options[rng.nextInt(options.length - 2)];
    if (option1Index == option2Index) {
      option2Index += 1;
    }

    var songData = {
      "url": jungle[chosenSong].url,
      "artist": jungle[chosenSong].artist,
      "title": jungle[chosenSong].title,
      "id": chosenSong,
      "voting_options": [
        {
          "url": jungle[option1Index].url,
          "artist": jungle[option1Index].artist,
          "title": jungle[option1Index].title,
          "id": option1Index,
          "votes": 0
        },
        {
          "url": jungle[option2Index].url,
          "artist": jungle[option2Index].artist,
          "title": jungle[option2Index].title,
          "id": option2Index,
          "votes": 0
        }
      ]
    };
    database().ref('sessions/' + sessionId).set(songData);
  }

  void initAudio(dynamic songJson) async {
    print("init audio is running");
    var duration = await player.setUrl(songJson['url']);
    print(songJson['url']);
    player.play();
    setState(() {
      title = songJson['title'];
      artist = songJson['artist'];
      playing = Future.value(true);
    });
  }

  void playNextSong() async {
    database()
        .ref('sessions/$sessionId/voting_options')
        .once("value")
        .then((event) {
      if (event.snapshot.val()[0]['votes'] > event.snapshot.val()[1]['votes']) {
        buildSessionSongs(event.snapshot.val()[0]['id']);
        print("calling init audio");
        initAudio(event.snapshot.val()[0]);
      } else {
        buildSessionSongs(event.snapshot.val()[1]['id']);
        print("calling init audio");
        initAudio(event.snapshot.val()[1]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: playing,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
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
                  ),
                  StreamBuilder(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Duration position = snapshot.data;
                        if (position.inSeconds >= player.duration.inSeconds) {
                          playNextSong();
                        }
                        return Slider(
                          value: position.inSeconds / player.duration.inSeconds,
                          onChanged: (value) {
                            player.seek(Duration(
                                seconds: (player.duration.inSeconds * value)
                                    .floor()));
                          },
                        );
                      }
                      return Slider(
                        value: 0,
                        onChanged: (value) {},
                      );
                    },
                  )
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
