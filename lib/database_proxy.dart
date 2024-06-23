import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';

class DatabaseProxy {
  late Person user;
  DatabaseProxy(username) {
    user = Person(
        NetworkImage(
            "https://fthmb.tqn.com/TAO44DCR8TZRNVwD6OlGfFtfi30=/5040x3347/filters:fill(auto,1)/greyhound-dog-outdoors-200346044-001-589608495f9b5874ee23ee68.jpg"),
        username);
  }

  List<Post> getComments(String postID) {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  List<Post> getMessage() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  List<Post> getShed() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }

  List<Post> getFeed() {
    return [
      Post(
          "Hello World",
          "0",
          Person(
              const NetworkImage(
                  "https://paradepets.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTkxMzY1Nzg4NjczMzIwNTQ2/cutest-dog-breeds-jpg.jpg"),
              "Test Person"))
    ];
  }
}
