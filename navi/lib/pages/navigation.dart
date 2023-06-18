import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/semantics.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:navi/custom_widgets/displayFrameInformation.dart';
import 'package:navi/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  String elevatedButtonText = 'Start Navigation';

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
          // to display all the detected objects, distances, and positions by the server (ml model)
          FrameInformation(sceneDescription: objects_with_positions),
          const SizedBox(
            width: 200, // Set the desired width
            height: 400, // Set the desired height
          ),
          //const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            // holds the start/stop navigation button
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(240, 150), // Set the desired width and height
                  ),
                ),
                onPressed: () {
                  if (continue_giving_description) {
                    stopNavigation_button_pressed();
                    setState(() {
                      elevatedButtonText = "Start Navigation";
                    });
                  } else {
                    startNavigation_button_pressed();
                    setState(() {
                      elevatedButtonText = "Stop Navigation";
                    });
                  }
                },
                child: Text(
                  elevatedButtonText,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ])));
  }

  // used to show the weather data
  Future<void> weatherPopUp() async {
    Future<LocationHelper?> locationData = getLocationData();
    Future<WeatherData> weatherData = getWeatherData(await locationData);
    int temperature = (await weatherData).currentTempurature.round();

    String message = "The temperature is $temperature degrees Celsius";
    SemanticsService.announce(message, TextDirection.ltr);
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
    SemanticsService.announce(message, TextDirection.ltr);
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
      await Future.delayed(const Duration(seconds: 6), () async {
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
        SemanticsService.announce(message, TextDirection.ltr);
        // assign false to continue_giving_description so that api requests are stop
        // being sent to the server since it is down.
        setState(() {
          continue_giving_description = false;
        });
      }
    }
  }

  // this function will be used to compress the image before sending it to the backend.
  Future<File> compressFile(XFile file) async {
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800,
      minHeight: 600,
      quality: 94,
    );

    String compressedFilePath = '${file.path}_compressed.jpg';
    File compressedFile = File(compressedFilePath);
    await compressedFile.writeAsBytes(compressedBytes!);

    return compressedFile;
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
      pictureFile = await compressFile(picture);
      stream = http.ByteStream(pictureFile!.openRead());
      stream.cast();
    }

    var multipart =
        await http.MultipartFile.fromPath('frame', pictureFile!.path);

    // If you want to send images/videos/files to the server, use MultipartRequest
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.144.141.1:5000/predict'));

    // adding the image file
    request.files.add(multipart);

    // taking into consideration that the server may go down or face a problem
    // let the user know about it accordingly.
    try {
      // send the api request for object detection
      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 5));
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
