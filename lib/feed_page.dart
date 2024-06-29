import 'package:flow/database_proxy.dart';
import 'package:flow/main.dart';
import 'package:flow/new_comment_page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flow/tree_view.dart';
import 'package:flutter/material.dart';

class Feed {
  DatabaseProxy db;
  Person user;
  Feed(this.db, this.user);

  @override
  NavigationDestination destination() {
    return const NavigationDestination(
      selectedIcon: Icon(Icons.view_list),
      icon: Icon(Icons.view_list),
      label: 'Feed',
    );
  }

  @override
  Widget page(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(
              child: FutureBuilder(
                  future: db.getFeed(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return TreeView(
                          snapshot.data!,
                          (String postID) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewCommentPage(db, postID))),
                          (String postID) => db.repost(postID));
                    } else {
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))),
        ));
  }
}
