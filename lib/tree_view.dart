import 'package:flow/post.dart';
import 'package:flutter/material.dart';

class TreeView extends StatelessWidget {
  final List<Post> posts;
  final Function commentOnPressed;
  final Function repostOnPressed;
  const TreeView(this.posts, this.commentOnPressed, this.repostOnPressed,
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

  Widget buildTree(List<Post> posts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (Post post in posts)
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  post.toWidget(commentOnPressed, repostOnPressed),
                  buildTreeWithoutScroll(post.comments)
                ]))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTree(posts);
  }
}
