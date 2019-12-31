import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> login(username, password) {
  final AuthCredential credential = EmailAuthProvider.getCredential(
    email: username,
    password: password,
  );
  return _auth.signInWithCredential(credential).then((res) {
    return res.user;
  });
  return _auth.signInWithEmailAndPassword(email: username, password: password).then((res) {
    return res.user;
  });
}