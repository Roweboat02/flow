import 'dart:async';

import 'package:flow/post.dart';
import 'package:flutter/material.dart';

class TreeView extends StatelessWidget {
  final Stream<Post> posts;
  List<Post> _posts = [];
  final Function commentOnPressed;
  final Function repostOnPressed;
  final ScrollController controller = ScrollController();
  TreeView(this.posts, this.commentOnPressed, this.repostOnPressed,
      {super.key});

  Widget buildTreeWithoutScroll(List<Post> posts) {
    return Row(children: [
      for (Post post in posts)
        Column(children: [
          post.toWidget(commentOnPressed, repostOnPressed),
          buildTreeWithoutScroll(post.comments)
        ])
    ]);
  }

  List<Widget> forPosts(List<Post> posts) {
    List<Widget> temp = [];
    for (var post in posts) {
      temp.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              post.toWidget(commentOnPressed, repostOnPressed),
              buildTreeWithoutScroll(post.comments),
            ]),
          ),
        ),
      );
      temp.add(const VerticalDivider(
        width: 20,
        thickness: 10,
        indent: 20,
        endIndent: 0,
        color: Colors.grey,
      ));
    }
    return temp;
  }

  Widget buildTree() {
    return StreamBuilder<Post>(
        stream: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            _posts.add(snapshot.data!);
            return Scrollbar(
              thumbVisibility: true,
              controller: controller,
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: forPosts(_posts),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return buildTree();
  }
}
