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
      body: SizedBox(
        width: 500,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: const Text('Log In'),
                onPressed: () {
                  Navigator.pushNamed(context, 'login_screen');
                },
              ),
              ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'registration_screen');
                  }),
            ]),
      ),
    );
  }
}
