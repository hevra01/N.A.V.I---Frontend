// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class FrameInformation extends StatelessWidget {
//   final List sceneDescription;

//   const FrameInformation({Key? key, required this.sceneDescription})
//       : super(key: key);
//   // test
//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: 'Scene Description',
//       child: Column(
//         children: [
//           for (var i = 0; i < (sceneDescription[0]).length; i++)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Semantics(
//                   label: '${sceneDescription[0][i]} object',
//                   child: Text(
//                     sceneDescription[0][i],
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Semantics(
//                   label: 'Distance: ${sceneDescription[1][i]} meters',
//                   child: Text(
//                     '${sceneDescription[1][i].toStringAsFixed(2)} m',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Semantics(
//                   label: 'Position: ${sceneDescription[2][i]}',
//                   child: Text(
//                     sceneDescription[2][i].toString(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

class FrameInformation extends StatefulWidget {
  final List sceneDescription;

  const FrameInformation({Key? key, required this.sceneDescription})
      : super(key: key);

  @override
  _FrameInformationState createState() => _FrameInformationState();
}

class _FrameInformationState extends State<FrameInformation> {
  @override
  Widget build(BuildContext context) {
    announceSceneDescription(); // Call announceSceneDescription directly inside build

    return SizedBox.shrink();
  }

  void announceSceneDescription() {
    for (var i = 0; i < widget.sceneDescription[0].length; i++) {
      final message =
          '${widget.sceneDescription[0][i]} object. Distance: ${widget.sceneDescription[1][i]} meters. Position: ${widget.sceneDescription[2][i]}';
      SemanticsService.announce(message, TextDirection.ltr);
    }
  }
}
