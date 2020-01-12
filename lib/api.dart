import 'package:claire/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _database = FirebaseDatabase.instance;

bool isNull(dynamic foo) {
  List nullArr = [null, Null];
  return nullArr.contains(foo);
}

Future<String> getUserName(String id) {
  return _database.reference().child('users/$id').once().then((snapshot) {
    return snapshot.value['name'];
  });
}

Future<FirebaseUser> getCurrentUser() {
  return _auth.currentUser();
}

Future<User> getCurrentUserDetails() async {
  FirebaseUser currentUser = await getCurrentUser();
  return _database.reference().child('users/${currentUser.uid}').once().then((snapshot) {
    List<String> seen = <String>[];
    List<String> swiped = <String>[];
//    print("snapshot: ${snapshot.value['seen']}");
//    print("snapshot type: ${snapshot.value['seen'].runtimeType}");
//    print("snapshot type equal to null?: ${snapshot.value['seen'].runtimeType == null}");
//    print("snapshot type equal to Null?: ${snapshot.value['seen'].runtimeType == Null}");
    if (![null, Null].contains(snapshot.value['seen'].runtimeType)) {
      seen = new List<String>.from(snapshot.value['seen'].keys);
    }
    if (![null, Null].contains(snapshot.value['swiped'].runtimeType)) {
      swiped = new List<String>.from(snapshot.value['swiped'].keys);
    }
    return User(
      name: snapshot.value['name'],
      age: snapshot.value['age'],
      bio: snapshot.value['bio'],
      id: snapshot.value['id'],
      gender: snapshot.value['gender'],
      email: snapshot.value['email'],
      genderWant: snapshot.value['genderWant'],
      seen: seen,
      swiped: swiped,
    );
  });
}

Future<String> getCurrentUserConversation() async {
  FirebaseUser currentUser = await getCurrentUser();
  return _database.reference().child('users/${currentUser.uid}/conversation').once().then((snapshot) {
    return snapshot.value;
  });
}

Stream<User> listenCurrentUserDetails(String id) {
  return _database.reference().child('users/$id').onValue.map((event) {
    List<String> seen = <String>[];
    List<String> swiped = <String>[];
    if (![null, Null].contains(event.snapshot.value['seen'].runtimeType)) {
      seen = new List<String>.from(event.snapshot.value['seen'].keys);
    }
    if (![null, Null].contains(event.snapshot.value['swiped'].runtimeType)) {
      swiped = new List<String>.from(event.snapshot.value['swiped'].keys);
    }
    return User(
      name: event.snapshot.value['name'],
      age: event.snapshot.value['age'],
      bio: event.snapshot.value['bio'],
      id: event.snapshot.value['id'],
      gender: event.snapshot.value['gender'],
      email: event.snapshot.value['email'],
      genderWant: event.snapshot.value['genderWant'],
      seen: seen,
      swiped: swiped,
    );
  });
}

Future<FirebaseUser> login(String username, String password) {
  return _auth.signInWithEmailAndPassword(email: username, password: password).then((res) {
    return res.user;
  });
}

/// Finds potential dates for the current user that are:
///  1. within [distance] (future feature)
///  2. of user's preferred [gender] (1 for males, 0 for females) (future feature)
///  3. haven't already been seen by the user. IDs of users already seen by the current user are in [seen].
///  4. Are not the current user him/herself. The current user has id [id].
Stream<List<User>> getUsers(String id, int distance, int gender, List<String> seen) {
  return _database.reference().child('users').onValue.map((event) {
    List<User> toReturn = <User>[];
    for (MapEntry me in event.snapshot.value.entries) {
      toReturn.add(User(
        id: me.key,
        name: me.value['name'],
        gender: me.value['gender'],
        age: me.value['age'],
        bio: me.value['bio'],
        email: me.value['email'],
      ));
    }

    // filters out ineligible users (at this moment, only users not swiped, and not the current user)
    toReturn = List<User>.from(toReturn.where((User user) {
      return seen.indexOf(user.id) == -1 && user.gender == gender && user.id != id;
    }));
    return toReturn;
  });
}

