import 'package:flow/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

import 'database_proxy.dart';

class ChatPage implements MyPage {
  DatabaseProxy db;
  String postID;

  ChatPage(this.db, this.postID);
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
    /// Messages page
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
        ElevatedButton.icon(
            label: Text("exit"),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.exit_to_app)),
      ],
    );
  }
}
