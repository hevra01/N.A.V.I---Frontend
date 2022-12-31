import 'package:flutter/material.dart';

class FrameInformation extends StatelessWidget {
  // this list includes a list for the detected objects,
  // another for their distances, and a third one for their positions.
  final List sceneDescription;

  const FrameInformation({super.key, required this.sceneDescription});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < (sceneDescription[0]).length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(sceneDescription[0][i],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              Text((sceneDescription[1][i].toStringAsFixed(2)),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              Text((sceneDescription[2][i]).toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ))
            ],
          ),
      ],
    );
  }
}
