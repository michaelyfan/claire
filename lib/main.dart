// Invoke "debug painting" (press "p" in the console, choose the
// "Toggle Debug Paint" action from the Flutter Inspector in Android
// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// to see the wireframe for each widget.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'routes/login.dart';
import 'routes/content.dart';

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

        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  MainState createState() {
    return MainState();
  }
}

class MainState extends State<Main> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$APP_TITLE"),
      ),
      body: new StreamBuilder(
        stream: listenAuthState(),
        builder: (_, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return Content();
          }

          return Login();
        },
      ),
    );
  }
}
