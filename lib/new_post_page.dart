import 'package:flow/database_proxy.dart';
import 'package:flow/page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

class NewPostPage implements MyPage {
  DatabaseProxy db;
  NewPostPage(this.db);

  @override
  NavigationDestination destination() {
    // TODO: implement destination
    throw UnimplementedError();
  }

  @override
  List<Widget> getContent(List<Post> posts, BuildContext context) {
    // TODO: implement getContent
    throw UnimplementedError();
  }

  @override
  Widget page(BuildContext context) {
    // TODO: implement page
    throw UnimplementedError();
  }
}
