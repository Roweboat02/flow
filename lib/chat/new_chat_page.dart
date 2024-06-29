import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

class NewChatPage {
  DatabaseProxy db;
  final TextEditingController _searchController = TextEditingController();
  Person user;
  List<String> users = [];

  NewChatPage(this.db, this.user);

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
                hintText: "Contact Or Chat Name On Send...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    Navigator.pop(context);
                  },
                ),
                // Add a search icon or button to the search bar
                prefixIcon: Row(children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      users.add(_searchController.text);
                      _searchController.clear();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      users.add(user.name);
                      db.makeNewChat(_searchController.text, users);
                      _searchController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ]),
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
