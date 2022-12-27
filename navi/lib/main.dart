import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:my_first_flutter_project/pages/home.dart';
import 'package:navi/pages/navigation.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Navigation(),
    },
  ));
}
