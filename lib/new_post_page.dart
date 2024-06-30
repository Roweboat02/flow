import 'dart:io';

import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

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
                            builder: ((context) => CameraPage(
                                  setImagePath,
                                ))));
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
          )
      ],
    ));
  }
}
