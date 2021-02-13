import 'package:flutter/material.dart';
import 'package:radiobeans_web/screens/session_screen.dart';
import 'package:radiobeans_web/widgets/logo.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Logo(),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SessionScreen();
            }));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFFBDBCFF),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              "Start session",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
