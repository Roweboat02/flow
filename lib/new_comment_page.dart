import 'dart:io';

import 'package:flow/camera_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';

class NewCommentPage extends StatefulWidget {
  final DatabaseProxy db;
  final String postID;
  const NewCommentPage(this.db, this.postID, {super.key});

  @override
  State<NewCommentPage> createState() => _NewCommentPageState();
}

class _NewCommentPageState extends State<NewCommentPage> {
  String? imgPath;
  TextEditingController controller = TextEditingController();

  setImagePath(String imagePath) {
    this.imgPath = imagePath;
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
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CameraPage(setImagePath))));
                  },
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send))
              ]),
            )),
        if (imgPath != null)
          SizedBox(
            width: 250,
            height: 400,
            child: Image.file(File(imgPath!)),
          ),
      ],
    ));
  }
}
