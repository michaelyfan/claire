import 'package:claire/routes/chat.dart';
import 'package:claire/routes/swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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

  _switchView(viewNumber) {
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
            onPressed: () => _switchView(0),
            child: Text('Swiper view')
        ),
        RaisedButton(
            onPressed: () => _switchView(1),
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
