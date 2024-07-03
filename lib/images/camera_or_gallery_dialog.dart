import 'package:flow/images/camera_page.dart';
import 'package:flow/images/gallery_page.dart';
import 'package:flutter/material.dart';

class CameraOrGalleryMenu extends StatelessWidget {
  final Icon icon;
  final Function pictureCallback;
  const CameraOrGalleryMenu(this.pictureCallback,
      {super.key, this.icon = const Icon(Icons.add_a_photo)});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: icon,
        onSelected: (value) {
          Navigator.push(
              context,
              [
                MaterialPageRoute(
                    builder: (context) => GalleryPage(pictureCallback)),
                MaterialPageRoute(
                    builder: (context) => CameraPage(pictureCallback))
              ][value]);
        },
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  value: 0,
                  child: Column(
                    children: [Icon(Icons.collections), Text("From Gallery")],
                  )),
              PopupMenuItem(
                  value: 1,
                  child: Column(
                    children: [Icon(Icons.collections), Text("From Gallery")],
                  ))
            ]);
  }
}
