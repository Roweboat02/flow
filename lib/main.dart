import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow/Login/guest_screen.dart';
import 'package:flow/Pages/chat/chats_page.dart';
import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flow/Pages/feed_page.dart';
import 'package:flow/firebase_options.dart';
import 'package:flow/Login/login_screen.dart';
import 'package:flow/Pages/shed_page.dart';
import 'package:flow/Constructs/person.dart';
import 'package:flow/Login/signup_screen.dart';
import 'package:flow/Login/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'Pages/chat/new_chat_page.dart';
import 'Pages/new_post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Person? _user = null;

    setUser(Person user) {
      _user = user;
    }

    return MaterialApp(
      title: 'Neighbor',
      initialRoute: "welcome_screen",
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(setUser),
        'login_screen': (context) => LoginScreen(setUser),
        'guest_screen': (context) => GuestScreen(setUser),
        'home_screen': (context) => NavigationExample(
            title: 'Neighbor', user: _user!, db: DatabaseProxy(_user!)),
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
  const NavigationExample(
      {super.key, required this.title, required this.user, required this.db});
  final DatabaseProxy db;
  final Person user;
  final String title;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  late List pages;
  int currentPageIndex = 0;

  @override
  void initState() {
    pages = [
      Shed(widget.db, widget.user),
      Feed(widget.db, widget.user),
      ChatsPage(widget.db, widget.user)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: currentPageIndex != 2
            ? () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewPostPage(widget.db)))
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewChatPage(widget.db, widget.user))),
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Shed',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.view_list),
              icon: Icon(Icons.view_list),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.messenger_sharp),
              label: 'Messages',
            )
          ]),
      body: pages.map((page) => page.page(context)).toList()[currentPageIndex],
    );
  }
}
