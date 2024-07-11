import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final ref = FirebaseFirestore.instance.collection("users");
    final query = await ref.where("username", isEqualTo: username).get();
    return query.size > 0;
  }

  static Future<String> getProfilePictureURL() async {
    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return ref["profile_picture"];
  }

  static Future addFriend(String uid) async {
    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    ref.update({
      "friends": FieldValue.arrayUnion([uid]),
    });
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

  static Future<String> uploadProfilePicture(Uint8List data) async {
    Reference reference = FirebaseStorage.instance.ref();
    final ref = reference.child("users");
    final userRef = ref.child("${FirebaseAuth.instance.currentUser!.uid}");
    final imageRef = userRef.child("profile_picture.png");

    await imageRef.putData(data);
    return await imageRef.getDownloadURL();
  }

  static Future makeNewUser(String url) async {
    // Expects display name to be set
    final inst = FirebaseFirestore.instance;
    final snapshot =
        inst.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    await snapshot.set({
      "username": FirebaseAuth.instance.currentUser!.displayName!,
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "chats": [],
      "posts": [],
      "reposts": [],
      "friends": [],
      "profile_picture": url,
    });
    return true;
  }

  Future makeNewPost(String content, Uint8List? image) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String postID = "${user.name}/$content/$date".hashCode.toString();
    String? url;
    if (image != null) {
      final ref = FirebaseStorage.instance.ref("posts/$postID/picture");
      await ref.putData(image);
      url = await ref.getDownloadURL();
    }

    final ref = db.collection("posts").doc(postID);
    ref.set({
      "content": content,
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "uid": auth.currentUser!.uid,
      "profile_picture": (await getProfilePictureURL()),
      "picture": url ?? "",
      "date": date,
      "reposts": {},
      "comments": {}
    });

    final userRef = await db.collection("users").doc(auth.currentUser!.uid);
    userRef.update({
      "posts": FieldValue.arrayUnion([postID]),
    });
  }

  Future makeNewComment(String postID, String content, Uint8List? img) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String commentID =
        "${user.name}/$content/$date/$postID".hashCode.toString();
    String? url;
    if (img != null) {
      final ref =
          FirebaseStorage.instance.ref("posts/$postID/$commentID/picture");
      await ref.putData(img);
      url = await ref.getDownloadURL();
    }

    final snapshot = db
        .collection("posts")
        .doc(postID)
        .collection("comments")
        .doc(commentID);
    snapshot.set({
      "content": content,
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "uid": auth.currentUser!.uid,
      "profile_picture": await getProfilePictureURL(),
      "picture": url == null ? "" : url,
      "date": date,
      "reposts": {},
      "comments": {}
    });
  }

  Future makeNewChat(String name, List<Person> users) async {
    String date = DateTime.now().toString();
    String chatID = "$users/$name/$date".hashCode.toString();

    final ref = db.collection("chats").doc(chatID);
    ref.set({
      "name": name,
      "picture": await getProfilePictureURL(),
      "date": date,
      "uids": users.map((e) => e.uid).toList(),
      "users": users.map((e) => e.name).toList(),
      "messages": {}
    });

    for (Person user in users) {
      final ref = db.collection("users").doc(user.uid);
      ref.update({
        "chats": FieldValue.arrayUnion([chatID]),
      });
    }
  }

  makeNewMessage(String chatID, Message message) async {
    String date = DateTime.now().toString();
    final snapshot = db.collection("chat").doc(chatID);

    snapshot.update({
      "messages.date": date,
      "messages.user": message.user.name,
      "messages.uid": auth.currentUser!.uid,
      "messages.profile_picture": getProfilePictureURL(),
      "messages.content": message.content,
    });
  }

  repost(String postID) async {
    String date = DateTime.now().toString();
    String repostID = "${user.name}/$date/$postID".hashCode.toString();
    final repostList =
        db.collection("posts").doc(postID).collection("reposts").doc(repostID);

    Position pos = await position;
    repostList.set({
      "lat": pos.latitude,
      "long": pos.longitude,
      "elevation": pos.altitude,
      "user": user.name,
      "comments": {} // {postID: {post}}
    });
    final userRef = db.collection("users").doc(auth.currentUser!.uid);

    userRef.update({
      "reposts": FieldValue.arrayUnion([postID]),
    });
  }

  Future<List<Person>> contactSearch(String username) async {
    final ref = db.collection("users");
    final query = await ref.where("username", isEqualTo: username).get();

    List<Person> temp = [];
    for (var doc in query.docs) {
      Map<String, dynamic> map = doc.data();
      temp.add(Person(
          Image.network(map["profile_picture"]), map["username"], doc.id));
    }
    return temp;
  }

  contentSearch(String excerpt) async {
    final ref = db.collection("posts");
    final query =
        await ref.where("content", isGreaterThanOrEqualTo: excerpt).get();
    return query.docs;
  }

  Future<List<Post>> getComments(String postID) async {
    Map<String, dynamic> postCollection =
        (await db.collection("posts").doc(postID).get()).data()!;

    Map<String, dynamic> commentMap = postCollection["comments"];
    List<Post> temp = [];
    for (var i in commentMap.keys.toList()) {
      postID = i;
      String content = commentMap[i]["content"];
      String username = commentMap[i]["user"];
      String uid = commentMap[i]["uid"];
      String url = commentMap[i]["profile_picture"];
      String date = commentMap[i]["date"];
      num lat = commentMap[i]["lat"];
      num long = commentMap[i]["long"];
      num elevation = commentMap[i]["elevation"];
      temp.add(Post(content, postID, Person(Image.network(url), username, uid),
          lat, long, DateTime.parse(date), elevation));
    }
    return temp;
  }

  _mapToPost(Map<String, dynamic> map, String postID) {
    String content = map["content"];
    String username = map["user"];
    String uid = map["uid"];
    String profileUrl = map["profile_picture"];
    String? url = map["picture"];
    NetworkImage? img = (url == "" || url == null ? null : NetworkImage(url));
    DateTime date = DateTime.parse(map["date"]);
    num lat = map["lat"];
    num long = map["long"];
    num elevation = map["elevation"];
    return Post(
        content,
        postID,
        Person(Image.network(profileUrl), username, uid),
        lat,
        long,
        date,
        elevation,
        image: img);
  }

  Future<List<Post>> getShed() async {
    final ref = await db.collection("users").doc(auth.currentUser!.uid).get();
    Map<String, dynamic> user = ref.data()!;
    final friends = user["friends"];

    Set<String> postIDs = {};
    for (String friend in friends) {
      final postSnapshot = await db.collection("users").doc(friend).get();
      postIDs.addAll(postSnapshot.data()!["posts"]);
      postIDs.addAll(postSnapshot.data()!["reposts"]);
    }
    final postSnapshot =
        await db.collection("users").doc(auth.currentUser!.uid).get();
    Map<String, dynamic> map = postSnapshot.data()!;
    postIDs.addAll((map["posts"] as List<dynamic>).map((e) => e as String));
    postIDs.addAll((map["reposts"] as List<dynamic>).map((e) => e as String));

    List<Post> temp = [];
    for (var postID in postIDs) {
      final ref = await db.collection("posts").doc(postID).get();
      Post post = _mapToPost(ref.data()!, postID);

      final commentRef =
          await db.collection("posts").doc(postID).collection("comments").get();
      for (var c in commentRef.docs) {
        Post comment = _mapToPost(c.data(), c.id);
        comment.setComment(postID);
        post.addComment(comment);
      }
      temp.add(post);
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
      String uid = posts["user"];
      String profileURL = posts["profile_picture"];
      String url = posts["picture"];
      DateTime date = DateTime.parse(posts["date"]);
      num elevation = posts["elevation"];
      List<num> lats = [posts["lat"]];
      List<num> longs = [posts["long"]];

      final repostSnapshot = await db
          .collection("posts")
          .doc(docSnapshot.id)
          .collection("reposts")
          .get();
      for (var d in repostSnapshot.docs) {
        Map<String, dynamic> reposts = d.data();

        lats.add(reposts["lat"]!);
        longs.add(reposts["long"]!);
      }
      List<num> distances = DistanceAspect.findDistances(
          pos.latitude, pos.longitude, lats, longs);

      int loc = distances.firstWhere((e) => e == distances.reduce(min)).toInt();

      Post post = Post(
          content,
          docSnapshot.id,
          Person(Image.network(profileURL), username, uid),
          lats[loc],
          longs[loc],
          date,
          elevation,
          image: url == "" || url == null ? null : NetworkImage(url));
      final commentRef = await db
          .collection("posts")
          .doc(docSnapshot.id)
          .collection("comments")
          .get();
      for (var c in commentRef.docs) {
        Post comment = _mapToPost(c.data(), c.id);
        comment.setComment(docSnapshot.id);
        post.addComment(comment);
      }

      temp.add(post);
    }
    return await RelativityGod().sort(temp);
  }

  Future<List<Chat>> getChats() async {
    final snapshot = await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .get();

    List<Chat> temp = [];
    for (var docSnapshot in snapshot.docs) {
      List<Message> messages = [];
      for (Map message in docSnapshot["messages"]) {
        messages.add(Message(message["content"],
            Person(message["picture"], message["user"], message["user"])));
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
