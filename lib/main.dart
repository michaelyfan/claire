import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api.dart';

const String APP_TITLE = 'Claire';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$APP_TITLE',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
 @override
 _LoginState createState() {
   return _LoginState();
 }
}

class _LoginState extends State<Login> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$APP_TITLE"),
      ),
      body: Center(
        child: Column(
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Claire! Please log in:'
            ),
            LoginForm()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
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
    print('hereout');
    if (_formKey.currentState.validate()) {
      print('here1');
      final FirebaseUser user = await login(usernameController.text, passwordController.text);
      print('here2');
      print("ID: ${user.uid}");
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
              if (value.isEmpty) {
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
              if (value.isEmpty) {
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

