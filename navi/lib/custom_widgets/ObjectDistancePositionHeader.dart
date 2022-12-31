import 'package:flutter/material.dart';

// this widget will be used to display the headers for frame
// description such as detected objects, distances, and positions
class ObjectDistancePositionHeader extends StatelessWidget {
  const ObjectDistancePositionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
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
    );
  }
}
