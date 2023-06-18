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
