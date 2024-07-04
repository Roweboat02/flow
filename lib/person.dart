import 'package:flutter/material.dart';

class Person {
  Image? profile;
  String name;
  String uid;

  Person(this.profile, this.name, this.uid);

  setProfilePicture(Future<Image> img) async {
    profile = await img;
  }

  Widget toWidget() {
    return Row(
      children: [
        profile == null
            ? CircularProgressIndicator()
            : CircleAvatar(
                child: profile,
              ),
        Text(
          name,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
