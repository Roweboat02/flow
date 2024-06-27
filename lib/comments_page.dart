import 'package:flow/database_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

class CommentsPage {
  DatabaseProxy db;
  String postID;
  CommentsPage(this.db, this.postID);
  @override
  NavigationDestination destination() {
    // TODO: implement destination
    throw UnimplementedError();
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
    temp.add(Center(
      child: ElevatedButton.icon(
          label: Text("exit"),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.exit_to_app)),
    ));
    return temp;
  }

  @override
  Widget page(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
          child: FutureBuilder(
              future: db.getComments(postID),
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
    );
  }
}
