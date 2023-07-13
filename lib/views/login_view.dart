import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';

import '../services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';

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
                          await AuthService.firebase()
                              .logIn(email: email, password: password);
                          final user = AuthService.firebase().currentUser;
                          if (user != null) {
                            if (user.isEmailVerified) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  notesRoute, (route) => false);
                            } else {
                              await AuthService.firebase()
                                  .sendEmailVerification();
                              Navigator.of(context).pushNamed(verifyMailRoute);
                            }
                          }
                        } on UserNotFoundAuthException {
                          await showErrorDialog(
                            context,
                            'User not found',
                          );
                        } on WrongPasswordAuthException {
                          await showErrorDialog(
                            context,
                            'Wrong Password',
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Invalid Email or Password',
                          );
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
