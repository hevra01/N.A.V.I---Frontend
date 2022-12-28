import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:navi/main.dart';
import 'package:navi/main.dart';
import '../API/api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as eos;
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:navi/main.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // to capture frames
  final ImagePicker _picker = ImagePicker();
  CameraController? controller;
  File? pictureFile;
  late bool continue_giving_description;
  late List objects_with_positions;

  // initstate runs everytime the widget gets created
  // but it doesn't run when it is updated.
  @override
  void initState() {
    super.initState();
    // initialize the camera controller
    controller = CameraController(
      cameras![0], // get the first available
      ResolutionPreset.max,
    );

    // check if camera is initialized
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });

    // this variable will stay as true as long as the user doesn't wish to stop
    // navigation. however, initially, it is false until the user clicks start navigation button
    continue_giving_description = false;

    // this will be updated based on the return value of server that is performing
    // scene description.
    objects_with_positions = [[], [], []];
  }

  // when the widget dies, this function is called.
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 25),

          // to display all the detected objects, distances, and positions
          for (var i = 0; i < (objects_with_positions[0]).length; i++)
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(objects_with_positions[0][i],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              Text((objects_with_positions[1][i].toStringAsFixed(2)),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              Text((objects_with_positions[2][i]).toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ))
            ]),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var scene;

                  setState(() {
                    continue_giving_description = true;
                  });

                  // continue making API calls to make object detection, distance
                  // and angle estimation
                  while (continue_giving_description) {
                    // make API requests every 5 seconds
                    await Future.delayed(const Duration(seconds: 1), () async {
                      scene = await handle_scene_description();
                    });

                    // use setState so that the widget gets rerendered to display
                    // the objects, distances, and angles
                    setState(() {
                      objects_with_positions = scene;
                    });
                  }
                },
                // the server will start getting api requests to perform object detection, distance and position calculation.
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
                // the server will stop getting api requests
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
    // the return value is a XFile
    final picture = await controller?.takePicture();
    var stream, length;

    // get the requirments ready to create a multipart file to be sent with the post request
    if (picture != null) {
      pictureFile = File(picture.path);
      stream = http.ByteStream(pictureFile!.openRead());
      stream.cast();
    }

    var multipart =
        await http.MultipartFile.fromPath('frame', pictureFile!.path);

    // If you want to send images/videos/files to the server, use MultipartRequest
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:5000/predict'));

    // adding the image file
    request.files.add(multipart);
    // send the api request for object detection
    var streamedResponse = await request.send();

    // converting the streamed response to a casual response
    var response = await http.Response.fromStream(streamedResponse);
    var response_decoded = json.decode(response.body);
    var listmy = response_decoded["objects_with_positions"][0];
    var len = response_decoded["objects_with_positions"][0].length;
    return response_decoded["objects_with_positions"];
  }
}
