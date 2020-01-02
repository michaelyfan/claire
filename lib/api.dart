import 'package:claire/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _database = FirebaseDatabase.instance;

Future<FirebaseUser> getCurrentUser() {
  return _auth.currentUser();
}

Future<FirebaseUser> login(String username, String password) {
  return _auth.signInWithEmailAndPassword(email: username, password: password).then((res) {
    return res.user;
  });
}

/// Finds potential dates for a [user] that are within [distance] and are of
/// user's preferred [gender] (1 for males, 0 for females).
Stream<List<User>> getUsers(FirebaseUser user, int gender, int distance) {
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
    return toReturn;
  });
}

Stream<FirebaseUser> listenAuthState() {
  return _auth.onAuthStateChanged;
}

Future<FirebaseUser> logout() {
  return _auth.signOut();
}
