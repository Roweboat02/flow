import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class Message {
  String content;
  Person user;
  Message(this.content, this.user);

  Widget toWidget(context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: user.profile,
                        radius: 30.0,
                      ),
                      Text(user.name, textAlign: TextAlign.left),
                    ],
                  ),
                ),
                Text(content, style: TextStyle(fontSize: 18.0))
              ],
            ),
          ],
        ));
  }
}

class Chat {
  List<Message> messages;
  String name;
  List<Person> users;
  String chatID;
  NetworkImage picture;
  Chat(this.messages, this.name, this.users, this.chatID, this.picture);

  Widget toWidget() {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(219, 219, 219, 1),
            border: Border.all(
              color: Color.fromRGBO(219, 219, 219, 1),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: picture,
                        radius: 30.0,
                      ),
                      Text(name, textAlign: TextAlign.left),
                    ],
                  ),
                ),
                Text(messages[messages.length - 1].content,
                    style: TextStyle(fontSize: 18.0))
              ],
            ),
          ],
        ));
  }
}
