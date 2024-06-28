import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flow/chat/new_chat_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/feed_page.dart';
import 'package:flow/login/google_sign_in.dart';

import 'package:flow/shed_page.dart';
import 'package:flow/chat/chats_page.dart';
import 'package:flow/person.dart';
import 'package:flow/post.dart';

import 'package:flutter/material.dart';

import 'login/login_screen.dart';
import 'login/signup_screen.dart';
import 'login/welcome_screen.dart';
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
        'home_screen': (context) => NavigationExample(title: 'Neighbor'),
        'google_login_screen': (context) => GoogleSignInScreen()
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
  late FirebaseMessaging messaging;

  late DatabaseProxy db;
  late List pages;
  late Person user;
  int currentPageIndex = 0;

  @override
  Future<void> initState() async {
    user = Person(await DatabaseProxy.getUserImage(),
        FirebaseAuth.instance.currentUser!.uid);
    db = DatabaseProxy(user);

    pages = [Shed(db, user), Feed(db, user), ChatsPage(db, user)];
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
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
          destinations:
              pages.map((page) => page.destination()).toList() as List<Widget>),
      body: pages.map((page) => page.page(context)).toList()[currentPageIndex],
    );
  }
}
