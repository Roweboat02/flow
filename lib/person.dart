import 'package:flutter/material.dart';

class Person {
  Image profile;
  String name;

  Person(this.profile, this.name);

  setProfilePicture(Future<Image> img) async {
    profile = await img;
  }
}
