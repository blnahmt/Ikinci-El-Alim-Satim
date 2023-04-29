import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  static final _instance = AuthManager._();
  AuthManager._();
  factory AuthManager() => _instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signINWithEmail(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<User?> signUPWithEmail(String email, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return credential.user;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> requestPasswordReset(String mail) async {
    await auth.sendPasswordResetEmail(email: mail);
  }
}
