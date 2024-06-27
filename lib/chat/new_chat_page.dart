import 'package:flow/database_proxy.dart';
import 'package:flow/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

class NewChatPage implements MyPage {
  DatabaseProxy db;
  final TextEditingController _searchController = TextEditingController();
  NewChatPage(this.db);

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
    return Scaffold(
        body: Column(
      children: [
        Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Contacts...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Navigator.pop(context);
                  },
                ),
                // Add a search icon or button to the search bar
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    db.contactSearch(_searchController.text.toString());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            )),
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ) // contact list updates as searches
      ],
    ));
  }
}
