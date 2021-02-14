import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: Image(
        height: 30,
        image: AssetImage("images/RadioBeans.png"),
      ),
    );
  }
}
