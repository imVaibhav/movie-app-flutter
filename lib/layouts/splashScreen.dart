import 'dart:async';

import 'package:flutter/material.dart';

import './home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _timer() async {
    var _duration = new Duration(seconds: 2);
    Timer(_duration,
        () => Navigator.of(context).pushReplacementNamed(Home.routeName));
  }

  @override
  void initState() {
    super.initState();
    _timer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x032541),
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
