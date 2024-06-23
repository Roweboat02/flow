import 'package:flow/database_proxy.dart';
import 'package:flow/feed_page.dart';
import 'package:flow/home_page.dart';
import 'package:flow/messages_page.dart';
import 'package:flow/page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationExample(title: 'Posts'),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key, required this.title});

  final String title;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  DatabaseProxy db = DatabaseProxy("Me");
  late List<MyPage> pages;
  int currentPageIndex = 0;

  @override
  void initState() {
    pages = [Shed(db), Feed(db), Messages(db)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: pages.map((page) => page.destination()).toList()),
      body: pages.map((page) => page.page(context)).toList()[currentPageIndex],
    );
  }
}
