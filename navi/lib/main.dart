import 'package:flutter/material.dart';
//import 'package:my_first_flutter_project/pages/home.dart';
import 'package:navi/pages/navigation.dart';

// Organize the routings
void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Navigation(),
      },
    ));
