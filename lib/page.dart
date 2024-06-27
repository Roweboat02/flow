import 'package:flow/database_proxy.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';

abstract class MyPage {
  Widget page(BuildContext context);
  NavigationDestination destination();

  Future<List<Widget>> getContent(
      List<Post> posts, BuildContext context) async {
    List<Widget> temp = [];
    for (Post e in posts) {
      temp.add(SizedBox(child: e.toWidget()));
    }
    return temp;
  }
}
