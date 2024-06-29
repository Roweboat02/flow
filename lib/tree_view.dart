import 'package:flow/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TreeView extends StatelessWidget {
  final List<Post> posts;
  final Function commentOnPressed;
  final Function repostOnPressed;
  const TreeView(this.posts, this.commentOnPressed, this.repostOnPressed,
      {super.key});

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
                  buildTree(post.comments)
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
