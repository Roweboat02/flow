import 'package:flow/database_proxy.dart';
import 'package:flow/new_comment_page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flow/tree_view.dart';
import 'package:flutter/material.dart';

class Feed {
  DatabaseProxy db;
  Person user;

  Feed(this.db, this.user);

  NavigationDestination destination() {
    return const NavigationDestination(
      selectedIcon: Icon(Icons.view_list),
      icon: Icon(Icons.view_list),
      label: 'Feed',
    );
  }

  Widget page(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
              child: TreeView(
                  db.getFeed(),
                  (String postID) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewCommentPage(db, postID))),
                  (String postID) => db.repost(postID))),
        ));
  }
}
