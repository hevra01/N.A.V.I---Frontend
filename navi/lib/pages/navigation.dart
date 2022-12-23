import 'dart:convert';

import 'package:flutter/material.dart';
import '../API/api.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    // this is returned by the login widget after the customer logs in
    final Map scene = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.yellow,
            centerTitle: true,
            title: const Text(
              'NAVI',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  //SizedBox(height: 30),
                  Text('Object',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.purple,
                      )),
                  Text('Distance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.purple,
                      )),
                  Text('Position',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.purple,
                      )),
                ],
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => handle_stop_navigation(),
                child: const Text('Stop Navigation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ));
  }

  // this function will make an API call to ask the
  // server to stop the navigation that includes object detection,
  // distance and position calculation.
  handle_stop_navigation() async {
    // make an API request
    var response =
        // we need to send an api token as well because only authenticated
        // users should be able to make this call
        await CallApi().getData('predict');
  }
}
