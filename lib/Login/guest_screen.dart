import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/Constructs/person.dart';
import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flow/Images/camera_or_gallery_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  final Function setUser;
  const GuestScreen(this.setUser, {super.key});

  @override
  State<GuestScreen> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<GuestScreen> {
  Uint8List? image;
  TextEditingController controller = TextEditingController();

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
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Enter guest name...",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        try {
                          widget.setUser(Person(
                              image == null
                                  ? DatabaseProxy.defaultProfileURL()
                                  : await DatabaseProxy.uploadProfilePicture(
                                      image!, "0"),
                              controller.toString(),
                              "0"));
                          print("new guest!");
                        } catch (e) {
                          print(e);
                        }
                        controller.clear();
                        Navigator.pushNamed(context, "home_screen");
                      },
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: CameraOrGalleryMenu(setImgPath)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: image == null
                      ? Image.asset("assets/images/default_profile.png").image
                      : Image.memory(image!).image,
                ),
              ),
            ]),
      ),
    );
  }
}
