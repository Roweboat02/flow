import 'package:flow/images/display_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CameraOrGalleryMenu extends StatelessWidget {
  final Icon icon;
  final Function pictureCallback;
  const CameraOrGalleryMenu(this.pictureCallback,
      {super.key, this.icon = const Icon(Icons.add_a_photo)});

  void _openGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      try {
        pictureCallback(pickedFile!.path);
      } on TypeError catch (e) {}
    } on PlatformException {}
  }

  void _openCamera(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      try {
        pictureCallback(pickedFile!.path);
      } on TypeError catch (e) {}
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: icon,
        onSelected: (value) {
          [
            _openGallery(context),
            _openCamera(context),
          ][value];
        },
        itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                  value: 0,
                  child: Column(
                    children: [Icon(Icons.collections), Text("From Gallery")],
                  )),
              const PopupMenuItem(
                  value: 1,
                  child: Column(
                    children: [Icon(Icons.camera_alt), Text("From Camera")],
                  ))
            ]);
  }
}
