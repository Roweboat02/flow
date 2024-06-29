import 'dart:io';

import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class NewPostPage extends StatelessWidget {
  final DatabaseProxy db;
  final TextEditingController controller = TextEditingController();
  NewPostPage(this.db, {super.key});
  String? imagePath;

  setImagePath(String imagePath) {
    this.imagePath = imagePath;
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
        if (imagePath != null)
          SizedBox(
            width: 250,
            height: 400,
            child: Image.file(File(imagePath!)),
          )
      ],
    ));
  }
}
