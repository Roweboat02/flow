import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseProxy {
  late Person user;

  DatabaseProxy(this.user);

  final fb = FirebaseDatabase.instance;
  // https://medium.com/firebase-tips-tricks/how-to-use-firebase-realtime-database-with-flutter-ebd98aba2c91

  static Future<NetworkImage> getUserImage(String username) async {
    final String url = await FirebaseDatabase.instance
        .ref("users/${username}/profile_picture")
        .get() as String;
    return NetworkImage(url);
  }

  Future<Position> get position async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<bool> newUser(String username) async {
    final inst = FirebaseDatabase.instance;
    final DataSnapshot snapshot = await inst.ref("users/${username}").get();
    if (snapshot.exists) {
      return false;
    } else {
      inst.ref("users/${username}").update({
        "${username}/chats": [],
        "${username}/posts": [],
        "${username}/reposts": [],
        "${username}/friends": [],
        "${username}/profile_picture":
            "https://www.kindpng.com/picc/m/451-4517876_default-profile-hd-png-download.png",
      });
      return true;
    }
  }

  Future<bool> makePost(String content) async {
    Position pos = await position;
    String postID = "${user.name}/${content}".hashCode.toString();

    final DataSnapshot snapshot = await fb.ref("posts/${postID}").get();
    if (snapshot.exists) {
      return false;
    } else {
      fb.ref("posts").update({
        "/${postID}/content": content,
        "/${postID}/lat": pos.latitude,
        "/${postID}/long": pos.longitude,
        "/${postID}/elevation": pos.altitude,
        "/${postID}/user": user.name,
        "/${postID}/profile_picture": user.profile.url,
        "/${postID}/reposts": [],
      });
      return true;
    }
  }

  repost(String postID) async {
    DatabaseReference repostList = fb.ref("posts/${postID}/reposts");
    DatabaseReference newRepostList = repostList.push();

    Position pos = await position;
    newRepostList.set({
      "/${postID}/lat": pos.latitude,
      "/${postID}/long": pos.longitude,
      "/${postID}/elevation": pos.altitude,
      "/${postID}/user": user.name,
      "/comments": {} // {postID: {post}}
    });
  }

  contactSearch(String username) async {
    final DataSnapshot snapshot = await fb.ref("users/$username").get();
    if (snapshot.exists) {
      String url = await snapshot.child("profile_picture").value as String;
      return Person(NetworkImage(url), username);
    } else {
      return null;
    }
  }

  contentSearch(String excerpt) {}

  Future<List<Post>> getComments(String postID) async {
    Map<String, Map> commentSet =
        (await fb.ref("posts/${postID}/comments").get()).value
            as Map<String, Map>;
    List<Post> temp = [];
    for (var i in commentSet.keys.toList()) {
      postID = i;
      String content = commentSet[postID]!["content"];
      String username = commentSet[postID]!["user"];
      String url = commentSet[postID]!["profile_picture"];
      temp.add(Post(content, postID, Person(NetworkImage(url), username)));
    }
    return temp;
  }

  List<Post> getShed() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  List<Post> getFeed() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  List<Post> getMessage() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  NetworkImage getShedBackground() {
    return NetworkImage(
        "https://media.buzzle.com/media/images-en/gallery/botany/trees/1200-485113177-pine-trees-on-mountain.jpg");
  }
}
