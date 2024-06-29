import 'dart:io';
import 'dart:math';

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

  final fb = FirebaseDatabase.instance;
  // https://medium.com/firebase-tips-tricks/how-to-use-firebase-realtime-database-with-flutter-ebd98aba2c91
  final auth = FirebaseAuth.instance;

  static Future<NetworkImage> getUserImage() async {
    final String url = await FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}/profile_picture")
        .get() as String;
    return NetworkImage(url);
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

  static Future<bool> newUser(String username, String profilePicture) async {
    final inst = FirebaseDatabase.instance;
    final DataSnapshot snapshot = await inst.ref("users/$username").get();
    if (snapshot.exists) {
      return false;
    } else {
      inst.ref("users").update({
        "$username/chats": [],
        "$username/posts": {},
        "$username/reposts": {},
        "$username/friends": {},
        "$username/profile_picture": profilePicture,
      });
      return true;
    }
  }

  Future<bool> makePost(String content) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String postID = "${user.name}/$content/$date".hashCode.toString();

    final DataSnapshot snapshot = await fb.ref("posts/$postID").get();
    if (snapshot.exists) {
      return false;
    } else {
      fb.ref("posts").update({
        "$postID/content": content,
        "$postID/lat": pos.latitude,
        "$postID/long": pos.longitude,
        "$postID/elevation": pos.altitude,
        "$postID/user": user.name,
        "$postID/profile_picture": user.profile.url,
        "$postID/date": date,
        "$postID/reposts": {},
        "$postID/comments/": {}
      });
      return true;
    }
  }

  Future<bool> makeComment(String postID, String content) async {
    Position pos = await position;
    String date = DateTime.now().toString();
    String commentID =
        "${user.name}/$content/$date/postID".hashCode.toString();

    final DataSnapshot snapshot = await fb.ref("posts/$postID").get();
    if (snapshot.exists) {
      return false;
    } else {
      fb.ref("posts/$postID/comments/$commentID").update({
        "content": content,
        "lat": pos.latitude,
        "long": pos.longitude,
        "elevation": pos.altitude,
        "user": user.name,
        "profile_picture": user.profile.url,
        "date": date,
        "reposts": {},
      });
      return true;
    }
  }

  Future<bool> makeNewChat(String name, List<String> users) async {
    String date = DateTime.now().toString();
    String chatID = "$users/$name/$date".hashCode.toString();

    fb.ref("chats").update({
      "$chatID/name": name,
      "$chatID/profile_picture": user.profile.url,
      "$chatID/date": date,
      "$chatID/messages": {}
    });

    for (String user in users) {
      DatabaseReference ref = fb.ref("users/$user/chats").push();
      ref.set(chatID);
    }
    return true;
  }

  newMessage(String chatID, Message message) {
    String date = DateTime.now().toString();
    DatabaseReference snapshot = fb.ref("chat/$chatID");
    DatabaseReference newMessage = snapshot.child("messages").push();

    newMessage.update({
      "date": date,
      "user": message.user.name,
      "profile_picture": message.user.profile.url,
      "content": message.content,
    });
  }

  repost(String postID) async {
    DatabaseReference repostList = fb.ref("posts/$postID/reposts");
    DatabaseReference newRepostList = repostList.push();

    Position pos = await position;
    newRepostList.set({
      "/$postID/lat": pos.latitude,
      "/$postID/long": pos.longitude,
      "/$postID/elevation": pos.altitude,
      "/$postID/user": user.name,
      "/comments": {} // {postID: {post}}
    });
  }

  contactSearch(String username) async {
    final DataSnapshot snapshot = await fb.ref("users/$username").get();
    if (snapshot.exists) {
      String url = snapshot.child("profile_picture").value as String;
      return Person(NetworkImage(url), username);
    } else {
      return null;
    }
  }

  contentSearch(String excerpt) {}

  Future<List<Post>> getComments(String postID) async {
    Map<String, Map> commentSet =
        (await fb.ref("posts/$postID/comments").get()).value
            as Map<String, Map>;
    List<Post> temp = [];
    for (var i in commentSet.keys.toList()) {
      postID = i;
      String content = commentSet[postID]!["content"];
      String username = commentSet[postID]!["user"];
      String url = commentSet[postID]!["profile_picture"];
      String date = commentSet[postID]!["date"];
      num lat = commentSet[postID]!["lat"];
      num long = commentSet[postID]!["long"];
      num elevation = commentSet[postID]!["elevation"];
      temp.add(Post(content, postID, Person(NetworkImage(url), username), lat,
          long, DateTime.parse(date), elevation));
    }
    return temp;
  }

  Future<List<Post>> getShed() async {
    List<String> friends = await fb
        .ref("users/${auth.currentUser!.uid}/friends")
        .get() as List<String>;
    List<Post> temp = [];
    for (String friend in friends) {
      Map<String, Map> psts =
          await fb.ref("users/$friend/posts").get() as Map<String, Map>;
      Map<String, Map> rpsts =
          await fb.ref("users/$friend/reposts").get() as Map<String, Map>;

      for (var pstID in psts.keys) {
        String content = psts[pstID]!["content"];
        String username = psts[pstID]!["user"];
        String url = psts[pstID]!["profile_picture"];
        DateTime date = DateTime.parse(psts[pstID]!["date"]);
        num lat = psts[pstID]!["lat"];
        num long = psts[pstID]!["long"];
        num elevation = psts[pstID]!["elevation"];
        temp.add(Post(content, pstID, Person(NetworkImage(url), username), lat,
            long, date, elevation));
      }
      for (var rpstID in rpsts.keys) {
        String content = rpsts[rpstID]!["content"];
        String username = rpsts[rpstID]!["user"];
        String url = rpsts[rpstID]!["profile_picture"];
        DateTime date = DateTime.parse(rpsts[rpstID]!["date"]);
        num lat = rpsts[rpstID]!["lat"];
        num long = rpsts[rpstID]!["long"];
        num elevation = rpsts[rpstID]!["elevation"];
        temp.add(Post(content, rpstID, Person(NetworkImage(url), username), lat,
            long, date, elevation));
      }
    }
    return temp;
  }

  Future<List<Post>> getFeed() async {
    Map<String, Map> prePosts = fb.ref("posts").get() as Map<String, Map>;
    List<Post> temp = [];
    Position pos = await position;

    for (var pstID in prePosts.keys) {
      String content = prePosts[pstID]!["content"];
      String username = prePosts[pstID]!["user"];
      String url = prePosts[pstID]!["profile_picture"];
      DateTime date = DateTime.parse(prePosts[pstID]!["date"]);
      num elevation = prePosts[pstID]!["elevation"];
      List<num> lats = prePosts[pstID]!["lat"];
      List<num> longs = prePosts[pstID]!["long"];
      Map<String, Map> reposts = prePosts[pstID]!["reposts"];
      for (String repostID in reposts.keys) {
        lats.add(reposts[repostID]!["lat"]);
        longs.add(reposts[repostID]!["long"]);
      }
      List<num> distances = DistanceAspect.findDistances(
          pos.latitude, pos.longitude, lats, longs);

      int loc = distances.firstWhere((e) => e == distances.reduce(min)) as int;
      temp.add(Post(content, pstID, Person(NetworkImage(url), username),
          lats[loc], longs[loc], date, elevation));
    }

    return await RelativityGod().sort(temp);
  }

  Future<List<Chat>> getChats() async {
    List<String> chatIDs =
        await fb.ref("users/${user.name}/chats").get() as List<String>;
    List<Chat> temp = [];
    for (String chatID in chatIDs) {
      Map chat = fb.ref("chats/$chatID").get() as Map;
      List<Message> messages = [];
      for (Map message in chat["messages"]) {
        messages.add(Message(
            message["content"], Person(message["picture"], message["user"])));
      }
      temp.add(Chat(messages, chat["name"], chat["users"], chatID,
          NetworkImage(chat["picture"])));
    }
    return temp;
  }

  Future<List<Message>> getMessages(String chatID) async {
    List<Map> messages =
        await fb.ref("chats/$chatID/messages").get() as List<Map>;
    List<Message> temp = [];
    for (var message in messages) {
      temp.add(Message(message["content"], message["user"]));
    }
    return temp;
  }

  NetworkImage getShedBackground() {
    return const NetworkImage(
        "https://media.buzzle.com/media/images-en/gallery/botany/trees/1200-485113177-pine-trees-on-mountain.jpg");
  }
}
