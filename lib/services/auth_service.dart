import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //register
  Future<User?> register(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  //login
  Future<User?> login(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  //logout
  Future<void> logout() async => await auth.signOut();

  //stream for auth changes
  Stream<User?> get userChanges => auth.authStateChanges();
}


