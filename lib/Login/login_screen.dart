import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/Constructs/person.dart';
import 'package:flow/DatabaseProxy/database_proxy.dart';
import 'package:flutter/material.dart';

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
    ));

class LoginScreen extends StatefulWidget {
  final Function setUser;
  const LoginScreen(this.setUser, {super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool showSpinner = false;
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
                  hintText: 'Enter your email',
                )),
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
                    hintText: 'Enter your password')),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
                child: const Text('Log In'),
                onPressed: () async {
                  try {
                    final userCred = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    widget.setUser(Person(
                        Image.network(
                            await DatabaseProxy.getProfilePictureURL()),
                        userCred.user!.displayName!,
                        userCred.user!.uid));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "user-not-found") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("user-not-found"),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'ACTION',
                          onPressed: () {},
                        ),
                      ));
                    } else if (e.code == "wrong-password") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("wrong-password"),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'ACTION',
                          onPressed: () {},
                        ),
                      ));
                    }
                  } finally {
                    Navigator.pushNamed(context, 'home_screen');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
