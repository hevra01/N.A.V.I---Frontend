import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:navi/pages/navigation.dart';
import 'package:navi/pages/onBoarding.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const OnBoardingScreen(),
      '/navigate': (context) => const Navigation(),
    },
  ));
}
