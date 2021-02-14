import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:radiobeans_web/screens/home_screen.dart';

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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

