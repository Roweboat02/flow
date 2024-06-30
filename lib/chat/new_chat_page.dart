import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class NewChatPage extends StatefulWidget {
  final DatabaseProxy db;
  final Person user;

  const NewChatPage(this.db, this.user, {super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> users = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Contact Or Chat Name On Send...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    Navigator.pop(context);
                  },
                ),
                // Add a search icon or button to the search bar
                prefixIcon: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        users.add(_searchController.text);
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      users.add(widget.user.name);
                      widget.db.makeNewChat(_searchController.text, users);
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
        Text(users.toString()),
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ) // contact list updates as searches
      ],
    );
  }
}
