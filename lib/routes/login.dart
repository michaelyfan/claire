import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      final FirebaseUser user = await login(
        usernameController.text.trim(),
        passwordController.text.trim()
      );
      print("User ID: ${user.uid}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Username'
            ),
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Username cannot be empty';
              }
              return null;
            },
            controller: usernameController,
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Password'
            ),
            validator: (value) {
              if (value.trim().isEmpty) {
                return 'Password cannot be empty';
              }
              return null;
            },
            controller: passwordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () => _handleSubmit(),
              child: Text('Log In'),
            ),
          ),
        ],
      ),
    );
  }
}
