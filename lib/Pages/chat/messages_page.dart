import 'package:flow/Pages/chat/chat.dart';
import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flow/Constructs/person.dart';
import 'package:flutter/material.dart';

class MessagesPage {
  DatabaseProxy db;
  Chat chat;
  Person user;
  TextEditingController controller = TextEditingController();

  MessagesPage(this.db, this.chat, this.user);

  Widget page(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          reverse: true,
          itemCount: chat.messages.length,
          itemBuilder: (BuildContext context, int index) {
            if (chat.messages[index].user.name == user.name) {
              return Align(
                  alignment: Alignment.centerLeft,
                  child: chat.messages[index].toWidget(context));
            }
            return Align(
                alignment: Alignment.centerRight,
                child: chat.messages[index].toWidget(context));
          },
        ),
        ElevatedButton.icon(
            label: const Text("exit"),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Write message...",
                    )),
                IconButton(
                    onPressed: () {
                      String message = controller.text;
                      controller.clear();
                      db.makeNewMessage(chat.chatID, Message(message, user));
                    },
                    icon: const Icon(Icons.send)),
              ],
            ))
      ],
    );
  }
}
