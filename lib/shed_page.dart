import 'package:flow/comments_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';

class Shed {
  DatabaseProxy db;
  Person user;
  Shed(this.db, this.user);

  @override
  NavigationDestination destination() {
    return const NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Shed',
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
                    future: DatabaseProxy.getUserImage(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          backgroundImage: snapshot.data,
                          radius: 50,
                        );
                      } else {
                        return SizedBox(
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
                    return ListView(
                      shrinkWrap: true,
                      children: getContent(snapshot.data!, context),
                    );
                  } else {
                    return SizedBox(
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
