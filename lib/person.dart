import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';

class Person {
  Image? profile;
  String name;
  String uid;
  bool showAddFriend = true;

  Person(this.profile, this.name, this.uid);

  setProfilePicture(Future<String> img) async {
    profile = Image.network(await img);
  }

  Widget toWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(children: [
            if (showAddFriend)
              IconButton(
                  onPressed: () => DatabaseProxy.addFriend(uid),
                  icon: Icon(Icons.accessibility)),
          ]),
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
      ),
    );
  }
}
