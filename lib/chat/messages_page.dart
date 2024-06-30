import 'package:flow/chat/chat.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class MessagesPage {
  DatabaseProxy db;
  String chatID;
  Person user;
  TextEditingController controller = TextEditingController();
  late Future<List<Message>> messages;

  MessagesPage(this.db, this.chatID, this.user) {
    messages = db.getMessages(chatID);
  }

  Widget page(BuildContext context) {
    return FutureBuilder(
        future: messages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data![index].user.name == user.name) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: snapshot.data![index].toWidget(context));
                    }
                    return Align(
                        alignment: Alignment.centerRight,
                        child: snapshot.data![index].toWidget(context));
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
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.add)),
                        TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Write message...",
                            )),
                        IconButton(
                            onPressed: () {
                              String message = controller.text;
                              controller.clear();
                              db.makeNewMessage(chatID, Message(message, user));
                            },
                            icon: const Icon(Icons.send)),
                      ],
                    ))
              ],
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
