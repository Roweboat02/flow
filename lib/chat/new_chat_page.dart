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
  Set<Person> users = {};
  Future<List<Person>>? searchResults;

  addSearchResults(Future<List<Person>> results) {
    searchResults = results;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 50, 8.0, 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Contact Or Chat Name On Send...",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          users.add(widget.user);
                          widget.db.makeNewChat(
                              _searchController.text, users.toList());
                          _searchController.clear();
                          Navigator.pop(context);
                        },
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            addSearchResults(widget.db
                                .contactSearch(_searchController.text));
                            _searchController.clear();
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(users.map((e) => e.name).toString())),
        searchResults == null
            ? Column()
            : FutureBuilder(
                future: searchResults,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    users.add(snapshot.data![index]);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.add)),
                              snapshot.data![index].toWidget()
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                }))
      ],
    ));
  }
}
