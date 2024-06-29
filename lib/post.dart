import 'package:flow/person.dart';
import 'package:flutter/material.dart';

class Post {
  String content;
  String postID;
  Person poster;
  num lat;
  num long;
  num elevation;
  DateTime date;
  List<Post> comments = [];
  NetworkImage? image;

  addComment(Post comment) {
    comments.add(comment);
  }

  addImage(NetworkImage img) {
    image = img;
  }

  addComments(List<Post> comments) {
    comments.addAll(comments);
  }

  Post(this.content, this.postID, this.poster, this.lat, this.long, this.date,
      this.elevation,
      {this.image = null});

  Widget toWidget(Function commentOnPressed, Function repostOnPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(219, 219, 219, 1),
              border: Border.all(
                color: Color.fromRGBO(219, 219, 219, 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Column(
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
                      Row(
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => const DetailPicture()),
                          //     );
                          //   },
                          if (image != null)
                            SizedBox(
                                width: 250,
                                height: 400,
                                child: Image(image: image!)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text(content, style: TextStyle(fontSize: 18.0)),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () => repostOnPressed(postID),
                      icon: Icon(Icons.repeat)),
                  IconButton(
                      onPressed: () => commentOnPressed(postID),
                      icon: Icon(Icons.comment))
                ],
              ),
            ],
          )),
    );
  }
}
