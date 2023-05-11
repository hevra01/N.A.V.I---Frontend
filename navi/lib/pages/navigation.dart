import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:navi/custom_widgets/ObjectDistancePositionHeader.dart';
import 'package:navi/custom_widgets/displayFrameInformation.dart';
import 'package:navi/main.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_test/flutter_test.dart';

import '../utils/location.dart';
import '../utils/weather.dart';
import '../utils/weatherFetch.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // to capture frames
  CameraController? controller;
  File? pictureFile;

  // will be set to true when the user clicks start navigation button
  late bool continue_giving_description;

  // after the server detects objects, distances, and positions, it will be
  // assigned to this variable
  late List objects_with_positions;

  // initstate runs everytime the widget gets created
  // but it doesn't run when it is updated.
  @override
  void initState() {
    super.initState();
    // initialize the camera controller
    controller = CameraController(
      // get the first available camera
      cameras![0],
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
    // dispose the camera when the widget gets removed from the tree
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
          const SizedBox(height: 30),
          // display the headers for frame/scene description
          const ObjectDistancePositionHeader(),
          const SizedBox(height: 25),

          // to display all the detected objects, distances, and positions by the server (ml model)
          FrameInformation(sceneDescription: objects_with_positions),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // holds the start navigation and stop navigation buttons
            children: [
              ElevatedButton(
                // api requests will continue to be sent to the server hosting
                // an ml model to perform object detection and will continue
                // until the user wishes to stop by clicking stop navigation button
                onPressed: startNavigation_button_pressed,
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
                onPressed: stopNavigation_button_pressed,
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
          const SizedBox(height: 20),
        ])));
  }

  // show an alert to the user based on the message

  void alertPopUp(message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }







  // used to show the weather data
  Future<void> weatherPopUp() async {
    Future<LocationHelper?> locationData = getLocationData();
    Future<WeatherData> weatherData = getWeatherData(await locationData);
    int temperature = (await weatherData).currentTempurature.round();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Weather Data'),
        content: Text("The temperature is $temperature degrees Celsius"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // handle the program execution after the stop navigation button is pressed
  stopNavigation_button_pressed() async {
    continue_giving_description = false;
    // clean up the screen
    setState(() {
      objects_with_positions = [[], [], []];
    });
    // let the user know that the navigation has been stopped.
    var message = "Navigation has been stopped!";
    alertPopUp(message);
  }

  // handle the program execution after the start navigation button is pressed
  startNavigation_button_pressed() async {
    var scene;
    continue_giving_description = true;

    // before we start informing about the detected objects,
    // we will let the user know about the weather
    await weatherPopUp();

    // continue making API calls to make object detection, distance
    // and angle estimation
    while (continue_giving_description) {
      // make API requests every 5 seconds
      await Future.delayed(const Duration(seconds: 1), () async {
        scene = await handle_scene_description();
      });

      // no objects detected and no server error
      if (scene[0].isEmpty) {
        continue;
      }
      // objects detected and no server error
      else if (scene[0][0] != -222) {
        // use setState so that the widget gets rerendered to display
        // the objects, distances, and angles
        setState(() {
          objects_with_positions = scene;
        });
        // server error
      } else {
        // show an alert to the user since the server is irresponsive and can't detect objects
        var message =
            "Currently the app is unable to detect objects. \nConsequently, please take cautions accordingly and try again later.";
        alertPopUp(message);
        // assign false to continue_giving_description so that api requests are stop
        // being sent to the server since it is down.
        setState(() {
          continue_giving_description = false;
        });
      }
    }
  }

  // this function will take a picture and make an API call to the server hosting
  // an ml model that makes object detection distance and position calculation.
  handle_scene_description() async {
    // the return value is a XFile
    final picture = await controller?.takePicture();
    var stream;

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
        'POST', Uri.parse('http://10.143.11.150:5000/predict'));

    // adding the image file
    request.files.add(multipart);

    // taking into consideration that the server may go down or face a problem
    // let the user know about it accordingly.
    try {
      // send the api request for object detection
      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      // converting the streamed response to a casual response
      var response = await http.Response.fromStream(streamedResponse);
      var response_decoded = json.decode(response.body);
      return response_decoded["objects_with_positions"];
    } catch (_) {
      return [
        [-222],
        [],
        []
      ];
    }
  }
}










