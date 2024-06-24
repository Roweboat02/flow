import 'package:firebase_core/firebase_core.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/feed_page.dart';
import 'package:flow/login_screen.dart';
import 'package:flow/shed_page.dart';
import 'package:flow/messages_page.dart';
import 'package:flow/page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';
import 'package:flow/signup_screen.dart';
import 'package:flow/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'new_chat_page.dart';
import 'new_post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighbor',
      initialRoute: "welcome_screen",
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => NavigationExample(title: 'Neighbor')
        //https://medium.com/code-for-cause/flutter-registration-login-using-firebase-5ada3f14c066
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const NavigationExample(title: 'Neighbor'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: currentPageIndex != 2
            ? () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPostPage(db).page(context)))
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewChatPage(db).page(context))),
      ),
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
