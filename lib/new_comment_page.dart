import 'package:flow/camera_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewCommentPage extends StatelessWidget {
  final String postID;
  final DatabaseProxy db;
  final TextEditingController controller = TextEditingController();
  String? imagePath;

  setImagePath(String imagePath) {
    this.imagePath = imagePath;
  }

  NewCommentPage(this.db, this.postID, {super.key});

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
                icon: Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  Navigator.pop(context);
                },
              ),
              // Add a search icon or button to the search bar
              prefixIcon: Row(children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CameraPage(setImagePath))));
                  },
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.send))
              ]),
            )),
        if (imagePath != null)
          SizedBox(width: 250, height: 400, child: Image(image: image!)),
      ],
    ));
  }
}
