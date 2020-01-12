import 'package:claire/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:claire/api.dart';

class Swiper extends StatefulWidget {
  @override
  State<Swiper> createState() {
    return SwiperState();
  }
}

class SwiperState extends State<Swiper> {

  @override
  void initState() {
    print('SwiperState widget rendered');
    super.initState();
  }

  void _handleReject(User user) async {
    await rejectUser(user);
  }

  void _handleAccept(User user) async {
    bool otherUserAlsoSwiped;
    try {
      otherUserAlsoSwiped = await acceptUser(user);
    } catch (e) {
      print('error happened. $e');
    }
    if (otherUserAlsoSwiped) {
      print('Other user swiped!');
      createConversation(user.id);
    }
  }

  Widget _buildSwipeCard(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Text('${user.name}, age ${user.age}'),
          Text(
            user.bio,
            style: TextStyle(
              fontSize: 30.0
            ),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () => _handleReject(user),
                child: Text('Reject')
              ),
              RaisedButton(
                onPressed: () => _handleAccept(user),
                child: Text('Accept')
              ),
            ],
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (!snapshot.hasData) {
          print(snapshot.error);
          return Text('Error happened, try again.');
        }
        return StreamBuilder(
          stream: listenCurrentUserDetails(snapshot.data.uid),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot2) {
            if (snapshot2.hasError) {
              print(snapshot2.error);
              return Text('Error happened, try again.');
            }
            if (snapshot2.hasData) {
              return Center(
                  child: StreamBuilder<List<User>>(
                    stream: getUsers(snapshot2.data.id, null, snapshot2.data.genderWant, snapshot2.data.seen),
                    builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot3) {
                      if (!snapshot3.hasData) {
                        return Text('No data detected, maybe something went wrong lmao idk');
                      }
                      List<User> users = snapshot3.data;
                      if (users.length == 0) {
                        return Text('You\'ve reached the end of the queue. Look at you!');
                      }
                      return Container(
                          child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildSwipeCard(context, users[index]);
                              }
                          )
                      );
                    },
                  )
              );
            }
            return Text('User details not retrieved. Try again?');
          }
        );
      }
    );
  }
}