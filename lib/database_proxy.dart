import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flow/chat/chat.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flow/post_sorting/distance_aspect.dart';
import 'package:flow/post_sorting/relativity_god.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseProxy {
  late Person user;

  DatabaseProxy(this.user);

  final db = FirebaseFirestore.instance;
  // https://medium.com/firebase-tips-tricks/how-to-use-firebase-realtime-database-with-flutter-ebd98aba2c91
  final auth = FirebaseAuth.instance;

  static Future<bool> userExists(String username) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc("$username")
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Image> getProfilePictureURL() async {
    return Image.network(FirebaseAuth.instance.currentUser!.photoURL!);
  }

  static Future<Position> get position async {
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

  static Future<String> uploadProfilePicture(String fileName) async {
    Reference reference = FirebaseStorage.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");
    Reference imageRef = reference.child(fileName);
    await reference.putFile(File(fileName));
    return imageRef.getDownloadURL();
  }

  static Future makeNewUser() async {
    // Expects display name to be set
    final inst = FirebaseFirestore.instance;
    final snapshot = inst
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser!.uid}");
    snapshot.update({
      "username": FirebaseAuth.instance.currentUser!.displayName!,
      "chats": [],
      "posts": {},
      "reposts": {},
      "friends": {},
      "profile_picture": getProfilePictureURL(),
    });
    return true;
  }

  Future makeNewPost(String content, String? imagePath) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String postID = "${user.name}/$content/$date".hashCode.toString();
    String? url;
    if (imagePath != null) {
      final ref = FirebaseStorage.instance.ref("posts/${postID}/picture");
      await ref.putFile(File(imagePath));
      url = await ref.getDownloadURL();
    }

    final snapshot = await db.collection("posts").doc("$postID");
    final ref = db.collection("posts").doc("$postID");
    ref.update({
      "content": content,
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "profile_picture": getProfilePictureURL(),
      "picture": url != null ? url : "",
      "date": date,
      "reposts": {},
      "comments": {}
    });
  }

  Future makeComment(String postID, String content) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String commentID =
        "${user.name}/$content/$date/$postID".hashCode.toString();

    final snapshot = await db
        .collection("posts")
        .doc("$postID")
        .collection("comments")
        .doc("$commentID");
    snapshot.update({
      "content": content,
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "profile_picture": getProfilePictureURL(),
      "date": date,
      "reposts": {},
    });
  }

  Future makeNewChat(String name, List<String> users) async {
    String date = DateTime.now().toString();
    String chatID = "$users/$name/$date".hashCode.toString();

    final ref = db.collection("chats").doc("$chatID");
    ref.update({
      "name": name,
      "profile_picture": getProfilePictureURL(),
      "date": date,
      "messages": {}
    });

    for (String user in users) {
      final ref = db.collection("users").doc("$user");
      ref.set({"chats.$chatID": {}});
    }
  }

  makeNewMessage(String chatID, Message message) async {
    String date = DateTime.now().toString();
    final snapshot = db.collection("chat").doc("$chatID");

    snapshot.update({
      "messages.date": date,
      "messages.user": message.user.name,
      "messages.profile_picture": getProfilePictureURL(),
      "messages.content": message.content,
    });
  }

  repost(String postID) async {
    final repostList = db
        .collection("posts")
        .doc("$postID")
        .collection("reposts")
        .doc("$postID");

    Position pos = await position;
    repostList.set({
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "comments": {} // {postID: {post}}
    });
  }

  Future<bool> contactSearch(String username) async {
    final ref = db.collection("users");
    final query = await ref.where("username", isEqualTo: username).get();
    return query.size > 0;
  }

  contentSearch(String excerpt) async {
    final ref = db.collection("posts");
    final query =
        await ref.where("content", isGreaterThanOrEqualTo: excerpt).get();
    return query.docs;
  }

  Future<List<Post>> getComments(String postID) async {
    Map<String, dynamic> postCollection =
        (await db.collection("posts").doc("$postID").get()).data()!;

    Map<String, dynamic> commentMap = postCollection["comments"];
    List<Post> temp = [];
    for (var i in commentMap.keys.toList()) {
      postID = i;
      String content = commentMap[i]["content"];
      String username = commentMap[i]["user"];
      String url = commentMap[i]["profile_picture"];
      String date = commentMap[i]["date"];
      num lat = commentMap[i]["lat"];
      num long = commentMap[i]["long"];
      num elevation = commentMap[i]["elevation"];
      temp.add(Post(content, postID, Person(Image.network(url), username), lat,
          long, DateTime.parse(date), elevation));
    }
    return temp;
  }

  Future<List<Post>> getShed() async {
    final ref =
        await db.collection("users").doc("${auth.currentUser!.uid}").get();
    Map<String, dynamic> user = ref.data()!;
    final friends = user["friends"] as List<String>;

    List<Post> temp = [];
    for (String friend in friends) {
      final postSnapshot =
          await db.collection("users").doc(friend).collection("posts").get();
      final repostSnapshot =
          await db.collection("users").doc(friend).collection("reposts").get();

      for (var docSnapshot in postSnapshot.docs) {
        Map<String, dynamic> posts = docSnapshot.data();
        String content = posts["content"];
        String username = posts["user"];
        String profile_url = posts["profile_picture"];
        String? url = posts["picture"];
        NetworkImage? img = (url == "" ? null : NetworkImage(url!));
        DateTime date = DateTime.parse(posts["date"]);
        num lat = posts["lat"];
        num long = posts["long"];
        num elevation = posts["elevation"];
        Post post = Post(
            content,
            docSnapshot.id,
            Person(Image.network(profile_url), username),
            lat,
            long,
            date,
            elevation);
        post.addImage(img);
        temp.add(post);
      }
      for (var docSnapshot in repostSnapshot.docs) {
        Map<String, dynamic> reposts = docSnapshot.data();
        String content = reposts["content"];
        String username = reposts["user"];
        String url = reposts["profile_picture"];
        DateTime date = DateTime.parse(reposts["date"]);
        num lat = reposts["lat"];
        num long = reposts["long"];
        num elevation = reposts["elevation"];
        temp.add(Post(content, docSnapshot.id,
            Person(Image.network(url), username), lat, long, date, elevation));
      }
    }
    return temp;
  }

  Future<List<Post>> getFeed() async {
    final postCollection = await db.collection("posts").get();
    List<Post> temp = [];
    Position pos = await position;

    for (var docSnapshot in postCollection.docs) {
      Map<String, dynamic> posts = docSnapshot.data();
      String content = posts["content"];
      String username = posts["user"];
      String url = posts["profile_picture"];
      DateTime date = DateTime.parse(posts["date"]);
      num elevation = posts["elevation"];
      List<num> lats = posts["lat"];
      List<num> longs = posts["long"];

      Map<String, Map> reposts = posts["reposts"];
      for (String repostID in reposts.keys) {
        lats.add(reposts[repostID]!["lat"]);
        longs.add(reposts[repostID]!["long"]);
      }
      List<num> distances = DistanceAspect.findDistances(
          pos.latitude, pos.longitude, lats, longs);

      int loc = distances.firstWhere((e) => e == distances.reduce(min)) as int;
      temp.add(Post(
          content,
          docSnapshot.id,
          Person(Image.network(url), username),
          lats[loc],
          longs[loc],
          date,
          elevation));
    }

    return await RelativityGod().sort(temp);
  }

  Future<List<Chat>> getChats() async {
    final snapshot = await db
        .collection("users")
        .doc(auth.currentUser!.uid!)
        .collection("chats")
        .get();

    List<Chat> temp = [];
    for (var docSnapshot in snapshot.docs) {
      List<Message> messages = [];
      for (Map message in docSnapshot["messages"]) {
        messages.add(Message(
            message["content"], Person(message["picture"], message["user"])));
      }
      temp.add(Chat(messages, docSnapshot["name"], docSnapshot["users"],
          docSnapshot.id, NetworkImage(docSnapshot["picture"])));
    }
    return temp;
  }

  NetworkImage getShedBackground() {
    return const NetworkImage(
        "https://media.buzzle.com/media/images-en/gallery/botany/trees/1200-485113177-pine-trees-on-mountain.jpg");
  }
}
