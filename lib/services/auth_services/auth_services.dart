import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Future<User> signInAnonymouse() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<User> signUpWithEmail(String email, String password) async {
    
      final res = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
     final User user = res.user;
      return user;
    
  }

  static Future<User> signInEmail(String email, String password) async {
    final res =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = res.user;

    return user;
  }

  static signOut() {
    auth.signOut();
  }

  static Stream<User> get firebaseUserStream => auth.authStateChanges();
}
