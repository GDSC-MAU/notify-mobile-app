import 'package:flutter/material.dart';
import './pages/SplashScreen.dart';
import './pages/Start.dart';
import './pages/Report.dart';
import './pages/ReportDetails.dart';
import './pages/Submitted.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>const Splash(),
        '/start':(context) => const Start(),
        '/report':(context) => const Report(),
        '/reportDetails':(context) => const ReportDetails(),
        '/submitted':(context)=> const Submitted()

      },
      debugShowCheckedModeBanner: false,
    )
  );
}

