import 'package:flutter/material.dart';

class Person {
  Image? profile;
  String name;
  String uid;

  Person(this.profile, this.name, this.uid);

  setProfilePicture(Future<String> img) async {
    profile = Image.network(await img);
  }

  Widget toWidget() {
    return Row(
      children: [
        profile == null
            ? CircularProgressIndicator()
            : CircleAvatar(
                backgroundImage: profile!.image,
              ),
        Text(
          name,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
