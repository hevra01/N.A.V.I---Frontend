import 'package:flutter/material.dart';

class FrameInformation extends StatelessWidget {
  final List objects_with_positions;

  FrameInformation(this.objects_with_positions);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < (objects_with_positions[0]).length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
            ],
          ),
      ],
    );
  }
}
