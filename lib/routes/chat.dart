import 'package:claire/api.dart';
import 'package:claire/classes.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        _isComposing = _textController.text.trim().length > 0;
      });
    });

    super.initState();
  }

  void _handleSubmitted(String text, String conversationId) {
    _textController.clear();
    sendMessage(text, conversationId);
  }

  Widget _buildTextComposer(conversationId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: (text) => _handleSubmitted(text, conversationId),
              decoration: InputDecoration.collapsed(
                  hintText: "Send a message"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text, conversationId)
                  : null
            ),
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
      future: getCurrentUserConversation(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error happened. Try again?');
        }
        if (snapshot.hasData) {
          String conversationId = snapshot.data;
          return StreamBuilder<Conversation>(
            stream: getConversationDetails(conversationId),
            builder: (BuildContext context, AsyncSnapshot<Conversation> snapshot2) {
              if (snapshot2.hasError) {
                print(snapshot2.error);
                return Text('Error happened. Try again?');
              }
              if (snapshot2.hasData && snapshot2.data != null) {
                return Column(
                  children: [
                    StreamBuilder<List<Message>>(
                      stream: getConversationMessages(conversationId),
                      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot3) {
                        if (snapshot3.hasData && snapshot3.data != null) {
                          List<Message> messages = snapshot3.data;
                          return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              reverse: true,
                              itemBuilder: (_, int index) => ChatMessage(message: messages[index]),
                              itemCount: messages.length,
                            ),
                          );
                        } else {
                          return Text('No messages sent -- start the conversation!');
                        }
                      }
                    ),
                    Divider(height: 1.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor
                      ),
                      child: _buildTextComposer(conversationId),
                    )
                  ]
                );
              } else {
                return Text('Could not retrieve conversation details -- try again?');
              }
            }
          );
        }
        return Text('No conversations yet -- start swiping!');
      }
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({
    this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Container(
//            margin: const EdgeInsets.only(right: 16.0),
//            child: CircleAvatar(child: Text(_name[0])),
//          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${message.sender} says:', style: Theme.of(context).textTheme.subhead),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(message.content),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
