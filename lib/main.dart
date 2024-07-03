import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow/chat/chats_page.dart';
import 'package:flow/database_proxy.dart';
import 'package:flow/feed_page.dart';
import 'package:flow/login/login_screen.dart';
import 'package:flow/shed_page.dart';
import 'package:flow/person.dart';
import 'package:flow/login/signup_screen.dart';
import 'package:flow/login/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'chat/new_chat_page.dart';
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
  late DatabaseProxy db;
  late List pages;
  late Person user;
  int currentPageIndex = 0;

  @override
  void initState() {
    user = Person(Image.file(File('assets/images/default_profile.png')),
        FirebaseAuth.instance.currentUser!.displayName!);
    user.setProfilePicture(DatabaseProxy.getProfilePictureURL());
    db = DatabaseProxy(user);
    pages = [Shed(db, user), Feed(db, user), ChatsPage(db, user)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: currentPageIndex != 2
            ? () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewPostPage(db)))
            : () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewChatPage(db, user))),
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: [
            const NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Shed',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Icons.view_list),
              icon: Icon(Icons.view_list),
              label: 'Feed',
            ),
            const NavigationDestination(
              icon: Icon(Icons.messenger_sharp),
              label: 'Messages',
            )
          ]),
      body: pages.map((page) => page.page(context)).toList()[currentPageIndex],
    );
  }
}
