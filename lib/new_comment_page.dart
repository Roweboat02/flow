import 'dart:io';
import 'package:flow/database_proxy.dart';
import 'package:flow/images/camera_or_gallery_dialog.dart';
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
    imgPath = imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 50, 8.0, 0),
            child: Row(
              children: [
                Flexible(
                    child: TextField(
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
                      prefixIcon: CameraOrGalleryMenu(setImagePath)),
                )),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    widget.db.makeNewComment(widget.postID, controller.text);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          if (imgPath != null)
            SizedBox(
              width: 250,
              height: 400,
              child: Image.file(File(imgPath!)),
            ),
        ],
      ),
    );
  }
}
