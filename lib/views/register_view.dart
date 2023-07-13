import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 700,
          child: Column(
            children: [
              TextField(
                controller: _email,
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
                              .createUser(email: email, password: password);
                          await AuthService.firebase().sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyMailRoute);
                        } on InvalidEmailException {
                          await showErrorDialog(
                            context,
                            'Invalid Email',
                          );
                        } on EmailAlreadyInUseException {
                          await showErrorDialog(
                            context,
                            'Email already in use',
                          );
                        } on WeakPasswordException {
                          await showErrorDialog(
                            context,
                            "Weak Password",
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                              context, 'Invalid Email or Password');
                        }
                      },
                      child: const Text("Register")),
                  TextButton(
                      onPressed: () => {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute, (route) => false)
                          },
                      child: const Text('Login here!')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
