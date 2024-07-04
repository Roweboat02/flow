import 'package:flow/database_proxy.dart';
import 'package:flow/login/new_user.dart';
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
  late String username;
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
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username')),
            const SizedBox(
              height: 8.0,
            ),
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
                  if (await DatabaseProxy.userExists(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("email-already-in-use"),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'ACTION',
                          onPressed: () {},
                        )));
                  } else {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    user.user!.updateDisplayName(username);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewUserPage(user)));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == "email-already-in-use") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("email-already-in-use"),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'ACTION',
                        onPressed: () {},
                      ),
                    ));
                  } else if (e.code == "weak-password") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("weak-password"),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'ACTION',
                        onPressed: () {},
                      ),
                    ));
                  } else if (e.code == "invalid-email") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("invalid-email"),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'ACTION',
                        onPressed: () {},
                      ),
                    ));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
