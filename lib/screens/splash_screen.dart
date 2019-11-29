import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:Center(child: Image.asset('assets/cat.jpg', fit: BoxFit.fill,)),
      ),
    );
  }
}