import 'package:claire/api.dart';
import 'package:claire/routes/profile.dart';
import 'package:flutter/material.dart';

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
      currentView = Text(
        'SWIPES VIEW!'
      );
    } else { // view == 1
      currentView = Text(
        'CHAT VIEW!'
      );
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
            child: Text('Swipes view')
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
        Container(
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
