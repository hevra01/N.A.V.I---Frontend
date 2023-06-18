import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:navi/pages/navigation.dart';
import 'package:navi/pages/onBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkOnBoardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onBoardingShown = prefs.getBool('onBoardingShown') ?? false;
    return !onBoardingShown;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkOnBoardingStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the future is being resolved
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Show an error message if the future fails
          return Text('Error: ${snapshot.error}');
        } else {
          // Retrieve the value of showOnBoarding from the snapshot
          bool showOnBoarding = snapshot.data ?? false;

          return MaterialApp(
            initialRoute: showOnBoarding ? '/onboarding' : '/navigate',
            routes: {
              '/onboarding': (context) => OnBoardingScreen(
                onBoardingComplete: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool('onBoardingShown', true);
                  });
                },
              ),
              '/navigate': (context) => const Navigation(),
            },
          );
        }
      },
    );
  }
}

