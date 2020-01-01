import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> getCurrentUser() {
  return _auth.currentUser();
}

Future<FirebaseUser> login(username, password) {
  return _auth.signInWithEmailAndPassword(email: username, password: password).then((res) {
    return res.user;
  });
}

Stream<FirebaseUser> listenAuthState() {
  return _auth.onAuthStateChanged;
}

Future<FirebaseUser> logout() {
  return _auth.signOut();
}
