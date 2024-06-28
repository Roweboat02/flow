import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flow/chat/chat.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:flow/post.dart';

class MessagesPage {
  DatabaseProxy db;
  String chatID;
  Person user;
  TextEditingController controller = TextEditingController();

  MessagesPage(this.db, this.chatID, this.user);

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
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Write message...",
                    )),
                IconButton(
                    onPressed: () {
                      String message = controller.text;
                      controller.clear();
                      db.newMessage(chatID, Message(message, user));
                    },
                    icon: Icon(Icons.send)),
              ],
            ))
      ],
    );
  }
}
