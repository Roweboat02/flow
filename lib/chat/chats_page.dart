import 'package:flow/chat/chat.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flutter/material.dart';

import 'messages_page.dart';

class ChatsPage {
  //https://medium.com/@samra.sajjad0001/exploring-firebase-cloud-messaging-fcm-in-flutter-53d99d03b985
  DatabaseProxy db;
  Person user;
  ChatsPage(this.db, this.user);

  static NavigationDestination destination() {
    return const NavigationDestination(
      icon: Icon(Icons.messenger_sharp),
      label: 'Messages',
    );
  }

  List<Widget> getContent(List<Chat> chats, BuildContext context) {
    List<Widget> temp = [];
    for (Chat e in chats) {
      temp.add(GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: e.toWidget(),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MessagesPage(db, e.chatID, user).page(context)));
        },
      ));
    }
    return temp;
  }

  Widget page(BuildContext context) {
    return FutureBuilder(
        future: db.getChats(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: getContent(snapshot.data!, context),
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