Stream<FirebaseUser> listenAuthState() {
  return _auth.onAuthStateChanged;
}

Future<void> logout() {
  return _auth.signOut();
}

/// Records that the current user has seen, and rejected (AKA swiped
/// left on) [user].
Future<void> rejectUser(User user) async {
  FirebaseUser currentUser = await getCurrentUser();
  await _database.reference()
    .child('users/${currentUser.uid}/seen/${user.id}/id')
    .set(user.id);
  return Future.value(null);
}

/// Creates a record that the current user has seen, and accepted (AKA swiped
/// right on) [user]. If [user] has also swiped right on the current user,
/// adds both users to a conversation. Returns a future that evaluates to true
/// if [user] has also swiped on the current user, and evaluates to false
/// otherwise.
Future<bool> acceptUser(User user) async {
  FirebaseUser currentUser = await getCurrentUser();
//  print('Going to inspect swiped property of user ${user.id} for ID ${currentUser.uid}');
  List results = await Future.wait([
    _database.reference().child('users/${currentUser.uid}/seen/${user.id}/id').set(user.id),
    _database.reference().child('users/${currentUser.uid}/swiped/${user.id}/id').set(user.id),
    _database.reference().child('users/${user.id}/swiped/${currentUser.uid}').once(),
  ]);
  return Future.value(!isNull(results[2].value));
}

Future<Map> getConversationUserNames (Conversation convo) {

}

/// Gets the details the conversation of user [uid]. This does NOT
/// include conversation messages. The stream will contain null if the current
/// user is not in a conversation.
Stream<Conversation> getConversationDetails(String uid) {
  return _database.reference().child('conversation/$uid').onValue.map((event) {
    return Conversation(
      id: event.snapshot.key,
      sentiment: event.snapshot.value['sentiment'].toDouble(),
      user1: event.snapshot.value['user1'],
      user2: event.snapshot.value['user2'],
    );
  });
}

/// Gets the messages for conversation with id [uid]. This does NOT
/// include conversation details.
Stream<List<Message>> getConversationMessages(String uid) {
  return _database.reference()
    .child('messages')
    .orderByChild('conversation')
    .equalTo(uid)
    .onValue.map((event) {
    List<Message> toReturn = <Message>[];
    for (MapEntry me in event.snapshot.value.entries) {
      toReturn.add(Message(
        id: me.key,
        content: me.value['content'],
        conversationId: me.value['conversation'],
        sender: me.value['sender'],
        timestamp: me.value['timestamp'],
      ));
    }

    // sort messages by timestamp before returning
    toReturn.sort((a, b) => a.timestamp - b.timestamp);

    return toReturn;
  });
}

/// Creates a conversation between the current user and user [otherUserId].
Future<void> createConversation(String otherUserId) async {
  FirebaseUser currentUser = await getCurrentUser();
  DatabaseReference creationResult = _database.reference()
    .child('conversation')
    .push();
  String conversationId = creationResult.key;
  Map conversationObj = {
    'id': conversationId,
    'sentiment': 0.0,
    'user1': currentUser.uid,
    'user2': otherUserId
  };
  return Future.wait([
    _database.reference().child('conversation/$conversationId').set(conversationObj),
    _database.reference().child('users/${currentUser.uid}/conversation').set(conversationId),
    _database.reference().child('users/$otherUserId/conversation').set(conversationId)
  ]);
}

/// Adds a message with [content] to the [conversationId] conversation.
Future<void> sendMessage(String content, String conversationId) async {
  FirebaseUser currentUser = await getCurrentUser();
  DatabaseReference newRef = _database.reference().child('messages').push();
  Map messageObj = {
    'content': content,
    'conversation': conversationId,
    'sender': currentUser.uid,
    'timestamp': ServerValue.timestamp
  };
  return _database.reference().child('messages/${newRef.key}').set(messageObj);
}
