import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:radiobeans_voting/theme_data.dart';
import 'package:radiobeans_voting/voting_screen.dart';

import 'logo.dart';

void main() {
  initializeApp(
        apiKey: "AIzaSyA0b-UT43jKrbFY6Ew_mrWNKVaH3bKdNYE",
        authDomain: "radiobeans-f4d02.firebaseapp.com",
        databaseURL:
            "https://radiobeans-f4d02-default-rtdb.europe-west1.firebasedatabase.app",
        projectId: "radiobeans-f4d02",
        storageBucket: "radiobeans-f4d02.appspot.com",
        messagingSenderId: "871622675092",
        appId: "1:871622675092:web:6a4b563b30fb5ec03e8281",
        measurementId: "G-3EDTZW6YQP");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadioBeans',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SessionSelectScreen(),
    );
  }
}

class SessionSelectScreen extends StatefulWidget {
  @override
  _SessionSelectScreenState createState() => _SessionSelectScreenState();
}

class _SessionSelectScreenState extends State<SessionSelectScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Logo(),
          backgroundColor: Colors.transparent,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 500,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Session ID",
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              color: Colors.green,
              onPressed: () {
                if(_controller.text.length == 36) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VotingScreen(sessionId: _controller.text);
                  }));
                }
              },
            )
          ],
        ));
  }
}
