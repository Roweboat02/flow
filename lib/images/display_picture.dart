import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Function pictureCallback;
  const DisplayPictureScreen(this.pictureCallback, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      Image.file(File(imagePath)),
      Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              pictureCallback(imagePath);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ))
    ]);
  }
}
