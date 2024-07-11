import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/images/camera_or_gallery_dialog.dart';
import 'package:flutter/material.dart';

class NewUserPage extends StatefulWidget {
  final UserCredential user;
  const NewUserPage(this.user, {super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  Uint8List? image;

  setImgPath(Uint8List image) {
    this.image = image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CameraOrGalleryMenu(setImgPath),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: image == null
                      ? Image.asset("assets/images/default_profile.png").image
                      : Image.memory(image!).image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (image != null) {
                        DatabaseProxy.makeNewUser(
                            await DatabaseProxy.uploadProfilePicture(image!));
                        Navigator.pushNamed(context, "home_screen");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("add_photo"),
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'ACTION',
                              onPressed: () {},
                            )));
                      }
                    }),
              )
            ]),
      ),
    );
  }
}
