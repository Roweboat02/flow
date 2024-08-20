import 'dart:typed_data';

import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flow/Images/camera_or_gallery_dialog.dart';
import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  final DatabaseProxy db;
  const NewPostPage(this.db, {super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  Uint8List? img;
  TextEditingController controller = TextEditingController();

  setImage(Uint8List image) {
    setState(() {
      img = image;
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
                      prefixIcon: CameraOrGalleryMenu(setImage),
                    )),
              ),
              IconButton(
                  onPressed: () {
                    widget.db.makeNewPost(controller.text, img);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ),
        if (img != null)
          SizedBox(
            width: 250,
            height: 400,
            child: Image.memory(img!),
          )
        else
          SizedBox()
      ],
    ));
  }
}
