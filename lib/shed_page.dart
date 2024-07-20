import 'package:flow/database_proxy.dart';
import 'package:flow/new_comment_page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flow/tree_view.dart';
import 'package:flutter/material.dart';

class Shed {
  DatabaseProxy db;
  Person user;
  List<Post> posts = [];

  Shed(this.db, this.user);

  static NavigationDestination destination() {
    return const NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Shed',
    );
  }

  Widget page(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: db.getShedBackground(),
                            fit: BoxFit.fitWidth))),
                Row(
                  children: [
                    FutureBuilder(
                        future: DatabaseProxy.getProfilePictureURL(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!),
                              radius: 50,
                            );
                          } else {
                            return const SizedBox(
                              width: 60,
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.name,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-2, -2),
                                  color: Colors.black),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(2, -2),
                                  color: Colors.black),
                              Shadow(
                                  // topRight
                                  offset: Offset(2, 2),
                                  color: Colors.black),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-2, 2),
                                  color: Colors.black),
                            ]),
                      ),
                    ),
                  ],
                )
              ],
            ),
            StreamBuilder<Post>(
                stream: db.getShed(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      posts.add(snapshot.data!);
                    }
                    return TreeView(
                        posts.toSet(),
                        (String postID) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewCommentPage(db, postID))),
                        (String postID) => db.repost(postID));
                  }
                })
          ],
        ));
  }
}
