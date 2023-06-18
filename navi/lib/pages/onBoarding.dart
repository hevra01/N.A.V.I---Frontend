import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  final Function()? onBoardingComplete;

  const OnBoardingScreen({Key? key, this.onBoardingComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    announceText("Welcome To N.A.V.I.? Navigation Assistance For Visually Impaired. What is N.A.V.I? Navigation Assistance for the Visually Impaired, is a mobile application aimed to assist visually impaired people in reaching their destination by avoiding any potential obstacles such as cars, trees, bicycles, etc. How to Use? When using the app, the user needs to hold their phones on chest level and allow the app to access the camera. Additionally, the phone needs to be held normal to the ground.");

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
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(200, 100), // Set the desired width and height
                  ),
                ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/navigate');
                onBoardingComplete?.call();
              },
              child: const Text('Continue', style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),),
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
