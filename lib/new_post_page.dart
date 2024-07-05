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
    setState(() {
      imgPath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter Post...",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          Navigator.pop(context);
                        },
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: CameraOrGalleryMenu(setImagePath),
                    )),
              ),
              IconButton(
                  onPressed: () {
                    widget.db.makeNewPost(controller.text, imgPath);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ),
        if (imgPath != null)
          SizedBox(
            width: 250,
            height: 400,
            child: Image.file(File(imgPath!)),
          )
        else
          SizedBox()
      ],
    ));
  }
}
