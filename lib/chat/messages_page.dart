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
          } else {
            return SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
