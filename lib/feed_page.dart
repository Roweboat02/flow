import 'package:flow/comments_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
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
  List<Widget> getContent(List<Post> posts, BuildContext context) {
    List<Widget> temp = [];
    for (Post e in posts) {
      temp.add(Row(children: [
        Expanded(child: e.toWidget()),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  db.repost(e.postID);
                },
                icon: Icon(Icons.repeat)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommentsPage(db, e.postID).page(context)));
                },
                icon: Icon(Icons.comment))
          ],
        ),
      ]));
    }
    return temp;
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
                      return ListView(
                        children: getContent(snapshot.data!, context),
                      );
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
