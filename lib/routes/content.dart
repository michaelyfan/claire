import 'package:claire/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:claire/api.dart';
import 'package:claire/routes/profile.dart';

class Content extends StatefulWidget {
  @override
  ContentState createState() {
    return ContentState();
  }
}

class ContentState extends State<Content> {
  // where 0 is swipes view, 1 is chat view
  int view = 0;

  switchView(viewNumber) {
    if (viewNumber != 0 && viewNumber != 1) {
      return;
    }
    setState(() {
      view = viewNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentView;
    if (view == 0) {
      currentView = Swiper();
    } else { // view == 1
      currentView = Chat();
    }

    return Column(
      children: <Widget>[
        Text(
          'This is the content page.',
          style: TextStyle(
              fontSize: 20.0
          ),
        ),
        RaisedButton(
            onPressed: () => switchView(0),
            child: Text('Swiper view')
        ),
        RaisedButton(
            onPressed: () => switchView(1),
            child: Text('Chat view')
        ),
        RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: Text('My profile')
        ),
        Flexible(
          flex: 1,
          child: currentView,
        ),
        RaisedButton(
            onPressed: () => logout(),
            child: Text('Log Out')
        ),
      ],
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<User>>(
        stream: getUsers(null,0,0),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (!snapshot.hasData) {
            return Text('Something went wrong... :(');
          }
          List<User> users = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                User thisUser = users[index];
                return Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text('${thisUser.name} -- ${thisUser.age}'),
                );
              }
            )
          );
        },
      )
    );
  }
}

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text('Chat is under construction');
  }
}

class OtherUser {

}
