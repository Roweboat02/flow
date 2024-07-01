import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

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
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email')),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Password')),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                try {
                  await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Email already in use"),
                        duration: const Duration(seconds: 1),
                      ));
                    });
                  } else if (e.code == "weak-password") {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password Too Weak"),
                        duration: const Duration(seconds: 1),
                      ));
                    });
                  }
                } finally {
                  Navigator.pushNamed(context, 'new_user_screen');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
