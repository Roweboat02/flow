import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Log In'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
                ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'registration_screen');
                    }),
                ElevatedButton(
                    child: const Text('Log In With Google'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'google_login_screen');
                    }),
              ]),
        ));
  }
}
