import 'package:flow/chat_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/page.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';

class Messages implements MyPage {
  DatabaseProxy db;
  Messages(this.db);

  @override
  NavigationDestination destination() {
    return NavigationDestination(
      icon: Icon(Icons.messenger_sharp),
      label: 'Messages',
    );
  }

  @override
  List<Widget> getContent(List<Post> posts, BuildContext context) {
    List<Widget> temp = [];
    for (Post e in posts) {
      temp.add(GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: e.toWidget(),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(db, e.postID).page(context)));
        },
      ));
    }
    return temp;
  }

  @override
  Widget page(BuildContext context) {
    return ListView(
      children: getContent(db.getMessage(), context),
    );
  }
}
