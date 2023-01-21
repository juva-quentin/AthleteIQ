import 'package:firebase_auth/firebase_auth.dart';

import 'abstract/firebase_service.dart';

class FirebaseServiceImpl implements FirebaseService {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  bool isUserLoggedIn() {
    if (auth.currentUser != null) { return true; }else{ return false; }
  }

  @override
  Future<UserCredential> loginUserWithFirebase(String email, String password) {
    final userCredential = auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  @override
  void signOutuser() {
    auth.signOut();
  }

  @override
  Future<UserCredential> signupUserWithFirebase(String email, String password, String name, String genre) {
    final userCredential = auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
  
}