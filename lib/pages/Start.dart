import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: Column(
          children: [
            Image.asset(
              'assets/report.png',
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding:  EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
              child:   Center(
                child: Text(
                    'Report any emergencies to authorities with ease with notify',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blueAccent
                    ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            RoundedLoadingButton(
              controller: _btnController,
                onPressed: (){
                  _btnController.success();
                  Navigator.pushReplacementNamed(context, '/report');
                },
                child:const Padding(
                  padding:  EdgeInsets.all(10.0),
                  child:  Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28
                      )
                  ),
                ),
            )
          ],
        ),
      )
    );
  }
}
