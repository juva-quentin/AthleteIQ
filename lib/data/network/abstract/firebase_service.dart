import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseService {
  Future<UserCredential> loginUserWithFirebase(String email, String password);
  Future<UserCredential> signupUserWithFirebase(String email, String password, String name, String genre);
  void signOutuser();
  bool isUserLoggedIn();
}