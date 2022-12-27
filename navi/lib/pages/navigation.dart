import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../API/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as eos;
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

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
                  while (continue_giving_description) {
                    // make API requests every 5 seconds
                    await Future.delayed(const Duration(seconds: 5), () async {
                      await handle_scene_description();
                    });
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
  handle_scene_description() async {
    //var yes = ImageSource.camera;
    //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    //File photofile = File(photo!.path);

    //var stream = http.ByteStream(photofile.openRead());
    //stream.cast();
    //var length = await photofile.length();

    // If you want to send images/videos/files to the server, use MultipartRequest
    //var request = http.MultipartRequest(
    //    'POST', Uri.parse('http://10.0.2.2:5000/predict'));

    //var multiport = new http.MultipartFile('photofile', stream, length);

    var response2 = await CallApi().getData('predict');
    print(response2);

    // adding the image file
    //request.files.add(multiport);
    //var response = await request.send();
    print("yes");
    //setState(() {
    //  scene = response;
    //});
  }
}
