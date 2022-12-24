import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../API/api.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // to capture frames
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // this variable will stay as true as long as the user doesn't wish to stop
    // navigation.
    bool continue_giving_description = false;

    // this will be updated based on the return value of server that is performing
    // scene description.
    List<List> scene = [[], [], []];

    final ImagePicker _picker = ImagePicker();

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.yellow,
            centerTitle: true,
            title: const Text(
              'NAVI',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        body: Center(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              //SizedBox(height: 30),
              Text('Object',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.purple,
                  )),
              //const SizedBox(width: 100),
              Text('Distance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.purple,
                  )),
              //const SizedBox(width: 100),
              Text('Position',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.purple,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    continue_giving_description = true;
                  });
                  // continue making API calls to make object detection, distance
                  // and angle estimation
                  while (continue_giving_description == true) {
                    final XFile? photo =
                        await _picker.pickImage(source: ImageSource.camera);
                    File photofile = File(photo!.path);
                    scene = handle_scene_description(photofile);
                  }
                },
                child: const Text('Start Navigation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    )),
              ),
              ElevatedButton(
                // set the state of continue_giving_description to false
                // so that we don't make API calls anymore unless the user wants to
                // start again.
                onPressed: () {
                  setState(() {
                    continue_giving_description = false;
                  });
                },
                child: const Text('Stop Navigation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ])));
  }

  // this function will make an API call to ask the
  // server to stop the navigation that includes object detection,
  // distance and position calculation.
  handle_scene_description(img_file) async {
    List<List> scene;

    scene = await CallApi().postData(
      img_file,
      'predict',
    );
  }
}
