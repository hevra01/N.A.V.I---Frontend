import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  final Function()? onBoardingComplete;

  const OnBoardingScreen({Key? key, this.onBoardingComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    announceText("Welcome To N.A.V.I");
    announceText("(Navigation Assistance For Visually Impaired)");

    announceText("What is N.A.V.I?");
    announceText(
        "Navigation Assistance for the Visually Impaired, is a mobile application aimed to assist visually impaired people in reaching their destination by avoiding any potential obstacles such as cars, trees, bicycles, etc");

    announceText("How to Use?");
    announceText(
        "When using the app, the user needs to hold their phones on chest level and allow the app to access the camera.");

    return Scaffold(
      appBar: AppBar(
        title: const Text("N.A.V.I Introduction"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "N.A.V.I. Introduction",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/navigate');
                onBoardingComplete?.call();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  void announceText(String text) {
    SemanticsService.announce(text, TextDirection.ltr);
  }
}
