import 'dart:io';

import 'package:flow/database_proxy.dart';
import 'package:flow/images/camera_or_gallery_dialog.dart';
import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  final DatabaseProxy db;
  const NewPostPage(this.db, {super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String? imgPath;
  TextEditingController controller = TextEditingController();

  setImagePath(String imagePath) {
    imgPath = imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter comment...",
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  Navigator.pop(context);
                },
              ),
              // Add a search icon or button to the search bar
              prefixIcon: Row(children: [
                CameraOrGalleryMenu(setImagePath),
                IconButton(
                    onPressed: () {
                      widget.db.makeNewPost(controller.text, imgPath);
                    },
                    icon: const Icon(Icons.send))
              ]),
            )),
        if (imgPath != null)
          SizedBox(
            width: 250,
            height: 400,
            child: Image.file(File(imgPath!)),
          )
      ],
    ));
  }
}
