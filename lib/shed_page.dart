import 'package:flow/database_proxy.dart';
import 'package:flow/new_comment_page.dart';
import 'package:flow/person.dart';
import 'package:flow/tree_view.dart';
import 'package:flutter/material.dart';

class Shed {
  DatabaseProxy db;
  Person user;
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
                FutureBuilder(
                    future: DatabaseProxy.getProfilePictureURL(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          backgroundImage: snapshot.data!.image,
                          radius: 50,
                        );
                      } else {
                        return const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))
              ],
            ),
            FutureBuilder(
                future: db.getShed(),
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
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
          ],
        ));
  }
}
