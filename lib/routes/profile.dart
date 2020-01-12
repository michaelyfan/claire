import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../api.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() {
    return ProfileState();
  }

}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          String name = snapshot.data.displayName;
          String id = snapshot.data.uid;
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
            ),
            body: Column(
              children: <Widget>[
                Text("$name"),
                Text("ID: $id"),
                RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go back')
                ),
              ],
            ),
          );
        }
        return null;
      }
    );
  }
}
