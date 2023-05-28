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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showOnBoarding = false;

  @override
  void initState() {
    super.initState();
    checkOnBoardingStatus();
  }

  Future<void> checkOnBoardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onBoardingShown = prefs.getBool('onBoardingShown') ?? false;

    setState(() {
      showOnBoarding = !onBoardingShown;
    });
  }

  void onBoardingComplete() {
    setState(() {
      showOnBoarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: showOnBoarding ? '/onboarding' : '/navigate',
      routes: {
        '/onboarding': (context) => OnBoardingScreen(
              onBoardingComplete: onBoardingComplete,
            ),
        '/navigate': (context) => const Navigation(),
      },
    );
  }
}
