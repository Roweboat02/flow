import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/camera_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewUserPage extends StatefulWidget {
  final UserCredential user;
  const NewUserPage(this.user, {super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  TextEditingController controller = TextEditingController();
  String? imagePath;

  setImgPath(String imagePath) {
    this.imagePath = imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Display Name",
                  ),
                  controller: controller,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CameraPage(
                                  setImgPath,
                                ))));
                  },
                  child: Text("Upload Profile Picture")),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: imagePath == null
                      ? Image.asset("assets/images/default_profile.png")
                      : Image.file(File(imagePath!)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (await DatabaseProxy.userExists(controller.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("username-already-in-use"),
                          duration: const Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'ACTION',
                            onPressed: () {},
                          )));
                    } else {
                      widget.user.user!.updateDisplayName(controller.text);
                      widget.user.user!.updatePhotoURL(
                          await DatabaseProxy.uploadProfilePicture(imagePath!));

                      DatabaseProxy.makeNewUser();

                      Navigator.pushNamed(context, "home_screen");
                    }
                  },
                ),
              )
            ]),
      ),
    );
  }
}
