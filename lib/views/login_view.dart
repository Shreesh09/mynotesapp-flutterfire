import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 700,
          child: Column(
            children: [
              TextField(
                controller: _email,
                obscureText: false,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Enter your e-mail here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                    hintText: 'Enter your password here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            if (user.emailVerified) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  notesRoute, (route) => false);
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyMailRoute, (route) => false);
                            }
                          }
                          devtools.log(userCredential.toString());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            devtools.log('user-not-found');
                          } else if (e.code == 'wrong-password') {
                            devtools.log('wrong-password');
                          }
                        }
                      },
                      child: const Text("Login")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute, (route) => false);
                      },
                      child: const Text("Register here!")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
