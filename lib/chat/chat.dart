import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class Message {
  String content;
  Person user;
  Message(this.content, this.user);
}

class Chat {
  List<Message> messages;
  String name;
  List<Person> users;
  Chat(this.messages, this.name, this.users);
}
