import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splashscreen/splashscreen.dart';
import './Start.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: const Start(),
      image:  Image.asset(
          'assets/start.jpg',
        fit:BoxFit.fill,
      ),
      backgroundColor: Colors.white,

      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 170.0,
    );
  }
}
