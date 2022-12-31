import 'package:flutter/material.dart';

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
