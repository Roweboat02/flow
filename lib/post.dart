import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class Post {
  String content;
  String postID;
  Person poster;

  Post(this.content, this.postID, this.poster);

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
                        backgroundImage: poster.profile,
                        radius: 30.0,
                      ),
                      Text(poster.name, textAlign: TextAlign.left),
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
