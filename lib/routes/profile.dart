import 'package:flutter/material.dart';
import '../api.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() {
    return ProfileState();
  }

}

class ProfileState extends State<Profile> {
  String email = '';
  String id = '';

  @override
  void initState() {
    getCurrentUser().then((myUser) {
      setState(() {
        email = myUser.email;
        id = myUser.uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: <Widget>[
          Text("$email"),
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
}
