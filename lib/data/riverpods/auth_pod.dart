import 'package:athlete_iq/utils/crypt.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/FireStoreServiceImpl.dart';
import '../network/firebase_service_impl.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserCredential? _userCredential;
  Map<String, dynamic> _userData = {};
  FirebaseServiceImpl fauth = FirebaseServiceImpl();
  FirestoreServiceImpl fstore = FirestoreServiceImpl();

  bool get isLoading => _isLoading;

  UserCredential? get userCredential => _userCredential;

  Map<String, dynamic> get userData => _userData;

  Future<UserCredential> loginUserWithFirebase(String email,
      String password) async {
    setLoader(true);
    try {
      _userCredential = await fauth.loginUserWithFirebase(email, password);
      setLoader(false);
      return _userCredential!;
    } catch (e) {
      print(e);
      setLoader(false);
      return Future.error(e);
    }
  }



  Future<UserCredential> signupUserWithFirebase(String email, String password,
      String name, String genre) async {
    var isSuccess = false;
    setLoader(true);

    CryptPassword cryptPassword = CryptPassword();

    final hashPassword = cryptPassword.hashPassword(password);

    _userCredential =
    await fauth.signupUserWithFirebase(email, hashPassword, name, genre);

    final data = {
      'email': email,
      'password': hashPassword,
      'uid': _userCredential!.user!.uid,
      'createdAt': DateTime
          .now()
          .microsecondsSinceEpoch
          .toString(),
      'name': name,
      'profilePic': '',
      'friends': [],
      'genre': genre,
      'objectif': 0,
      'totalDistance': 0,
    };
    String uid = _userCredential!.user!.uid;
    isSuccess = await addUserToDatabase(data, 'users', uid);
    if (isSuccess) {
      return _userCredential!;
    }else{
      throw Exception('Error to sign up the user');
    }

  }

  Future<bool> addUserToDatabase(Map<String, dynamic> data, String collectionName, String docName) async{
    var value = false;
    try{
      await fstore.addDataToFirestore(data, collectionName, docName);
      value = true;
    }catch(e){
      print(e);
      value = false;
    };
    return value;

  }

  void logoutUser(){
    fauth.signOutuser();
  }

  setLoader(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }
}

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref)=> AuthProvider());